# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  first_name :string           not null
#  last_name  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Factory' do
    it 'has a valid factory' do
      expect(build_stubbed(:user)).to be_valid
    end
  end

  describe 'associations' do
    it { should have_many(:friendships).class_name('Friendship').dependent(:destroy) }
    it { should have_many(:friends).through(:friendships).class_name('User') }
    it { should have_one(:payment_account).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }

    context 'when user has a valid email' do
      it 'has to be a valid record' do
        expect(subject).to be_valid
      end
    end

    context 'when user has a valid email' do
      it 'has to be invalid' do
        subject.email = 'this is not an email'

        expect(subject).to_not be_valid
      end
    end
  end

  describe 'after_create callbacks' do
    let!(:user) { build(:user) }

    subject { user.save }

    it 'creates a Payment Account' do
      expect { subject }.to(change { PaymentAccount.count })
      expect(PaymentAccount.last).to have_attributes(user: user)
    end
  end
end
