# frozen_string_literal: true

require 'test_helper'

class AlsaAconnectTest < Minitest::Test
  def test_version_number
    refute_nil ::ALSA::Aconnect::VERSION
  end
end
