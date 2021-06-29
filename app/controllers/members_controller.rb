class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @user = User.find_by(id: params[:user_id])
  end

  def new
    @user = User.find_by(id: params[:user_id])
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    @member.user_id = current_user.id
    if @member.save
      flash[:notice] = 'メッセージを投稿しました。'
      redirect_to("users/#{current_user.id}/members/#{@member.id}")
    else
      render("/members/new")
    end
  end

  def edit
    @user = User.find_by(id: params[:user_id])
  end

  def update
    if @member.update(member_params)
      redirect_to 
    else
      render 'edit'
    end
  end

  def destroy
    @member.destroy
    redirect_to root_path
  end

  private

  def set_member
    @member = Member.find(params[:id])
  end

  def member_params
    params.require(:member).permit(:name, :profile, :age, :image)
  end

  def ensure_correct_user
    if @member.user_id != current_user.id
      redirect_to root_path
    end
  end
end
