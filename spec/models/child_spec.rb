require 'rails_helper'

RSpec.describe Child, type: :model do
  let(:user) { FactoryBot.create(:user) }

  subject do
    described_class.new(
      user: user,
      name: "あかりちゃん",
      birth_date: "2021-05-05",
      gender: :girl
    )
  end

  describe 'バリデーション' do
    it 'すべての情報が正しければ有効' do
      expect(subject).to be_valid
    end

    it 'nameが空だと無効' do
      subject.name = ""
      expect(subject).to be_invalid
      expect(subject.errors[:name]).to include("を入力してください")
    end

    it 'birth_dateが空だと無効' do
      subject.birth_date = nil
      expect(subject).to be_invalid
      expect(subject.errors[:birth_date]).to include("を入力してください")
    end

    it 'genderが空だと無効' do
      subject.gender = nil
      expect(subject).to be_invalid
      expect(subject.errors[:gender]).to include("を入力してください")
    end
  end

  describe '#shared_with?' do
    let(:caregiver) { FactoryBot.create(:user) }
    let!(:care_relationship) do
      FactoryBot.create(:care_relationship, parent: user, caregiver: caregiver, child: subject, status: :ongoing)
    end

    it '共有中の保育者であれば true を返す' do
      subject.save!
      expect(subject.shared_with?(caregiver)).to be true
    end

    it '共有されていないユーザーであれば false を返す' do
      other_user = FactoryBot.create(:user)
      subject.save!
      expect(subject.shared_with?(other_user)).to be false
    end
  end

  describe '.accessible_by' do
    let(:caregiver) { FactoryBot.create(:user) }
    let(:child_shared) { FactoryBot.create(:child, user: user) }
    let!(:relation) do
      FactoryBot.create(:care_relationship, parent: user, caregiver: caregiver, child: child_shared, status: :ongoing)
    end

    it '親ユーザーの子どもが含まれる' do
      own_child = FactoryBot.create(:child, user: caregiver)
      result = Child.accessible_by(caregiver)
      expect(result).to include(own_child)
    end

    it '共有中の子どもが含まれる' do
      result = Child.accessible_by(caregiver)
      expect(result).to include(child_shared)
    end

    it '終了済みの関係では含まれない' do
      relation.update(status: :ended)
      result = Child.accessible_by(caregiver)
      expect(result).not_to include(child_shared)
    end
  end
end