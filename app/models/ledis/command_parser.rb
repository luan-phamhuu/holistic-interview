class Ledis
  class CommandParser
    attr_reader :command_string
        
    def initialize(command_string)
      raise ArgumentError.new('command_string must be string') unless command_string.instance_of? String
      raise ArgumentError.new('command_string can not be empty') unless command_string.present?
      @command_string = command_string
    end

    def parse
      command_components = command_string.split(' ')
      [normalize_command(command_components.shift), command_components]
    end

    private
    def normalize_command(command)
      command.downcase.to_sym
    end
  end
end
