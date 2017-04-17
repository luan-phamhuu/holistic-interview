module LedisServer
  class API < Grape::API
    version 'v1', using: :header, vendor: 'ledis'
    format :json

    helpers do
      def present_output(output)
        present :output, output
      end
    end

    params do
      requires :command_string, type: String
    end

    post '/' do
      begin
        parsed_data = Ledis::CommandParser.new(params.command_string).parse
        command = Ledis::Command.new(parsed_data[0], parsed_data[1])
        result = command.execute!
        present_output result
      rescue Ledis::Errors::BaseError => e
        present_output e.formatted_message
      end
    end


  end
end
