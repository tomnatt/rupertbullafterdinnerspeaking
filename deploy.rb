require 'mina/bundler'
require 'mina/git'

set :user, ENV['HOSTING_USER']
set :deploy_to, ENV['RUPERTBULL_HOSTING_DIR']
set :domain, 'rupertbullafterdinnerspeaking.co.uk'
set :repository, 'git@github.com:tomnatt/rupertbullafterdinnerspeaking.git'
set :branch, 'master'

set :shared_paths, []

task :setup do
  queue 'echo "-----> Create shared paths"'
  shared_dirs = shared_paths.map do |file|
    # this is a path if no extension
    # otherwise, we need to lose the filename
    path = "#{deploy_to}/#{shared_path}/#{file}"
    if File.extname(path).empty?
      path
    else
      File.dirname(path)
    end
  end.uniq

  shared_dirs.map do |dir|
    queue echo_cmd "mkdir -p #{dir}"
    queue echo_cmd "chmod g+rx,u+rwx #{dir}"
  end
end

desc "Deploys the current version to the server."
task :deploy do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    # cleanup
    invoke :'deploy:cleanup'
  end
end
