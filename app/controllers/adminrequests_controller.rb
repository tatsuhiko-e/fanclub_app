class AdminrequestsController < ApplicationController
  def new
    redirect_to new_user_session_path, notice: 'ログインしてからやり直してください' unless user_signed_in?
    redirect_to user_path(current_user) if user_signed_in? && current_user.admin
    @adminrequest = Adminrequest.new

  end

  def confirm
    @adminrequest = Adminrequest.new(adminrequest_params)
    if @adminrequest.invalid?
      render :new
    end
  end

  def back
    @adminrequest = Adminrequest.new(adminrequest_params)
    render :new
  end

  def create
    @adminrequest = Adminrequest.new(adminrequest_params)
    @adminrequest.user_id = current_user.id
    if @adminrequest.save
      AdminrequestMailer.send_mail(@adminrequest).deliver_now
      redirect_to done_path
    else
      render :new
    end
  end

  def done
  end

  private

  def adminrequest_params
    params.require(:adminrequest).permit(:teamname, :twitter_url)
  end
end
