# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server 'example.com', user: 'deploy', roles: %w{app db web}, my_property: :my_value
# server 'example.com', user: 'deploy', roles: %w{app web}, other_property: :other_value
# server 'db.example.com', user: 'deploy', roles: %w{db}

Dotenv.require_keys("RAILS_ENV", "SECRET_KEY_BASE", "DB_HOST","DB_NAME","DB_USER","DB_PASSWORD", "HOST")

set :bundle_path, -> { shared_path.join('vendor/bundle') }

set :scm, :bundle_rsync

set :repo_url, Dir.pwd

set :bundle_rsync_scm, 'local_git'

set :bundle_rsync_skip_bundle, "true"


server ENV['HOST'], user: 'root', roles: %w(web app db) # , password: 'Tawd4oKsTawd4oKs'

role :app, [ENV['HOST']]

namespace :deploy do
 
  desc 'Reload puma'
  task :reload_puma do
    on roles(:app) do
      execute 'sudo /usr/bin/systemctl restart xpaste'
    end
  end
 
  desc 'Restart nginx'
  task :restart_nginx do
    on roles(:app) do
      execute 'sudo /usr/bin/systemctl restart nginx'
    end
  end
end
 
after  'deploy:publishing', 'deploy:reload_puma'
after 'deploy:reload_puma', 'deploy:restart_nginx'
