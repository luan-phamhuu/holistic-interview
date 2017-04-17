class Ledis
  module Errors
    class UnknownCommandError < BaseError
      attr_reader :command

      def initialize(command)
        @command = command
      end

      def message
        "unknown command '#{command}'"
      end

    end
  end
end
