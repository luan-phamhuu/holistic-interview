class Ledis
  module Errors
    class ArgumentError < BaseError
      attr_reader :command

      def initialize(command)
        @command = command
      end

      def message
        "wrong number of arguments for '#{command}' command "
      end

    end
  end
end
