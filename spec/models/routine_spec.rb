require 'rails_helper'

RSpec.describe Routine, type: :model do
  let(:child) { FactoryBot.create(:child) }

  subject do
    described_class.new(
      child: child,
      time: "08:00",
      task: "milk"
    )
  end

  describe 'バリデーション' do
    it '有効な内容で保存できる' do
      expect(subject).to be_valid
    end

    it 'timeがないと無効' do
      subject.time = nil
      expect(subject).to be_invalid
      expect(subject.errors[:time]).to include("を入力してください")
    end

    it 'taskがないと無効' do
      subject.task = nil
      expect(subject).to be_invalid
      expect(subject.errors[:task]).to include("を入力してください")
    end

    it 'childが紐づいていないと無効' do
      subject.child = nil
      expect(subject).to be_invalid
    end
  end

  describe '#task_label' do
    it 'taskがmilkのとき、日本語表記を返す' do
      subject.task = "milk"
      expect(subject.task_label).to eq("ミルク")
    end
  end

  describe '.task_options_for_select' do
    it '日本語ラベルと英語キーの配列を返す' do
      expect(Routine.task_options_for_select).to include(%W[\u30DF\u30EB\u30AF milk])
    end
  end
end