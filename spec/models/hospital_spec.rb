require 'rails_helper'

RSpec.describe Hospital, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:child) { FactoryBot.create(:child, user: user) }

  subject do
    described_class.new(
      user: user,
      child: child,
      name: "小児科クリニック",
      phone_number: "09012345678"
    )
  end

  describe 'バリデーション' do
    it 'すべての情報が正しければ有効' do
      expect(subject).to be_valid
    end

    it 'nameが空だと無効' do
      subject.name = ""
      expect(subject).to be_invalid
      expect(subject.errors[:name]).to include("緊急連絡名を入力してください")
    end

    it 'phone_numberが空だと無効' do
      subject.phone_number = ""
      expect(subject).to be_invalid
      expect(subject.errors[:phone_number]).to include("電話番号を入力してください")
    end

    it 'phone_numberにハイフンがあると無効' do
      subject.phone_number = "090-1234-5678"
      expect(subject).to be_invalid
      expect(subject.errors[:phone_number]).to include("ハイフンなしで入力してください")
    end

    it 'phone_numberが不正な形式だと無効（11桁未満）' do
      subject.phone_number = "031234567"
      expect(subject).to be_invalid
      expect(subject.errors[:phone_number]).to include("有効な電話番号を入力してください")
    end

    it 'userが紐づいていないと無効' do
      subject.user = nil
      expect(subject).to be_invalid
    end

    it 'childが紐づいていないと無効' do
      subject.child = nil
      expect(subject).to be_invalid
    end
  end
end