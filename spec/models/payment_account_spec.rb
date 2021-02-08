# == Schema Information
#
# Table name: payment_accounts
#
#  id         :bigint           not null, primary key
#  balance    :decimal(10, 2)   default(0.0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_payment_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe PaymentAccount, type: :model do
  describe 'Factory' do
    it 'has a valid factory' do
      expect(build_stubbed(:payment_account)).to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:balance) }
    it { should validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }
  end
end
