# frozen_string_literal: true

module ALSA
  module Aconnect
    module Parser
      module_function

      def parse_clients(output)
        output
          .split('client ')
          .reject(&:empty?)
          .map { |l| "client #{l.strip}" }
      end

      def parse_client(output)
        client_line, *port_lines = output.split("\n")

        ports = []
        port_lines.reject(&:empty?).each do |line|
          line = line.strip
          if line =~ /\A\d+/
            ports.push(line)
          else
            ports[-1] = "#{ports[-1]} #{line}"
          end
        end

        matched = client_line.match(/\Aclient (\d+): '(.+)' \[(.+)\]\z/)
        id = matched[1].to_i
        name = matched[2].strip
        tags = matched[3].split(',').map { |l| l.split('=') }.to_h
        {
          id: id,
          name: name,
          type: tags['type'],
          card: tags['card'],
          pid: tags['pid'],
          ports: ports
        }
      end

      def parse_port(output)
        matched = output.match(/\A(\d) '(.+)'/)
        id = matched[1].to_i
        name = matched[2].strip
        connected_to_type = nil
        connected_to_client_id = nil
        connected_to_port_id = nil

        matched_from = output.match(/Connected From: (\d):(\d)\z/)
        if matched_from
          connected_to_type = :input
          connected_to_client_id = matched_from[1]
          connected_to_port_id = matched_from[2]
        end

        matched_from = output.match(/Connected To: (\d):(\d)\z/)
        if matched_from
          connected_to_type = :output
          connected_to_client_id = matched_from[1]
          connected_to_port_id = matched_from[2]
        end

        {
          id: id,
          name: name,
          connected_to_type: connected_to_type,
          connected_to_client_id: connected_to_client_id,
          connected_to_port_id: connected_to_port_id
        }
      end
    end
  end
end
