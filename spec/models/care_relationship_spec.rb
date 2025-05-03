require 'rails_helper'

RSpec.describe CareRelationship, type: :model do
  let(:parent) { FactoryBot.create(:user) }
  let(:caregiver) { FactoryBot.create(:user) }
  let(:child) { FactoryBot.create(:child, user: parent) }

  describe 'バリデーション' do
    it 'すべての値が存在すれば保存できること' do
      relationship = CareRelationship.new(parent: parent, caregiver: caregiver, child: child, status: :ongoing)
      expect(relationship).to be_valid
    end

    it 'parentが空だと無効' do
      relationship = CareRelationship.new(parent: nil, caregiver: caregiver, child: child, status: :ongoing)
      expect(relationship).to be_invalid
      expect(relationship.errors[:parent]).to include("を入力してください")
    end

    it 'caregiverが空だと無効' do
      relationship = CareRelationship.new(parent: parent, caregiver: nil, child: child, status: :ongoing)
      expect(relationship).to be_invalid
      expect(relationship.errors[:caregiver]).to include("を入力してください")
    end

    it 'childが空だと無効' do
      relationship = CareRelationship.new(parent: parent, caregiver: caregiver, child: nil, status: :ongoing)
      expect(relationship).to be_invalid
      expect(relationship.errors[:child]).to include("を入力してください")
    end

    it 'statusが空だと無効' do
      relationship = CareRelationship.new(parent: parent, caregiver: caregiver, child: child, status: nil)
      expect(relationship).to be_invalid
      expect(relationship.errors[:status]).to include("を入力してください")
    end
  end

  describe 'enum' do
    it 'statusがongoingかendedであること' do
      expect(CareRelationship.statuses.keys).to include('ongoing', 'ended')
    end
  end
end