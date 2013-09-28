require "noisia/version"
require "open3"

module Noisia
  class Fingerprint
    attr_accessor :offsets, :terms

    def os
      (/darwin/ =~ RUBY_PLATFORM) != nil ? 'mac' : 'linux'
    end

    def initialize audio_path, type=:add, density=30
      command = "bash #{File.dirname(__FILE__)}/../../bin/#{os}/audfprint -#{type} #{audio_path} -density #{density}"
      stdin, stdout, stderr = Open3.popen3(command)
      @raw_codes = stdout.read.lines.to_a[0..-2].map{|el| el.strip.split(' ').map(&:to_i)}
      @offsets = @terms = []
      @raw_codes.each{|el| @offsets << el[0]; @terms << el[1]}
    end

    def fingerprint
      @fingerprint ||= @terms.join(' ')
    end
  end
end
