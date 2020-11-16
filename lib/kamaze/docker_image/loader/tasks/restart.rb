# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# @type [Kamaze::DockerImage::Loader::Helper] helper

%i[start stop].map { |v| image.available_commands.include?(v) }.uniq.tap do |v|
  if v == [true]
    desc 'Restart container'

    task helper.appoint(:restart) do |task|
      helper.call(task) { image.restart }

      task.reenable
    end
  end
end
