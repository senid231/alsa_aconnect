# frozen_string_literal: true

require 'alsa/aconnect/version'
require 'alsa/aconnect/config'
require 'alsa/aconnect/error'
require 'alsa/aconnect/parser'
require 'alsa/aconnect/port'
require 'alsa/aconnect/client'

require 'open3'

module ALSA
  module Aconnect
    module_function

    def input_clients
      out = run('-i', '-l')
      Parser.parse_clients(out).map { |text| Client.new(text, :input) }
    end

    def input_ports
      input_clients.map(&:ports).flatten
    end

    def output_clients
      out = run('-o', '-l')
      Parser.parse_clients(out).map { |text| Client.new(text, :output) }
    end

    def output_ports
      output_clients.map(&:ports).flatten
    end

    def connect(input, output)
      input = "#{input.client.id}:#{input.id}" if input.is_a?(Port)
      output = "#{output.client.id}:#{output.id}" if output.is_a?(Port)

      run(input, output)
    end

    def disconnect(input, output)
      input = "#{input.client.id}:#{input.id}" if input.is_a?(Port)
      output = "#{output.client.id}:#{output.id}" if output.is_a?(Port)

      run('-d', input, output)
    end

    def run(*arguments)
      cmd = [config.exec_path, *arguments].compact.join(' ')
      out, err, status = Open3.capture3(cmd)
      code = status.exitstatus
      raise Error.new code, err unless code.zero?

      out
    end

    def config
      @config ||= Config.new
    end

    def configure
      yield config if block_given?
    end

    configure
  end
end
