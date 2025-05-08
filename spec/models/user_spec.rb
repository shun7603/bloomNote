require 'rails_helper'

RSpec.describe User, type: :model do
  subject do
    described_class.new(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123",
      nickname: "テストユーザー",
      role: "role_parent"
    )
  end

  describe 'バリデーション' do
    it 'すべての情報が正しければ有効' do
      expect(subject).to be_valid
    end

    it 'nicknameが空だと無効' do
      subject.nickname = nil
      expect(subject).to be_invalid
      expect(subject.errors[:nickname]).to include("を入力してください")
    end

    it 'roleが空だと無効' do
      subject.role = nil
      expect(subject).to be_invalid
      expect(subject.errors[:role]).to include("を入力してください")
    end

    it 'emailが空だと無効' do
      subject.email = nil
      expect(subject).to be_invalid
    end

    it 'passwordが短すぎると無効' do
      subject.password = subject.password_confirmation = "12345"
      expect(subject).to be_invalid
    end
  end

  describe '#can_access?' do
    let(:user_parent) { FactoryBot.create(:user, role: :role_parent) }
    let(:user_caregiver) { FactoryBot.create(:user, role: :role_caregiver) }
    let(:child) { FactoryBot.create(:child, user: user_parent) }

    it '親ユーザーは自分の子どもにアクセスできる' do
      expect(user_parent.can_access?(child)).to be true
    end

    it '保育者は共有中ならアクセスできる' do
      FactoryBot.create(:care_relationship, parent: user_parent, caregiver: user_caregiver, child: child, status: :ongoing)
      expect(user_caregiver.can_access?(child)).to be true
    end

    it '保育者が終了済みの場合はアクセスできない' do
      FactoryBot.create(:care_relationship, parent: user_parent, caregiver: user_caregiver, child: child, status: :ended)
      expect(user_caregiver.can_access?(child)).to be false
    end
  end
end