module RecordsHelper
  def icon_for(record_type)
    {
      "milk" => "🍼", "breast_milk" => "🤱", "baby_food" => "🍚", "water" => "💧",
      "sleep" => "🛌", "nap" => "😴", "toilet" => "🧻", "temperature" => "🌡️",
      "medicine" => "💊", "hospital" => "🏥", "bath" => "🛁", "outing" => "🚶‍♀️",
      "event" => "🎉", "concern" => "😣"
    }[record_type]
  end
end