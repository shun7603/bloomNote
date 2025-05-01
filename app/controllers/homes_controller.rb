class HomesController < ApplicationController
  def index
    @children = current_user.children.includes(:routines, :records)
  
    # 仮データを用意（ダミー表示用）
    @routine = [
      { time: "08:00", task: "ミルク" },
      { time: "09:00", task: "睡眠" },
      { time: "11:00", task: "排泄" }
    ]
  end
end