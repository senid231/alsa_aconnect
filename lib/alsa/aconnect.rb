# frozen_string_literal: true

require 'alsa/command'
require 'alsa/aconnect/version'
require 'alsa/aconnect/error'
require 'alsa/aconnect/cmd'
require 'alsa/aconnect/parser'
require 'alsa/aconnect/port'
require 'alsa/aconnect/client'

module ALSA
  module Aconnect
    module_function

    def input_clients
      out = Cmd.run('-i', '-l')
      Parser.parse_clients(out).map { |text| Client.new(text, :input) }
    end

    def input_ports
      input_clients.map(&:ports).flatten
    end

    def output_clients
      out = Cmd.run('-o', '-l')
      Parser.parse_clients(out).map { |text| Client.new(text, :output) }
    end

    def output_ports
      output_clients.map(&:ports).flatten
    end

    def connect(input, output)
      input = "#{input.client_id}:#{input.id}" if input.is_a?(Port)
      output = "#{output.client_id}:#{output.id}" if output.is_a?(Port)

      Cmd.run('-d', input, output)
    end

    def disconnect(input, output)
      input = "#{input.client_id}:#{input.id}" if input.is_a?(Port)
      output = "#{output.client_id}:#{output.id}" if output.is_a?(Port)

      Cmd.run(input, output)
    end
  end
end
