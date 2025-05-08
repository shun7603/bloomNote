require 'rails_helper'

RSpec.describe Record, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:child) { FactoryBot.create(:child, user: user) }

  subject do
    described_class.new(
      user: user,
      child: child,
      record_type: :milk,
      category: :nutrition,
      quantity: 1,
      recorded_at: Time.current
    )
  end

  describe 'バリデーション' do
    it 'すべての情報が正しければ有効' do
      expect(subject).to be_valid
    end

    it 'record_typeが空だと無効' do
      subject.record_type = nil
      expect(subject).to be_invalid
      expect(subject.errors[:record_type]).not_to be_empty # ← メッセージ内容には依存しない
    end

    it 'categoryが空だと無効' do
      subject.category = nil
      expect(subject).to be_invalid
      expect(subject.errors[:category]).not_to be_empty
    end

    it 'recorded_atが空だと無効' do
      subject.recorded_at = nil
      expect(subject).to be_invalid
      expect(subject.errors.full_messages).to include(a_string_matching(/記録日時/))
    end

    it 'quantityが空だと無効' do
      subject.quantity = nil
      expect(subject).to be_invalid
      expect(subject.errors[:quantity]).to include("は数値で入力してください")
    end

    it 'quantityが0以下だと無効' do
      subject.quantity = 0
      expect(subject).to be_invalid
      expect(subject.errors[:quantity]).to include("は1以上を入力してください")
    end

    it 'childが紐づいていないと無効' do
      subject.child = nil
      expect(subject).to be_invalid
    end

    it 'userが紐づいていないと無効' do
      subject.user = nil
      expect(subject).to be_invalid
    end
  end
end