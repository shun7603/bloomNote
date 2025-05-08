require 'rails_helper'

RSpec.describe CareRelationship, type: :model do
  let(:parent)    { FactoryBot.create(:user) }
  let(:caregiver) { FactoryBot.create(:user) }
  let(:child)     { FactoryBot.create(:child, user: parent) }

  subject do
    described_class.new(
      parent: parent,
      caregiver: caregiver,
      child: child,
      status: "ongoing"
    )
  end

  describe 'バリデーション' do
    it '有効な場合は保存できる' do
      expect(subject).to be_valid
    end

    it '親が存在しないと無効' do
      subject.parent = nil
      expect(subject).to be_invalid
      expect(subject.errors[:parent]).to include("を入力してください")
    end

    it '保育者が存在しないと無効' do
      subject.caregiver = nil
      expect(subject).to be_invalid
      expect(subject.errors[:caregiver]).to include("を入力してください")
    end

    it '子どもが存在しないと無効' do
      subject.child = nil
      expect(subject).to be_invalid
      expect(subject.errors[:child]).to include("を入力してください")
    end

    it 'ステータスが空だと無効' do
      subject.status = nil
      expect(subject).to be_invalid
      expect(subject.errors[:status]).to include("を入力してください")
    end

    it '親と保育者が同一人物だと無効' do
      subject.caregiver = subject.parent
      expect(subject).to be_invalid
      expect(subject.errors[:caregiver_id]).to include("に自分自身は指定できません")
    end
  end

  describe '#status_i18n' do
    it '日本語のステータス名を返す（ongoing）' do
      subject.status = "ongoing"
      expect(subject.status_i18n).to eq("預かり中")
    end

    it '日本語のステータス名を返す（ended）' do
      subject.status = "ended"
      expect(subject.status_i18n).to eq("終了")
    end
  end
end