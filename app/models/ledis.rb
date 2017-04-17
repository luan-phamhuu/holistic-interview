class Ledis
  @@value_table = {}
  @@type_table = {}

  def self.class_variable_set(symbol, obj)
    raise ArgumentError.new('@@value_table is not allowed to modify') if symbol.to_s == '@@value_table'
    raise ArgumentError.new('@@type_table is not allowed to modify') if symbol.to_s == '@@type_table'
    super()
  end
end
