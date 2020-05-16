# frozen_string_literal: true

module ALSA
  module Aconnect
    class Client
      DIRECTIONS = [:input, :output].freeze

      attr_reader :id, :name, :type, :card, :pid, :ports, :direction

      def initialize(text, direction)
        raise ArgumentError, "invalid direction #{direction.inspect}" unless DIRECTIONS.include?(direction)

        @direction = direction

        data = Parser.parse_client(text)
        @id = data[:id]
        @name = data[:name]
        @type = data[:type]
        @card = data[:card]
        @pid = data[:pid]
        @ports = data[:ports].map do |port_text|
          Port.new(port_text, self)
        end
      end
    end
  end
end
