# -*- encoding: utf-8 -*-
# stub: zxing_cpp 0.1.1 ruby lib ext
# stub: ext/zxing/extconf.rb

Gem::Specification.new do |s|
  s.name = "zxing_cpp".freeze
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze, "ext".freeze]
  s.authors = ["Benjamin Dobell".freeze]
  s.date = "2016-07-19"
  s.description = "A barcode and QR code library that works with regular Ruby (not just JRuby). This gem comes bundled with ZXing C++ (zxing-cpp) and interfaces with it using FFI. As such this gem works with most major Ruby distributions.".freeze
  s.email = ["benjamin.dobell@glassechidna.com.au".freeze]
  s.executables = ["zxd".freeze, "zxe".freeze]
  s.extensions = ["ext/zxing/extconf.rb".freeze]
  s.extra_rdoc_files = ["README.rdoc".freeze]
  s.files = ["README.rdoc".freeze, "bin/zxd".freeze, "bin/zxe".freeze, "ext/zxing/extconf.rb".freeze]
  s.homepage = "https://github.com/glassechidna/zxing_cpp.rb".freeze
  s.licenses = ["MIT".freeze, "Apache-2.0".freeze]
  s.rdoc_options = ["--main".freeze, "README.rdoc".freeze]
  s.rubygems_version = "3.3.3".freeze
  s.summary = "A barcode and QR code library.".freeze

  s.installed_by_version = "3.3.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<bundler>.freeze, ["~> 1.6"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 10.4"])
    s.add_development_dependency(%q<rake-compiler>.freeze, ["~> 0.9"])
    s.add_development_dependency(%q<shoulda>.freeze, ["~> 3.5"])
    s.add_runtime_dependency(%q<ffi>.freeze, ["~> 1.1"])
    s.add_runtime_dependency(%q<rmagick>.freeze, ["~> 2.13"])
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.6"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.4"])
    s.add_dependency(%q<rake-compiler>.freeze, ["~> 0.9"])
    s.add_dependency(%q<shoulda>.freeze, ["~> 3.5"])
    s.add_dependency(%q<ffi>.freeze, ["~> 1.1"])
    s.add_dependency(%q<rmagick>.freeze, ["~> 2.13"])
  end
end
