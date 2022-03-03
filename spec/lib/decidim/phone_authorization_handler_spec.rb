# frozen_string_literal: true

describe Decidim::PhoneAuthorizationHandler do
  let(:subject) { described_class }

  describe "#version" do
    it "returns module's version" do
      expect(described_class.version).to eq("1.0.0")
    end
  end
end
