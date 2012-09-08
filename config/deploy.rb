require "bundler/capistrano"

# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
set :application, "square-meals"
set :repository,  "git@github.com:jtescher/square-meals.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "108.229.114.114"
role :app, "108.229.114.114"

# =============================================================================
# OPTIONAL VARIABLES
# =============================================================================
set :deploy_to, "/srv/square-meals"  # CHANGE THIS LINE TO POINT TO THE CORRECT PATH
set :user, "root"  # CHANGE THIS LINE TO USE YOUR OCS USERNAME
set :use_sudo, false
set :deploy_via, :remote_cache
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

require 'capistrano-unicorn'