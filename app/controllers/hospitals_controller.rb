class HospitalsController < ApplicationController
  def new
    @hospital = Hospital.new
  end

  def create
    @hospital = current_user.hospitals.build(hospital_params)
    if @hospital.save
      redirect_to root_path, notice: '病院を登録しました'
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @hospital = Hospital.find(params[:id])
  end

  def update
    @hospital = Hospital.find(params[:id])
    if @hospital.update(hospital_params)
      redirect_to root_path, notice: '病院情報を更新しました'
    else
      flash[:alert] = '更新に失敗しました'
      redirect_to root_path
    end
  end


  private

  def hospital_params
    params.require(:hospital).permit(:name, :phone_number)
  end
end