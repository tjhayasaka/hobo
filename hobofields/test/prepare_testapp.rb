require 'fileutils'
TEST_APP_ROOT = File.expand_path('../testapp',__FILE__)
FileUtils.cp_r File.expand_path('../pristine_testapp',__FILE__), TEST_APP_ROOT
Dir.chdir( TEST_APP_ROOT )
require 'rails'
require 'config/environment'
require 'rails/generators'
Rails::Generators.configure!

