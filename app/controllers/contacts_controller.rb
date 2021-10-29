class ContactsController < ApplicationController
  def confirm
      @contact = Contact.new(contact_params)
      if @contact.invalid?
          render :new
      end
  end
  # 入力内容に誤りがあった場合、
  # 入力内容を保持したまま前のページに戻るのが当たり前になっているかと思いますが、
  # backアクションを定義することで可能となります。
  def back
    @contact = Contact.new(contact_params)
    render :new
  end

  # 実際に送信するアクションになります。
  # ここで初めて入力内容を保存します。
  # セキュリティーのためにも一定時間で入力内容の削除を行ってもいいかもしれません。
  def create
    @contact = Contact.new(contact_params)
    
    if @contact.save
      ContactMailer.send_mail(@contact).deliver_now
      redirect_to done_path
    else
      render :new
    end
  end

  # 送信完了画面を使用する場合お使いください。
  def done
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :name, :phone_number, :message)
  end
end
