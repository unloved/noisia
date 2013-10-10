module Noisia
  require 'fileutils'
  class Recognition
    def initialize audio_file_path
      @fingerprint = Noisia::Fingerprint.new(audio_file_path, :match).build
    end

    def search_results
      @search_results ||= Noisia::Elastic.search(@fingerprint)
    end

    def scores
      @scores ||= search_results.map{|el| el[1]}
    end

    def rates
      return @rates if @rates
      @rates = []
      scores.each_with_index do |score, i|
        next_score = scores[i+1]
        @rates << (score/next_score) if next_score
      end
      @rates
    end
  end
end