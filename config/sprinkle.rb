APP_NAME="square-meals"
HOST="square-meals.info"

package :ruby do
  description 'Ruby Virtual Machine'
  version '1.9.3-p194'
  source "http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-#{version}.tar.gz"
  requires :ruby_dependencies
end

package :ruby_dependencies do
  description 'Ruby Virtual Machine Build Dependencies'
  apt %w( build-essential libyaml-dev bison zlib1g-dev libssl-dev libreadline6-dev libncurses5-dev file )
end

package :nginx_core, :provides => :webserver do
  apt 'nginx' do
    post :install, '/etc/init.d/nginx start'
  end

  verify do
    has_executable '/usr/sbin/nginx'
    has_executable '/etc/init.d/nginx'
  end
end

package :rubygems do
  description 'Ruby Gems Package Management System'
  version '1.8.24'
  source "http://production.cf.rubygems.org/rubygems/rubygems-#{version}.tgz" do
    custom_install 'ruby setup.rb'
  end
  requires :ruby
end

package :rails do
  description 'Ruby on Rails'
  gem 'rails'
  version '3.2.8'
end

package :unicorn, :provides => :appserver do
  description 'Unicorn App Server'

  # unicorn should be installed from your app's Gemfile so there is nothing to do here

  requires :upstream_configuration, :enable_site, :restart_nginx
end

package :upstream_configuration do
  description "Nginx as Reverse Proxy Configuration for Unicorn"
  requires :nginx_core
  
  config_file = "/etc/nginx/sites-available/#{APP_NAME}"
  config_template = ERB.new(File.read(File.join(File.join(File.dirname(__FILE__), '..', 'config'), 'nginx.conf.erb'))).result
  
  # if config_file exists then remove it
  runner "[[ -e #{config_file} ]] && rm #{config_file}"
  push_text config_template, config_file

  verify do
    has_file config_file
    file_contains config_file, "*.#{HOST};"
    file_contains config_file, "rewrite ^/(.*) http://#{HOST}/$1 permanent"
  end
end

package :enable_site do
  description "Symlink vhost file into sites_enabled"
  requires :upstream_configuration

  config_file = "/etc/nginx/sites-available/#{APP_NAME}"
  symlink_file = "/etc/nginx/sites-enabled/#{APP_NAME}"

  runner "ln -s #{config_file} #{symlink_file}"

  verify do
    has_symlink symlink_file
  end
end
    
package :restart_nginx do
  runner '/etc/init.d/nginx restart'
end

package :git, :provides => :scm do
  description 'Git Distributed Version Control'
  apt 'git'
end

# Policies

# Associates the rails policy to the application servers. Contains rails, and surrounding
# packages. Note, appserver, database and webserver are all virtual packages defined above. If
# there's only one implementation of a virtual package, it's selected automatically, otherwise
# the user is requested to select which one to use.

policy :rails, :roles => :app do
  requires :rails, :version => '3.2.8'
  requires :appserver
  requires :webserver
  requires :scm
end

# Deployment

# Configures sprinkle to use capistrano for delivery of commands to the remote machines (via
# the named 'deploy' recipe). Also configures 'source' installer defaults to put package gear
# in /usr/local

deployment do

  # mechanism for deployment
  delivery :capistrano do
    # recipes 'deploy'
    recipes 'Capfile'
    # recipes "config/deploy/#{fetch(:stage)}"
  end
  
  # source based package installer defaults
  source do
    prefix   '/usr/local'           # where all source packages will be configured to install
    archives '/usr/local/sources'   # where all source packages will be downloaded to
    builds   '/usr/local/build'     # where all source packages will be built
  end

end
