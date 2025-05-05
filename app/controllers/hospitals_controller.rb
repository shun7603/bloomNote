class HospitalsController < ApplicationController
  def new
    @hospital = Hospital.new
  end

  def create
    @hospital = current_user.hospitals.build(hospital_params)

    if @hospital.save
      redirect_to root_path, notice: "病院を登録しました"
    else
      # flashを使ってエラー内容と入力値を一時的に保持
      flash[:hospital_modal_error] = "new" # newの合図
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
      redirect_to root_path # @hospitalは渡らないので、必要ならsessionなど使う
    end
  end

  private

  def hospital_params
    params.require(:hospital).permit(:name, :phone_number)
  end
end
