# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# @type [Kamaze::DockerImage::Loader::Context] self
self.singleton_class.__send__(:define_method, :helper) do
  helper
end

# tasks --------------------------------------------------------------

Dir.glob(tasks_dir.join('*.rb')).map { |fp| Pathname.new(fp) }.each do |file|
  self.instance_eval(file.read, file.to_s, 1)
end
