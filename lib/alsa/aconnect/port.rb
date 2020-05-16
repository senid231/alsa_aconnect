# frozen_string_literal: true

module ALSA
  module Aconnect
    class Port
      attr_reader :id,
                  :name,
                  :client,
                  :connected_to_type,
                  :connected_to_client_id,
                  :connected_to_port_id

      def initialize(text, client)
        @client = client

        data = Parser.parse_port(text)
        @id = data[:id]
        @name = data[:name]
        @connected_to_type = data[:connected_to_type]
        @connected_to_client_id = data[:connected_to_client_id]
        @connected_to_port_id = data[:connected_to_port_id]
      end
    end
  end
end
