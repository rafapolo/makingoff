# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Makingoff::Application.initialize!

def percent_down
  no_peer = Movie.preto.count + Movie.vermelho.count
  down_percent = (100 * no_peer) / Movie.count
  "#{down_percent}% down!"
end

# Hi, say on startup:

puts percent_down.red
