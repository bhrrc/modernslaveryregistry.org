require 'rails_helper'

RSpec.describe Legislation, type: :model do
  describe 'validation' do
    let(:valid_legislation) { Legislation.new(name: 'legislation-name', icon: 'icon-name') }

    it 'succeeds with valid legislation' do
      expect(valid_legislation).to be_valid
    end

    it 'fails when name is not set' do
      valid_legislation.name = nil
      expect(valid_legislation).to_not be_valid
      expect(valid_legislation.errors[:name]).to include("can't be blank")
    end

    it 'fails when icon is not set' do
      valid_legislation.icon = nil
      expect(valid_legislation).to_not be_valid
      expect(valid_legislation.errors[:icon]).to include("can't be blank")
    end
  end
end
