# frozen_string_literal: true

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
        status, out, err = Command.run(@exec, *@arguments)
        raise Error.new(status.exitstatus, err.join("\n")) if status != 0 || !err.empty?

        out.join("\n")
      end
    end
  end
end
