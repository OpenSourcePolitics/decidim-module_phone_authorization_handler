# frozen_string_literal: true

module Decidim::PhoneAuthorizationHandler
  module Extends
    module JSONExporterExtend
      # Public: Generates a JSON representation of a collection and a
      # Serializer.
      # It injects some informations as author's data which can only be exported by admin
      #
      # Returns an ExportData with the export.
      def admin_export
        data = ::JSON.pretty_generate(@collection.map do |resource|
          @serializer.new(resource, false).serialize
        end)

        Decidim::Exporters::ExportData.new(data, "json")
      end
    end
  end
end
