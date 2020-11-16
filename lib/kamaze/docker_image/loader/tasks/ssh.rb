# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# @type [Kamaze::DockerImage::Loader::Helper] helper

if image.ssh.enabled?
  desc 'Connect to container using Secure Shell (SSH)'

  task helper.appoint(:ssh), [:command] do |task, args|
    helper.call(task) { image.ssh.call(args[:command]) }

    task.reenable
  end
end
