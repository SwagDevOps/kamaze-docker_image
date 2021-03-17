# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# @type [Kamaze::DockerImage::Loader::Helper] helper

if image.available_commands.include?(:start)
  desc 'Start container as %<run_as>s' % { run_as: image.run_as }

  task helper.appoint(:start) do |task|
    helper.call(task) { image.start }

    task.reenable
  end
end
