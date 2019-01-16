# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "qna"
set :repo_url, "git@github.com:rublen/qna.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qna"

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/master.key"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads"

# Default value for local_user is ENV['USER']
set :local_user, "deployer"

#recommended to set the role to :app instead of :db
set :migration_role, :app

set :rvm_type, :user
set :rvm_ruby_version, '2.5.0'

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
  after :publishing, :restart
end

# http://github.com/jamis/capistrano/blob/master/lib/capistrano/recipes/deploy.rb


