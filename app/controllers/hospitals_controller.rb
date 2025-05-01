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

  def update
    @hospital = Hospital.find(params[:id])
    if @hospital.update(hospital_params)
      redirect_to root_path, notice: '病院情報を更新しました'
    else
      flash.now[:edit_hospital_id] = @hospital.id
      render 'homes/index', status: :unprocessable_entity
    end
  end

  private

  def hospital_params
    params.require(:hospital).permit(:name, :phone_number)
  end
end
