#!/usr/bin/env ruby

require './packets'

class PacketParser
  @parsing_failed = false
  
  def parse(pkt, direction)
    return if @parsing_failed
    return false if pkt.nil? || pkt.length == 0
    packet = pkt.bytes.to_a
    packet_id = packet.slice!(0, 1).first
    if PACKET_DEFS.key? packet_id
      pd = PACKET_DEFS[packet_id]
      fmt = pd[direction] || pd[:fmt]
      unless fmt
        @parsing_failed = true
        raise Exception.new("Format not known for #{pd[:name]} / #{direction}")
      end
      data = { _name: pd[:name], _direction: direction }
      finished = true
      begin
        fmt.each_slice(2) do |k, type|
          data[k] = case type
            # primitives
            when 'byte'
              raise if packet.length < 1
              packet.slice!(0, 1).first
            when 'short'
              raise if packet.length < 2
              bin(packet.slice!(0, 2).pack('c*'))
            when 'int'
              raise if packet.length < 4
              bin(packet.slice!(0, 4).pack('c*'))
            when 'long'
              raise if packet.length < 8
              bin(packet.slice!(0, 8).pack('c*'))
            when 'float'
              raise if packet.length < 4
              packet.slice!(0, 4).pack('c*').unpack('g').first
            when 'double'
              raise if packet.length < 8
              packet.slice!(0, 8).pack('c*').unpack('G').first
            when 'string'
              raise if packet.length < 2
              len = bin(packet.slice!(0, 2).pack('c*'))
              str = ''
              str = packet.slice!(0, len).pack('c*') if len && len > 0
              str
            when 'bool'
              raise if packet.length < 1
              packet.slice!(0, 1).first == 1
            # special types
            when 'Item'
              raise if packet.length < 1
              item_id = bin(packet.slice!(0, 2).pack('c*'))
              if item_id != -1
                count = packet.slice!(0, 1).first
                uses = bin(packet.slice!(0, 2).pack('c*'))
                { item_id: item_id, count: count, uses: uses }
              else
                nil
              end
            when 'MobMetadata'
              idx = packet.find_index(0x7f)
              packet.slice!(0, idx + 1)
            when 'WindowItemsPayload'
              inventory = Array.new(data['count'])
              Range.new(0, data['count'], true).each do |slot|
                item_id = bin(packet.slice!(0, 2).pack('c*'))
                if item_id != -1
                  raise if packet.length < 3
                  count = packet.slice!(0, 1).first
                  uses = bin(packet.slice!(0, 2).pack('c*'))
                  inventory[slot] = { item_id: item_id, count: count, uses: uses }
                end
              end
              inventory
            # Unhandled types
            else
              raise Exception.new("Unhandled type in #{pd[:name]}: #{type}")
            end
        end
      rescue
        return false
      end
      return { data: data, packet: packet.pack('c*') }
    else
      $stderr.puts "Unknown packet: %#x" % packet_id
      $stderr.puts pkt.hexdump
      @parsing_failed = true
      return
    end
  end
  
private

  def bin(c)
    c.unpack("cC*").inject(0) { |res, b| (res << 8) | b } 
  end
end

=begin
pkts = [
  { direction: :c2s, data: [0x02, 0x00, 0x07, 0x6d, 0x6f, 0x65, 0x66, 0x66, 0x6a, 0x75] },
  { direction: :s2c, data: [0x02, 0x00, 0x10, 0x66, 0x65, 0x38, 0x65, 0x35, 0x33, 0x32, 0x64, 0x32, 0x37, 0x35, 0x34, 0x38, 0x35, 0x33, 0x37] },
  { direction: :c2s, data: [0x01, 0x00, 0x00, 0x00, 0x09, 0x00, 0x07, 0x6d, 0x6f, 0x65, 0x66, 0x66, 0x6a, 0x75, 0x00, 0x08, 0x50, 0x61, 0x73, 0x73, 0x77, 0x6f, 0x72, 0x64, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00] },
  { direction: :s2c, data: [0x01, 0x00, 0x27, 0xab, 0x74, 0x00, 0x00, 0x00, 0x00, 0xe4, 0x00, 0x26, 0xaa, 0xc1, 0x65, 0xf0, 0x60, 0x00] },
  { direction: :s2c, data: [0x06, 0xff, 0xff, 0xff, 0xaa, 0x00, 0x00, 0x00, 0x40, 0xff, 0xff, 0xfe, 0xba] },
  { direction: :s2c, data: [0x03, 0x00, 0x36, 0x47, 0x65, 0x72, 0x65, 0x6e, 0x64, 0x65, 0x72, 0x74, 0x65, 0x20, 0x4d, 0x61, 0x70, 0x73, 0x20, 0x75, 0x6e, 0x74, 0x65, 0x72, 0x3a, 0x20, 0x68, 0x74, 0x74, 0x70, 0x3a, 0x2f, 0x2f, 0x6d, 0x69, 0x6e, 0x65, 0x63, 0x72, 0x61, 0x66, 0x74, 0x2e, 0x6c, 0x6f, 0x6c, 0x63, 0x61, 0x6c, 0x68, 0x6f, 0x73, 0x74, 0x2e, 0x64, 0x65, 0x2f] },
  { direction: :s2c, data: [0x03, 0x00, 0x00] },
  { direction: :s2c, data: [0x32, 0xff, 0xff, 0xff, 0xea, 0x00, 0x00, 0x00, 0x05, 0x01] },
]

pp = PacketParser.new
pkts.each do |pkt|
  pp.parse(pkt[:data].pack('c*'), pkt[:direction])
end
=end
