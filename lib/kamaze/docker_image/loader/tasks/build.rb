# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# @type [Kamaze::DockerImage::Loader::Helper] helper

if image.available_commands.include?(:build)
  desc 'Build image'

  task helper.appoint(:build), [:cached] do |task, args|
    autoload(:YAML, 'yaml')

    YAML.safe_load(args.key?(:cached) ? args[:cached] : 'true').tap do |cached|
      helper.call(task, args) { cached ? image.build : image.rebuild }
    end

    task.reenable
  end
end
