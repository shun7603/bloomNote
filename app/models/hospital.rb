# app/models/hospital.rb
class Hospital < ApplicationRecord
  belongs_to :user

  validates :name, presence: { message: '緊急連絡名を入力してください' }
  validates :phone_number, presence: { message: '電話番号を入力してください' }
  validate :phone_number_format_check

  private

  def phone_number_format_check
    return if phone_number.blank?

    if phone_number.include?('-')
      errors.add(:phone_number, 'ハイフンなしで入力してください')
    elsif phone_number !~ /\A0\d{9,10}\z/
      errors.add(:phone_number, '有効な電話番号を入力してください')
    end
  end
end
