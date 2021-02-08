# == Schema Information
#
# Table name: payments
#
#  id          :bigint           not null, primary key
#  amount      :decimal(10, 2)   default(0.0), not null
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  receiver_id :bigint           not null
#  sender_id   :bigint           not null
#
# Indexes
#
#  index_payments_on_receiver_id  (receiver_id)
#  index_payments_on_sender_id    (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (receiver_id => users.id)
#  fk_rails_...  (sender_id => users.id)
#
require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe 'Factory' do
    it 'has a valid factory' do
      expect(create(:payment)).to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:receiver).class_name('User') }
    it { should belong_to(:sender).class_name('User') }
  end

  describe 'validations' do
    it { should validate_presence_of(:amount) }

    it 'has the expected ranges' do
      should validate_numericality_of(:amount).is_greater_than(0).is_less_than(1000)
    end
  end

  describe 'custom validations' do
    describe '#self_payment' do
      let!(:sender) { create(:user) }

      subject { build(:payment, sender: sender, receiver: receiver) }

      context 'when user do a payment to himself' do
        let!(:receiver) { sender }

        it 'is valid' do
          expect(subject).to_not be_valid
        end

        it 'returns expected error message' do
          subject.validate
          expect(subject.errors.messages_for(:sender_id)).to include(
            I18n.t(
              :self_payment,
              scope: %i[activerecord errors models payment attributes sender_id]
            )
          )
        end
      end

      context 'when user do a payment to other user' do
        let!(:receiver) { create(:user) }

        it { expect(subject).to be_valid }
      end
    end

    describe '#users_friendship' do
      let!(:sender) { create(:user) }
      let!(:receiver) { create(:user) }

      subject do
        build(:payment, with_friendship: false, sender: sender, receiver: receiver)
      end

      context 'when users are friends' do
        let!(:friendship) do
          create(:friendship, user: sender, friend: receiver)
        end

        it 'is valid' do
          subject.validate
          expect(subject).to be_valid
        end

        it 'saves payment' do
          expect { subject.save }.to(change { Payment.count }.by(1))
        end
      end

      context 'when users are not friends' do
        it 'is not valid' do
          subject.validate
          expect(subject).to_not be_valid
        end

        it 'returns expected error message' do
          subject.validate
          expect(subject.errors.messages_for(:sender_id)).to include(
            I18n.t(
              :no_friendship,
              scope: %i[activerecord errors models payment attributes sender_id]
            )
          )
        end
      end
    end
  end
end
