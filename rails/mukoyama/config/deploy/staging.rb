
server 'sakura23', user: fetch(:user), roles: %w{app db web}
set :rails_env, "staging"
ask :branch, 'master'
