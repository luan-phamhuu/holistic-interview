class Ledis
  module Errors
    class WrongTypeError < BaseError
      attr_reader :command

      def message
        "Operation against a key holding the wrong kind of value"
      end

    end
  end
end
