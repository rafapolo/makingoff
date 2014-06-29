redis-server &
bundle exec sidekiq -c 40 &
rake mko:update_seeds &
