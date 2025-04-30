class ChildrenController < ApplicationController
  before_action :authenticate_user!

  def new
    @child = Child.new
  end

  def create
    @child = current_user.children.build(child_params)
    if @child.save
      redirect_to children_path, notice: '子どもを登録しました'
    else
      render :new
    end
  end

  def index
    @children = current_user.children
  end
  
  def show
    @child = current_user.children.find(params[:id])
  
    # 仮ルーティンを渡す
    @routine = [
      { time: "08:00", task: "ミルク" },
      { time: "09:00", task: "睡眠" },
      { time: "11:00", task: "排泄" }
    ]
  end
  
  def create
    @child = current_user.children.build(child_params)
    if @child.save
      redirect_to child_path(@child), notice: '子どもを登録しました'
    else
      render :new
    end
  end
  private

  def child_params
    params.require(:child).permit(:name, :birth_date, :gender)
  end
end