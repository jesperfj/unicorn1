class HomeController < ApplicationController

  def index
  	require 'socket'
	ip = IPSocket.getaddress(Socket.gethostname)
	puts ip.to_s + ':' + ENV['PORT']
  	stats = Raindrops::Linux.tcp_listener_stats([ ip.to_s + ':' + ENV['PORT'] ])
  	stats.each { |addr, stats|
  		puts "#{addr}, #{stats.active}, #{stats.queued}"
  	}
  end
end
