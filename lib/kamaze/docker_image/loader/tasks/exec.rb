# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# @type [Kamaze::DockerImage::Loader::Helper] helper

if image.available_commands.include?(:exec)
  desc 'Run a command in a running container'

  task helper.appoint(:exec), [:command] do |task, args|
    helper.call(task, args) do
      Rake::Task[namer.call(:start)].execute
      image.exec(args[:command])
    end

    task.reenable
  end
end
