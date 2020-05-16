# frozen_string_literal: true

require 'open3'

module ALSA
  module Aconnect
    class Cmd
      EXEC = 'aconnect'

      def self.run(*arguments)
        new(EXEC, arguments).run
      end

      def initialize(exec, *arguments)
        @exec = exec
        @arguments = arguments
      end

      def run
        cmd = [@exec, *@arguments].compact.join(' ')
        out, err, status = Open3.capture3(cmd)
        code = status.exitstatus
        raise Error.new code, err.join("\n") unless code.zero?

        out
      end
    end
  end
end
