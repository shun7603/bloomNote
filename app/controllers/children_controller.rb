class ChildrenController < ApplicationController
  before_action :authenticate_user!

  def index
    @children = current_user.children.includes(:routines)
    @routine = [
      { time: '08:00', task: 'ミルク' },
      { time: '09:00', task: '睡眠' },
      { time: '11:00', task: '排泄' }
    ]
  end

  def show
    @child = current_user.children.find(params[:id])
    @routine = [
      { time: '08:00', task: 'ミルク' },
      { time: '09:00', task: '睡眠' },
      { time: '11:00', task: '排泄' }
    ]
  end

  def create
    @child = current_user.children.build(child_params)
    if @child.save
      redirect_to root_path, notice: '子どもを登録しました'
    else
      render :new
    end
  end

  def update
    @child = Child.find(params[:id])
    if @child.update(child_params)
      redirect_to root_path, notice: '子ども情報を更新しました'
    else
      flash[:edit_child_error] = true
      flash[:child_errors] = @child.errors.full_messages
      flash[:child_id] = @child.id
      redirect_to root_path
    end
  end

  private

  def child_params
    params.require(:child).permit(:name, :birth_date, :gender)
  end
end
