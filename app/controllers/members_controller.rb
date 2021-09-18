class MembersController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_to_root, only: [:new]
  before_action :set_user, only: [:show, :new, :edit]
  before_action :set_member, only: [:show, :edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show

  end

  def new

    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    @member.user_id = current_user.id
    if @member.save
      flash[:notice] = 'メッセージを投稿しました。'
      redirect_to member_path(@member)
    else
      render("/members/new")
    end
  end

  def edit

  end

  def update
    if @member.update(member_params)
      redirect_to member_path(@member)
    else
      render 'edit'
    end
  end

  def destroy
    @member.destroy
    redirect_to user_path(current_user)
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])
  end

  def set_member
    @member = Member.find(params[:id])
  end

  def member_params
    params.require(:member).permit(:name, :profile, :age, :twitter, :instagram, :email, :birthday, :image)
  end

  def ensure_correct_user
    if @member.user_id != current_user.id
      redirect_to user_path(current_user)
    end
  end

  def redirect_to_root
    redirect_to user_path(current_user) if current_user.admin == false
  end
end
