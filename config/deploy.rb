# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'cocona'
set :repo_url, 'git@github.com:kironono/cocona.git'

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/cocona/projects/cocona'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :airbrussh.
set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_files, [
  'config/database.yml',
  'config/secrets.yml',
  'config/cable.yml',
  'config/settings.yml',
]

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system')
set :linked_dirs, [
  'log',
  'tmp/pids',
  'tmp/cache',
  'tmp/sockets',
  'public/system',
  'data',
]

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :default_env, {
  rbenv_root: "#{fetch(:rbenv_path)}",
  path: "#{fetch(:rbenv_path)}/shims:#{fetch(:rbenv_path)}/bin:$PATH"
}

# Default value for keep_releases is 5
set :keep_releases, 5

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value


#namespace :deploy do
#
#  after :restart, :clear_cache do
#    on roles(:web), in: :groups, limit: 3, wait: 10 do
#      # Here we can do anything such as:
#      # within release_path do
#      #   execute :rake, 'cache:clear'
#      # end
#    end
#  end
#
#end

namespace :supervisorctl do

  desc 'supervisorctl start'
  task :start do
    on roles(:app) do
      execute "sudo supervisorctl start all"
    end
  end

  desc 'supervisorctl stop'
  task :stop do
    on roles(:app) do
      execute "sudo supervisorctl stop all"
    end
  end

  desc 'supervisorctl restart'
  task :restart do
    on roles(:app) do
      execute "sudo supervisorctl restart all"
    end
  end

  desc 'supervisorctl status'
  task :status do
    on roles(:app) do
      execute "sudo supervisorctl status"
    end
  end

end
