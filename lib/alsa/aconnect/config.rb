module ALSA
  module Aconnect
    class Config
      attr_accessor :exec_path

      def initialize
        @exec_path = 'aconnect'
      end
    end
  end
end
