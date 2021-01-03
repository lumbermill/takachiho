
server 'sakura26.lmlab.net', user: fetch(:user), roles: %w{app db web}
set :rails_env, "production"
set :branch, 'master'
