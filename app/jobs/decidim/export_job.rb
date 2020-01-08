# frozen_string_literal: true

module Decidim
  class ExportJob < ApplicationJob
    queue_as :default

    def perform(user, component, name, format)
      export_manifest = component.manifest.export_manifests.find do |manifest|
        manifest.name == name.to_sym
      end

      # Liste de tous les proposals
      collection = export_manifest.collection.call(component)
      # Récupere le serializer Proposals ( celui de la lib pas celui que j'edit )
      serializer = export_manifest.serializer
      export_data = Decidim::Exporters.find_exporter(format).new(collection, serializer).export

      ExportMailer.export(user, name, export_data).deliver_now
    end
  end
end
