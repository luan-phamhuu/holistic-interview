module Ledis
  class API < Grape::API
    version 'v1', using: :header, vendor: 'ledis'
    format :json

    post '/' do
      present :output, '1'
    end
  end
end
