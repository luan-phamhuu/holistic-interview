class Ledis
  module Errors
    class BaseError < RuntimeError
      def formatted_message
        "ERROR: #{message}"
      end
    end
  end
end
