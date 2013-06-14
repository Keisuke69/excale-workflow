require 'eventmachine'
module Initializer
    #EventMachine::run do
    #    EM.add_periodic_timer(1) { puts "Tick ..." }
    #end

    path = File.join(Rails.root.to_s, "script", "delayed_job")
    (pid = fork) ? Process.detach(pid) : exec("RAILS_ENV=production;#{path} start")
end