class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def confirm
      @contact = Contact.new(contact_params)
      @contact.user_id = current_user.id
      if @contact.invalid?
          render :new
      end
  end

  def back
    @contact = Contact.new(contact_params)
    render :new
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.user_id = current_user.id
    if @contact.save
      ContactMailer.send_mail(@contact).deliver_now
      redirect_to mail_done_path
    else
      render :new
    end
  end

  def mail_done
  end

  def show
    @contact = Contact.find(params[:id])
    redirect_to root_path if user_signed_in? && current_user.email != @contact.to_email
  end



  private

  def contact_params
    params.require(:contact).permit(:to_email, :name, :message)
  end
end
