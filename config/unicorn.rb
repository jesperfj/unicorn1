# config/unicorn.rb
worker_processes ENV['WORKER_PROCESSES'] ? ENV['WORKER_PROCESSES'].to_i : 1
timeout 30
preload_app true
listen ENV['PORT'], :backlog => (ENV['TCP_BACKLOG'] ? ENV['TCP_BACKLOG'].to_i : 1024)

before_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end  

after_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to sent QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
