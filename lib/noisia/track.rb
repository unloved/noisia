module Noisia
  module Track
    extend ActiveSupport::Concern

    module ClassMethods

    end

    included do
      DEFAULT_DENSITY=30

      before_validation :check_regenerate_fingerprint
      after_save :store_elastic
      after_destroy :destroy_elastic

      validates :file, :presence => true

      def check_regenerate_fingerprint
        regenerate_fingerprint if self.new_record? or file_changed?
      end

      def regenerate_fingerprint
        self.fingerprint = Noisia::Fingerprint.new(file.path, :add, DEFAULT_DENSITY).fingerprint
        @update_elastic = true
      end

      def store_elastic
        if @update_elastic
          Noisia::Elastic.store_track(self)
        end
        @update_elastic = false
      end

      def destroy_elastic
        Noisia::Elastic.destroy_track(self)
      end
    end
  end
end