# frozen_string_literal: true

# Allows to create a form for simple Phone authorization
class PhoneAuthorizationHandler < Decidim::AuthorizationHandler
  attribute :phone_number, String

  validates :phone_number,
            length: { is: 10 },
            format: { with: /0[1-9][0-9]{8}/, message: I18n.t('errors.messages.phone_number_format') },
            presence: true

  def metadata
    super.merge(phone_number: phone_number)
  end

end
