# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# @type [Kamaze::DockerImage::Loader::Helper] helper

if image.available_commands.include?(:push)
  desc 'Push image'

  task helper.appoint(:push) do |task|
    helper.call(task) { image.push }

    task.reenable
  end
end
