#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"

require "em-proxy"

Proxy.start(:host => "127.0.0.1", :port => 25565, :debug => false) do |conn|
  conn.server :srv, :host => "minecraft.lolcalhost.de", :port => 25565

  # modify / process request stream
  conn.on_data do |data|
    p [:on_data, data]
    data
  end
 
  # modify / process response stream
  conn.on_response do |backend, resp|
    p [:on_response, backend, resp]
    resp
  end  
end
