# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module PhoneAuthorizationHandler
    # This is the engine that runs on the public interface of phone_authorization_handler.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::PhoneAuthorizationHandler

      initializer "decidim.exporters" do
        require "decidim/exporters/csv"
        require "decidim/proposals/proposal_serializer"
      end
    end
  end
end
