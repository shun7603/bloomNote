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

  private

  def child_params
    params.require(:child).permit(:name, :birth_date, :gender)
  end
end