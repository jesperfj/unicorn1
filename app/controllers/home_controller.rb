require 'socket'
require 'random_gaussian'

class HomeController < ApplicationController

  before_filter :before
  after_filter :after

  def index
    sleep WAIT.rand
    render :nothing => true, :status => :ok
  end

  protected

    ADDR = IPSocket.getaddress(Socket.gethostname).to_s+':'+ENV['PORT']

    WAIT = RandomGaussian.new(0.050,0.020)

	  def tcp_stats
      if defined? Raindrops::Linux.tcp_listener_stats
        stats = Raindrops::Linux.tcp_listener_stats([ '0.0.0.0:'+ENV['PORT'] ])['0.0.0.0:'+ENV['PORT']]
        return { :active => stats.active, :queued => stats.queued }	  	
      else
        return { :active => 0, :queued => 0 }     
		  end
	  end

	  def before
	  	@stats = tcp_stats
	  	@request_start = Time.now.to_f*1000.0
      if request.headers['X-Request-Start']
        @queue_time = (@request_start-request.headers['X-Request-Start'].to_f).round
      else
        @queue_time = 0
      end
	  end

	  def after
      request_time = (Time.now.to_f*1000.0 - @request_start).round
      puts "STATS addr=#{ADDR} conns_active=#{@stats[:active]} conns_queued=#{@stats[:queued]} queue_time=#{@queue_time} request_time=#{request_time}"
      Librato.group 'routing.'+ADDR { |g|
        g.measure 'conns_active', @stats[:active]
        g.measure 'conns_queued', @stats[:queued]
        g.measure 'queue_time', @queue_time
        g.measure 'request_time', request_time
      }
	  end

end


