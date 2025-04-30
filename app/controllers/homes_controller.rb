class HomesController < ApplicationController
  before_action :authenticate_user!

  def index
    @children = current_user.children  
    
    @routine = [
      { time: "08:00", task: "ミルク" },
      { time: "09:00", task: "睡眠" },
      { time: "11:00", task: "排泄" }
    ]
  end
end