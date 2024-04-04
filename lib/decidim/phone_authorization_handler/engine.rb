# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module PhoneAuthorizationHandler
    # This is the engine that runs on the public interface of phone_authorization_handler.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::PhoneAuthorizationHandler

      config.to_prepare do
        Decidim::Proposals::ProposalSerializer.prepend(Decidim::PhoneAuthorizationHandler::Extends::ProposalSerializerExtend)

        Decidim::Exporters::CSV.prepend(Decidim::PhoneAuthorizationHandler::Extends::CSVExporterExtend)
        Decidim::Exporters::Excel.prepend(Decidim::PhoneAuthorizationHandler::Extends::ExcelExporterExtend)
        Decidim::Exporters::JSON.prepend(Decidim::PhoneAuthorizationHandler::Extends::JSONExporterExtend)
      end
    end
  end
end
