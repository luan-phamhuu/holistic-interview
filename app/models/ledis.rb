class Ledis
  @@value_table = {}
  @@type_table = {}

  def self.value_table
    @@value_table
  end

  def self.type_table
    @@type_table
  end

  include DataTypes

  # def self.class_variable_set(symbol, obj)
  #   raise ArgumentError.new('@@value_table is not allowed to modify') if symbol.to_s == '@@value_table'
  #   raise ArgumentError.new('@@type_table is not allowed to modify') if symbol.to_s == '@@type_table'
  #   super()
  # end

  def self.set(key, value)
    value_table[key] = value
    set_key_type(key, 'String')
    value
  end

  def self.get(key)
    Command.new(:get).can_apply_to_key! key
    value_table[key]
  end

  def self.llen(key)
    Command.new(:llen).can_apply_to_key! key
    value_table[key].count
  end

  def self.rpush(key, *values)
    Command.new(:rpush).can_apply_to_key! key
    value = value_table[key] || []
    new_value = (value + values).flatten
    value_table[key] = new_value
    set_key_type(key, 'List')

    new_value.count
  end

  def self.lpop(key)
    Command.new(:lpop).can_apply_to_key! key
    value = value_table[key]
    value ? value.shift : nil
  end

  def self.rpop(key)
    Command.new(:rpop).can_apply_to_key! key
    value = value_table[key]
    value ? value.pop : nil
  end

  def self.lrange(key, start, stop)
    start = start.to_i
    stop = stop.to_i
    Command.new(:lrange).can_apply_to_key! key
    value = value_table[key]
    value ? value[start..stop] : []
  end

  def self.sadd(key, *values)
    Command.new(:sadd).can_apply_to_key! key
    value = value_table[key] || Set.new

    adding_count = 0
    values.map do |new_value|
      adding_count = adding_count + 1 if value.add? new_value
    end
    value_table[key] = value

    set_key_type(key, 'Set')

    adding_count
  end

  def self.scard(key)
    Command.new(:scard).can_apply_to_key! key
    value = value_table[key]
    value ? value.count : 0
  end

  def self.smembers(key)
    Command.new(:smembers).can_apply_to_key! key
    value_table[key]&.to_a || []
  end

  def self.srem(key, *values)
    Command.new(:srem).can_apply_to_key! key
    value = value_table[key]
    return 0 if value.nil?

    removing_count = 0
    values.map do |new_value|
      removing_count = removing_count + 1 if value.delete? new_value
    end

    removing_count
  end

  def self.sinter(key, *others_keys)
    keys = [key, others_keys].flatten
    command = Command.new(:sinter)

    values = []
    keys.each do |key|
      value = value_table[key]
      if value.nil?
        return []
      else
        values << value
        command.can_apply_to_key! key
      end
    end

    values.reduce do |intersection, current_set|
      intersection.intersection(current_set)
    end.to_a
  end

  def self.keys
    value_table.keys
  end

  def self.del(*keys)
    values = value_table.values_at(*keys)
    values.delete(nil)

    keys.each do |key|
      value_table.delete key
      type_table.delete key
    end

    values.count
  end

  def self.flushdb
    @@value_table = {}
    @@type_table = {}
    'OK'
  end
end
