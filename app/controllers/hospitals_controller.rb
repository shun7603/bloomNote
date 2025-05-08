class HospitalsController < ApplicationController
  def new
    @hospital = Hospital.new
  end

  def create
    @hospital = current_user.hospitals.build(hospital_params)
    @hospital.user = current_user
    if @hospital.save
      redirect_to root_path, notice: "病院を登録しました"
    else
      flash[:hospital_modal_error] = "new"
      flash[:hospital_errors] = @hospital.errors.full_messages
      flash[:hospital_attributes] = hospital_params
      redirect_to root_path
    end
  end

  # hospitals_controller.rb
  def update
    @hospital = Hospital.find(params[:id])
    if @hospital.update(hospital_params)
      redirect_to root_path, notice: "更新しました"
    else
      flash[:hospital_modal_error] = @hospital.id
      flash[:hospital_errors] = @hospital.errors.full_messages
      redirect_to root_path
    end
  end

  private

  def hospital_params
    params.require(:hospital).permit(:name, :phone_number, :child_id)
  end
end
