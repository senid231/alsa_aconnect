# frozen_string_literal: true

module ALSA
  module Aconnect
    class Error < StandardError
      attr_reader :code, :msg

      def initialize(code, msg)
        @code = code
        @msg = msg
        super("Exited with status #{code}: #{msg}")
      end
    end
  end
end
