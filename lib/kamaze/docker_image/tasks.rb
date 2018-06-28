# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require 'rake/dsl_definition'

self.extend(Rake::DSL)

namer = lambda do |name|
  "#{image.tasks_ns}:#{name}".gsub(/^:/, '')
end

desc 'Build image'
task namer.call(:build) do |task|
  image.build
  task.reenable
end

desc 'Run a command in a running container'
task namer.call(:exec), [:command] do |task, args|
  Rake::Task[namer.call(:start)].invoke

  image.exec(args[:command])
  task.reenable
end

desc 'Run a command in a new container'
task namer.call(:run), [:command] do |task, args|
  image.run(args[:command])
  task.reenable
end

desc 'Start container as %<run_as>s' % { run_as: image.run_as }
task namer.call(:start) do
  image.start
end

desc 'Stop container'
task namer.call(:stop) do
  image.stop
end

desc 'Restart container'
task namer.call(:restart) do
  image.restart
end
