set :output, "log/cron.log"
set :environment, ENV['RAILS_ENV']

every 5.minutes do
  rake "articles:remove_reported"
end
