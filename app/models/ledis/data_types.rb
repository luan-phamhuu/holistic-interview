class Ledis
  module DataTypes
    DATATYPES_MAP = {
      'String' => 0,
      'List' => 1,
      'Set' => 2
    }

    def self.included(mod)
      raise RuntimeError.new("#{mod.inspect} must implement type_table method") unless mod.respond_to? :type_table
      mod.extend ClassMethod
    end

    module ClassMethod
      def get_key_type(key)
        type_table[key]
      end

      def set_key_type(key, type)
        type_table[key] = DATATYPES_MAP[type]
      end
    end
  end
end
