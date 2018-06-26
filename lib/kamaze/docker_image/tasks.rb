# frozen_string_literal: true

namer = lambda do |name|
  "#{image.tasks_ns}:#{name}".gsub(/^:/, '')
end

desc 'Build image'
task namer.call(:build) do
  image.build
end

desc 'Run a command in a running container'
task namer.call(:exec), [:command] do |_task, args|
  image.exec(args[:command])
end

desc 'Run a command in a new container'
task namer.call(:run), [:command] do |_task, args|
  image.run(args[:command])
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
