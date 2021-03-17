# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# @type [Kamaze::DockerImage::Loader::Helper] helper

if image.available_commands.include?(:exec)
  desc 'Run a command in a running container'

  task helper.appoint(:exec), [:command] do |task, args|
    helper.call(task, args) { image.exec(args[:command]) }

    task.reenable
  end
end
