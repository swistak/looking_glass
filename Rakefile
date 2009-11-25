begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

ensure_in_path 'lib'
ensure_in_path 'test'
require 'looking_glass'

task :default => 'test:run'
task 'gem:release' => 'test:run'

Bones {
  name  'looking_glass'
  authors  'Marcin Raczkowski'
  email  'marcin.raczkowski@gmail.com'
  url  'http://github.com/swistak/looking_glass'
  version  LookingGlass::VERSION
  ignore_file  '.gitignore'
}

# EOF
