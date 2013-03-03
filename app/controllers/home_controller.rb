require 'socket'
require 'random_gaussian'

class HomeController < ApplicationController

  before_filter :before
  after_filter :after

  def index
  end

  protected

    ADDR = IPSocket.getaddress(Socket.gethostname).to_s+':'+ENV['PORT']

    WAIT = RandomGaussian.new(50,20)

	  def tcp_stats
      if defined? Raindrops::Linux.tcp_listener_stats
        stats = Raindrops::Linux.tcp_listener_stats([ ADDR ])[ADDR]
        return { :active => stats.active, :queued => stats.queued }	  	
      else
        return { :active => 0, :queued => 0 }     
		  end
	  end

	  def before
	  	@stats = tcp_stats
	  	@request_start = Time.now.to_f*1000.0
      if request.headers['X-Request-Start']
        puts request.headers['X-Request-Start']
        @queue_time = @request_start-request.headers['X-Request-Start'].to_f
      else
        @queue_time = 0
      end
	  end

	  def after
      request_time = Time.now.to_f*1000.0 - @request_start
      puts "tcp_addr=\"#{ADDR}\" tcp_active=#{@stats[:active]} tcp_queued=#{@stats[:queued]} queue_time=#{@queue_time} request_time=#{request_time}"
	  end

end


