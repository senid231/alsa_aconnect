# frozen_string_literal: true

require 'open3'

module ALSA
  # Util class for shell commands execution
  class Command
    def self.run(command, *arguments, **options)
      new(command, arguments, options).run
    end

    attr_reader :command, :arguments, :env, :out, :err

    def initialize(command, arguments, env: {}, out: nil, err: nil)
      @command = command
      @arguments = arguments
      @env = env
      @out = out
      @err = err
      @out_buff = []
      @err_buff = []
    end

    def run
      env_line = env.map { |k, v| "#{k}=#{v}" }.join(' ')
      command_line = ([env_line, command] + arguments).reject(&:empty?).join(' ')

      code = raw_execute(command_line)
      [code, @out_buff, @err_buff]
    end

    private

    def raw_execute(command_line)
      Open3.popen3(command_line) do |_stdin, stdout, stderr, wait_thread|
        Thread.new do
          begin
            until (raw_line = stdout.gets).nil?
              @out_buff.push(raw_line)
              out&.call(raw_line)
            end
          rescue IOError => _e
            # command process was closed and it's ok
          end
        end
        Thread.new do
          begin
            until (raw_line = stderr.gets).nil?
              @err_buff.push(raw_line)
              err&.call(raw_line)
            end
          rescue IOError => _e
            # command process was closed and it's ok
          end
        end
        wait_thread.value
      end
    end
  end
end
