module Noisia
  require 'fileutils'
  class Recognition
    def initialize audio_file_path
      @fingerprint = Noisia::Fingerprint.new(audio_file_path, :match).build
    end

    def results
      @results ||= Noisia::Elastic.search(@fingerprint).map{|r| [r.id, r._score]}
    end

    def scores
      @scores ||= results.map{|el| el[1]}
    end
  end
end