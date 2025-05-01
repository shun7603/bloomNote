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

  private

  def hospital_params
    params.require(:hospital).permit(:name, :phone_number)
  end
end