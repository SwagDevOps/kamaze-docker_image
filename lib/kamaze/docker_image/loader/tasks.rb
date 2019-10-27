# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative 'helper'

self.singleton_class.__send__(:define_method, :helper) do
  Kamaze::DockerImage::Loader::Helper.new(image)
end

# tasks --------------------------------------------------------------

Pathname.new(__dir__).join('tasks').tap do |path|
  Dir.glob(path.join('*.rb')).map { |fp| Pathname.new(fp) }.each do |file|
    self.instance_eval(file.read, file.to_s, 1)
  end
end
