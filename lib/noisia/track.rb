module Noisia
  module Track
    extend ActiveSupport::Concern

    module ClassMethods

    end

    included do

      before_validation :check_generate_fingerprint
      after_save :store_elastic
      after_destroy :destroy_elastic

      validates :file, :presence => true

      attr_accessor :fingerprint

      def check_generate_fingerprint
        if self.new_record? or file_changed?
          self.fingerprint = Noisia::Fingerprint.new(file.path, :add, default_density).build
          @store_elastic = true
        end
      end

      def store_elastic
        if @store_elastic
          Noisia::Elastic.store_track(self)
        end
        @store_elastic = false
      end

      def destroy_elastic
        Noisia::Elastic.destroy_track(self)
      end

      def default_density
        30
      end
    end
  end
end