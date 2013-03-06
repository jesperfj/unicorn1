# config/initializers
ActiveSupport::Notifications.subscribe(/unicorn.metrics.queue/) do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  payload = event.payload

  addr = payload[:addr]
  active = payload[:requests][:active]
  queued = payload[:requests][:queued]
  queue_time = payload[:queue_time]

  puts "STATS addr=#{addr} conns_active=#{active} conns_queued=#{queued} queue_time=#{queue_time}"

  Librato.group('routing') { |g|
    g.measure 'conns_active', active
    g.measure 'conns_queued', queued
    g.measure 'queue_time', queue_time
  }        
end