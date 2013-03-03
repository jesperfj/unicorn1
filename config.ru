# This file is used by Rack-based servers to start the application.
use Raindrops::Middleware

require ::File.expand_path('../config/environment',  __FILE__)
run Unicorn1::Application
