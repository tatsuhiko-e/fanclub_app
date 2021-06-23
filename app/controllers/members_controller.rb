class MembersController < ApplicationController
  before_action :set_member, only: [:show]
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.find_by(id: params[:user_id])
    @member = Member.new
    @member.user_id = current_user.id
  end

  def create
    @member = Member.new(member_params)
    @member.user_id = current_user.id
    if @member.save
      flash[:notice] = 'メッセージを投稿しました。'
      redirect_to user_url(@member)
    else
      render("/members/new")
    end
  end

  def edit
  end

  def update
  end

  def destroy
    member.destroy
  end

  private

  def set_member
    @member = Member.find(params[:id])
  end

  def member_params
    params.require(:member).permit(:member, :profile, :age, :image)
  end
end
