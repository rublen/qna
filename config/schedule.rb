# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
every 60.minutes do
  rake "ts:index"
end

every 1.days do
  runner "DailyMailerJob.perform_later"
end

# Learn more: http://github.com/javan/whenever
