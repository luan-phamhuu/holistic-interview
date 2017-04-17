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
    Command.new(:lrange).can_apply_to_key! key
    value = value_table[key]
    value ? value[start..stop] : []
  end
end
