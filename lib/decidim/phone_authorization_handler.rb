# frozen_string_literal: true

require "decidim/phone_authorization_handler/engine"
require "decidim/phone_authorization_handler/workflow"

require "decidim/phone_authorization_handler/extends/proposal_serializer_extend"
require "decidim/phone_authorization_handler/extends/csv_exporter_extend"
require "decidim/phone_authorization_handler/extends/excel_exporter_extend"

module Decidim
  # This namespace holds the logic of the `PhoneAuthorizationHandler` component. This component
  # allows users to create phone_authorization_handler in a participatory space.

  module PhoneAuthorizationHandler
  end
end
