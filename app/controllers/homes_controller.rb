class HomesController < ApplicationController
  def index
    @records = Record.order(created_at: :desc).limit(10)
  end

  def add_milk
    
  end
end
