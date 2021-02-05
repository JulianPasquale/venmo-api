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
    it { should have_many(:friendships).class_name('Friendship') }
    it { should have_many(:friends).through(:friendships).class_name('User') }
  end

  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end
end
