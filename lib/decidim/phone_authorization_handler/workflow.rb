# frozen_string_literal: true

Decidim::Verifications.register_workflow(:phone_authorization_handler) do |workflow|
  workflow.form = "PhoneAuthorizationHandler"
end
