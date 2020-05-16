# frozen_string_literal: true

begin
  require 'bundler/inline'
  require 'bundler'
rescue LoadError => e
  warn 'Bundler version 1.10 or later is required. Please update your Bundler'
  raise e
end

gemfile(true, ui: Bundler::UI::Silent.new) do
  source 'https://rubygems.org'

  gem 'alsa_aconnect', path: File.join(__dir__, '..'), require: false
end

require 'alsa/aconnect'

KB_NAME = 'USB Midi Cable'
SERVER_NAME = 'FLUID Synth'

input_clients = ALSA::Aconnect.input_clients
output_clients = ALSA::Aconnect.output_clients

midi_kb = input_clients.detect { |c| c.name.include?(KB_NAME) }&.ports&.first
fluidsynth = output_clients.detect { |c| c.name.include?(SERVER_NAME) }&.ports&.first

if midi_kb.nil?
  puts "#{KB_NAME} not connected. Skipping."
  exit 0
end

if fluidsynth.nil?
  warn "#{SERVER_NAME} not started."
  exit 1
end

if midi_kb.connected_to_client_id == fluidsynth.client.id && midi_kb.connected_to_port_id == fluidsynth.id
  puts "#{KB_NAME} already connected to #{SERVER_NAME}. Skipping."
  exit 0
end

begin
  puts "Connecting #{KB_NAME} to #{SERVER_NAME}..."
  ALSA::Aconnect.connect(midi_kb, fluidsynth)
  puts 'Connected.'
  exit 0
rescue ALSA::Aconnect::Error => e
  warn e.message
  exit e.code
end
