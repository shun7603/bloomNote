# app/controllers/homes_controller.rb
class HomesController < ApplicationController
  def index
    @routine = [
      { time: '08:00', task: 'ミルク' },
      { time: '09:00', task: '睡眠' },
      { time: '11:00', task: '排泄' }
    ]
  end
end