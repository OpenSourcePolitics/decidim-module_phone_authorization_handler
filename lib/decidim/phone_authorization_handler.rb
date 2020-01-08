# frozen_string_literal: true

require 'decidim/phone_authorization_handler/engine'
require 'decidim/phone_authorization_handler/workflow'

module Decidim
  # This namespace holds the logic of the `PhoneAuthorizationHandler` component. This component
  # allows users to create phone_authorization_handler in a participatory space.
  module PhoneAuthorizationHandler
  end

  module Proposals
    #autoload :ProposalSerializer, 'decidim/proposals/proposal_serializer'
  end

  module Exporters
    #autoload :CSV, 'decidim/exporters/csv'
  end
end
