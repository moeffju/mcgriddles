#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"
require "em-proxy"
require "./packets"
require "./packet_parser"

class String
  def hexdump
    rr = ''
    address = 0
    self.scan(/.{1,16}/m).each do |s|
      e = s.enum_for :each_byte
      rr += "%04x  %-#{0x10*3}s |%s|\n" % [ address,
        e.map{ |b|  "%02x" % b }.join(" "),
        e.map{ |b|
          0x20 > b || 0x7f <= b  ? "." : b.chr
        }.join ]
      address += 0x10
    end
    rr
  end
end

pp = PacketParser.new
packet = ''

Proxy.start(:host => "127.0.0.1", :port => 25565, :debug => false) do |conn|
  conn.server :srv, :host => "minecraft.lolcalhost.de", :port => 25565
  
  # modify / process request stream
  conn.on_data do |data|
    puts ">>>> #{Time.now.strftime('%Y-%m-%d %H:%M:%S.%6N')} - #{data.bytesize} bytes"
    #puts data.hexdump
    packet += data
    while parsed = pp.parse(packet, :c2s) do
      puts parsed[:data].inspect
      packet = parsed[:packet] || ''
    end
    data
  end
  
  # modify / process response stream
  conn.on_response do |backend, data|
    puts "<<<< #{Time.now.strftime('%Y-%m-%d %H:%M:%S.%6N')} - #{data.bytesize} bytes"
    #puts data.hexdump
    packet += data
    while parsed = pp.parse(packet, :s2c) do
      puts parsed[:data].inspect
      packet = parsed[:packet] || ''
    end
    data
  end
end
