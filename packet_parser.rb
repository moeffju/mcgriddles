PACKET_DEFS = {
  0x00 => {
    name: 'KeepAlive',
    c2s: %w(),
    s2c: %w(),
  },
  0x01 => {
    name: 'LoginRequest',
    c2s: %w(
      version int
      username string
      password string
      map_seed long
      dimension byte
    ),
    s2c: %w(
      entity_id int
      unknown1 string
      unknown2 string
      map_seed long
      dimension byte
    )
  },
  0x02 => {
    name: 'Handshake',
    c2s: %w(username string),
    s2c: %w(connection_hash string),
  },
  0x03 => {
    name: 'Message',
    fmt: %w(message string),
  },
  0x04 => {
    name: 'TimeUpdate',
    s2c: %w(time long),
  },
  0x05 => {
    name: 'EntityEquipment',
    fmt: %w(
      entity_id int
      slot short
      item_id short
      unknown1 short
    )
  },
  0x06 => {
    name: 'UseEntity',
    fmt: %w(
      entity_id int
      target_id int
      leftclick bool
    )
  },
  0x08 => {
    name: 'UpdateHealth',
    s2c: %w(
      health short
    )
  },
  0x09 => {
    name: 'Respawn',
    fmt: [],
  },
  0x0a => {
    name: 'Player',
    c2s: %w(
      on_ground bool
    ),
  },
  0x0b => {
    name: 'PlayerPosition',
    c2s: %w(
      x double
      y double
      stance double
      z double
      on_ground bool
    )
  },
  0x0c => {
    name: 'PlayerLook',
    c2s: %w(
      yaw float
      pitch float
      on_ground bool
    )
  },
  0x0d => {
    name: 'PlayerPositionAndLook',
    c2s: %w(
      x double
      stance double
      y double
      z double
      yaw float
      pitch float
      on_ground bool
    ),
    s2c: %w(
      x double
      y double
      stance double
      z double
      yaw float
      pitch float
      on_ground bool
    )
  },
  0x0e => {
    name: 'PlayerDigging',
    fmt: %w(
      status byte
      x int
      y byte
      z int
      face byte
    )
  },
  0x0f => {
    name: 'PlayerBlockPlacement',
    fmt: %w(
      x int
      y byte
      z int
      direction byte
      bad block_or_item_amt_dmg
    )
      #block short
      #amount byte
      #damage short
  },
  0x10 => {
    name: 'HoldingChange',
    fmt: %w(slot_id short)
  },
  0x11 => {
    name: 'UseBed',
    s2c: %w(
      entity_id int
      unknown1 byte
      x int
      y byte
      z int
    )
  },
  0x12 => {
    name: 'Animation',
    fmt: %w(
      entity_id int
      animation byte
    )
  },
  0x13 => {
    name: 'PlayerCrouch',
    fmt: %w(
      entity_id int
      action byte
    )
  },
  0x14 => {
    name: 'NamedEntitySpawn',
    s2c: %w(
      entity_id int
      player_name string
      x int
      y int
      z int
      rotation byte
      pitch byte
      current_item short
    )
  },
  0x15 => {
    name: 'PickupSpawn',
    fmt: %w(
      entity_id int
      item_id short
      amount byte
      damage short
      x int
      y int
      z int
      rotation byte
      pitch byte
      roll byte
    )
  },
  0x16 => {
    name: 'CollectItem',
    fmt: %w(
      item_id int
      entity_id int
    )
  },
  0x17 => {
    name: 'AddObject',
    s2c: %w(
      entity_id int
      type byte
      x int
      y int
      z int
    )
  },
  0x18 => {
    name: 'MobSpawn',
    s2c: %w(
      entity_id int
      type byte
      x int
      y int
      z int
      yaw byte
      pitch byte
      data MobMetadata
    )
  },
  0x19 => {
    name: 'Painting',
    fmt: %w(
      entity_id int
      title string
      x int
      y int
      z int
      type int
    )
  },
  0x1b => {
    name: 'Unknown_0x1B',
    fmt: %w(
      unknown1 float
      unknown2 float
      unknown3 float
      unknown4 float
      unknown5 bool
      unknown6 bool
    )
  },
  0x1c => {
    name: 'EntityVelocity',
    fmt: %w(
      entity_id int
      velocity_x short
      velocity_y short
      velocity_z short
    )
  },
  0x1d => {
    name: 'DestroyEntity',
    s2c: %w(
      entity_id int
    )
  },
  0x1e => {
    name: 'Entity',
    s2c: %w(
      entity_id int
    )
  },
  0x1f => {
    name: 'EntityRelativeMove',
    s2c: %w(
      entity_id int
      dx byte
      dy byte
      dz byte
    )
  },
  0x20 => {
    name: 'EntityLook',
    s2c: %w(
      entity_id int
      yaw byte
      pitch byte
    )
  },
  0x21 => {
    name: 'EntityLookAndRelativeMove',
    s2c: %w(
      entity_id int
      dx byte
      dy byte
      dz byte
      yaw byte
      pitch byte
    )
  },
  0x22 => {
    name: 'EntityTeleport',
    s2c: %w(
      entity_id int
      x int
      y int
      z int
      yaw byte
      pitch byte
    )
  },
  0x26 => {
    name: 'EntityStatus',
    s2c: %w(
      entity_id int
      status byte
    )
  },
  0x27 => {
    name: 'AttachEntity',
    fmt: %w(
      entity_id int
      target_id int
    )
  },
  0x28 => {
    name: 'EntityMetadata',
    fmt: %w(
      entity_id int
      data MobMetadata
    )
  },
  0x32 => {
    name: 'PreChunk',
    s2c: %w(
      x int
      z int
      mode bool
    )
  },
  0x33 => {
    name: 'MapChunk',
    s2c: %w(
      x int
      y short
      z int
      size_x byte
      size_y byte
      size_z byte
      compressed_size int
      compressed_data byte[]
    ),
    special: true
  },
  0x34 => {
    name: 'MultiBlockChange',
    fmt: %w(
      chunk_x int
      chunk_z int
      size short
      coords short[]
      types byte[]
      metadata byte[]
    ),
    special: true
  },
  0x35 => {
    name: 'BlockChange',
    fmt: %w(
      x int
      y byte
      z int
      type byte
      metadata byte
    )
  },
  0x36 => {
    name: 'PlayNoteBlock',
    s2c: %w(
      x int
      y short
      z int
      type byte
      pitch byte
    )
  },
  0x3c => {
    name: 'Explosion',
    fmt: %w(
      x double
      y double
      z double
      unknown float
      count int
      records ExplosionRecord[]
    ),
    special: true
  },
  0x64 => {
    name: 'OpenWindow',
    fmt: %w(
      window_id byte
      inventory_type byte
      title string
      num_slots byte
    )
  },
  0x65 => {
    name: 'CloseWindow',
    fmt: %w(
      window_id byte
    )
  },
  0x66 => {
    name: 'WindowClick',
    fmt: %w(
      window_id byte
      slot short
      rightclick bool
      transaction_id short
      item_id short
      count byte
      uses short
    )
  },
  0x67 => {
    name: 'SetSlot',
    fmt: %w(
      window_id byte
      slot short
      item_id short
      count byte
      uses short
    ),
    special: true
  },
  0x68 => {
    name: 'WindowItems',
    s2c: %w(
      window_id byte
      count short
      payload WindowItemsPayload
    )
  },
  0x69 => {
    name: 'UpdateProgressBar',
    s2c: %w(
      window_id byte
      progressbar_id short
      value short
    )
  },
  0x6a => {
    name: 'Transaction',
    fmt: %w(
      window_id byte
      transaction_id short
      accepted bool
    )
  },
  0x82 => {
    name: 'UpdateSign',
    fmt: %w(
      x int
      y short
      z int
      text1 string
      text2 string
      text3 string
      text4 string
    )
  },
  0xff => {
    name: 'Disconnect',
    fmt: %w(
      reason string
    )
  }
}

class PacketParser
  @parsing_failed = false
  
  def parse(pkt, direction)
    return if @parsing_failed
    packet = pkt.bytes.to_a
    packet_id = packet.slice!(0, 1).first
    if PACKET_DEFS.key? packet_id
      pd = PACKET_DEFS[packet_id]
      fmt = pd[direction] || pd[:fmt]
      unless fmt
        $stderr.puts "No format available for #{pd[:name]} (#{direction})"
        @parsing_failed = true
        return
      end
      data = {}
      fmt.each_slice(2) do |k, type|
        data[k] = case type
          when 'byte'
            packet.slice!(0, 1).first
          when 'short'
            packet.slice!(0, 2).pack('c*').unpack('n')
          when 'int'
            packet.slice!(0, 4).pack('c*').unpack('N')
          when 'long'
            packet.slice!(0, 8).pack('c*').unpack('q')
          when 'float'
            packet.slice!(0, 4).pack('c*').unpack('g')
          when 'double'
            packet.slice!(0, 8).pack('c*').unpack('G')
          when 'string'
            len = packet.slice!(0, 2).pack('c*').unpack('n')
            str = packet.slice!(0, len).pack('c*')
            str
          when 'bool'
            packet.slice!(0, 1).first == 1
          end
      end
      $stderr.puts data.inspect
    else
      $stderr.puts "Unknown packet: %#x" % b[0]
      @parsing_failed = true
      return
    end
  end
end

pkt = [0x02, 0x00, 0x07, 0x6d, 0x6f, 0x65, 0x66, 0x66, 0x6a, 0x75].pack('c*')
