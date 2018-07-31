# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# Make task name using namespace (from image)
#
# @return [String]
namer = lambda do |name|
  "#{image.tasks_ns}:#{name}".gsub(/^:/, '')
end

# Execute related ``pre_`` and ``post_`` tasks
#
# Sample of use:
#
# ```ruby
# task 'docker:pre_start' do |task, args|
#   pp(task, args)
# end
#
# task 'docker:post_start' do |task, args|
#   pp(task, args)
# end
# ```
wrapper = lambda do |task, args = nil, &block|
  tasks = lambda do |name|
    Rake::Task[name].execute(**args.to_h) if Rake::Task.task_defined?(name)
  end

  cname = task.name.gsub(/^#{image.tasks_ns}:/, '')
  names = {
    pre: namer.call("pre_#{cname}"),
    post: namer.call("post_#{cname}"),
  }

  names.fetch(:pre).tap { |name| tasks.call(name) }
  block.call
  task.reenable
  names.fetch(:post).tap { |name| tasks.call(name) }
end

# tasks --------------------------------------------------------------

desc 'Build image'
task namer.call(:build) do |task|
  wrapper.call(task) { image.build }
end

desc 'Run a command in a running container'
task namer.call(:exec), [:command] do |task, args|
  wrapper.call(task, args) do
    Rake::Task[namer.call(:start)].execute
    image.exec(args[:command])
  end
end

desc 'Run a command in a new container'
task namer.call(:run), [:command] do |task, args|
  wrapper.call(task, args) { image.run(args[:command]) }
end

desc 'Start container as %<run_as>s' % { run_as: image.run_as }
task namer.call(:start) do |task|
  wrapper.call(task) { image.start }
end

desc 'Stop container'
task namer.call(:stop) do |task|
  wrapper.call(task) { image.stop }
end

desc 'Restart container'
task namer.call(:restart) do |task|
  wrapper.call(task) { image.restart }
end

if image.ssh_runner.enabled?
  desc 'Connect to container Using Secure Shell (SSH)'
  task namer.call(:ssh), [:command] do |task, args|
    wrapper.call(task) { image.ssh_runner.call(args[:command]) }
  end
end
