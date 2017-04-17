class Ledis
  class Commands
    COMMANDs = [:set, :get, :llen, :rpush, :lpop, :rpop, :lrange, :sadd, :scard, :smembers, :srem, :sinter]

    # 0: String
    # 1: List
    # 2: Set
    COMMAND_TYPE_MAP = {
      set: 0,
      get: 0,
      llen: 1,
      rpush: 1,
      lpop: 1,
      rpop: 1,
      lrange: 1,
      sadd: 2,
      scard: 2,
      smembers: 2,
      srem: 2,
      sinter: 2,
    }

    attr_reader :command, :params

    def initialize(command, params = [])
      raise ArgumentError.new('command must be symbol') unless command.kind_of? Symbol
      raise ArgumentError.new('params must be array') unless params.kind_of? Array
      @command = command
      @params = params
    end

    def available?
      COMMANDS.include? command
    end

    def available!
      availability = available?
      raise Ledis::Errors::UnknownCommandError.new(command) if availability == false

      availability
    end

    def can_apply_to_key?(key)
      key_type = Ledis.get_key_type(key)
      !key_type || COMMAND_TYPE_MAP[command] == key_type
    end

    def can_apply_to_key!(key)
      ability = can_apply_to_key? key
      raise Ledis::Errors::WrongTypeError if ability == false
      ability
    end

    def execute!
      available!
      Ledis.send(command, *params)
    end
  end
end
