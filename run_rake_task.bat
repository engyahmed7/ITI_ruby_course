@echo off
cd E:\ITI\Lectures\Ruby\Labs\Lab1
set RAILS_ENV=production
bundle exec rake articles:remove_reported --silent >> log\cron.log 2>&1
