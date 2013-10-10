require 'tire'
module Noisia
  class Elastic
    attr_accessor :track

    def initialize track
      self.track = track
    end

    def self.recreate_index
      index.delete
      index.create :mappings => {
        :track => {
          :properties => {
            :fingerprint => { :type => :long }
          }
        }
      }
    end

    def self.store_track track
      x = self.new(track)
      destroy_track(track)
      index.store x
    end

    def self.destroy_track track
      x = self.new(track)
      index.remove x
    end

    def self.search fingerprint
      Tire.search index_name, {:load=>false} do
        query do
          terms :fingerprint, fingerprint.split(' ').uniq
        end
      end.results.map{|r| [r.id, r._score]}
    end

    def to_indexed_json
      data.to_json
    end

    def type
      :track
    end

    def id
      track.id
    end

    private

    def self.index_name
      Rails.application.class.parent_name.downcase
    end

    def self.index
      Tire.index(index_name)
    end

    def data
      {fingerprint: track.fingerprint.split(' ')}
    end
  end
end
