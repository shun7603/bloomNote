class Record < ApplicationRecord
  belongs_to :child
  
  def record_type_i18n
    { "milk" => "ミルク", "sleep" => "睡眠", "diaper" => "排泄" }[self.record_type]
  end
end

