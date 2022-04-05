class RodauthMailer < ApplicationMailer
  def verify_account(account_id, key, name = nil)
    @email_link = rodauth(name).verify_account_url(key: email_token(account_id, key, name))
    @account = Account.find(account_id)

    mail to: @account.email, subject: rodauth(name).verify_account_email_subject
  end

  def reset_password(account_id, key, name = nil)
    @email_link = rodauth(name).reset_password_url(key: email_token(account_id, key, name))
    @account = Account.find(account_id)

    mail to: @account.email, subject: rodauth(name).reset_password_email_subject
  end

  def verify_login_change(account_id, old_login, new_login, key, name = nil)
    @old_login  = old_login
    @new_login  = new_login
    @email_link = rodauth(name).verify_login_change_url(key: email_token(account_id, key, name))
    @account = Account.find(account_id)

    mail to: new_login, subject: rodauth(name).verify_login_change_email_subject
  end

  def password_changed(account_id, name = nil)
    @account = Account.find(account_id)

    mail to: @account.email, subject: rodauth(name).password_changed_email_subject
  end

  # def email_auth(account_id, key, name = nil)
  #   @email_link = rodauth(name).email_auth_url(key: email_token(account_id, key, name))
  #   @account = Account.find(account_id)

  #   mail to: @account.email, subject: rodauth(name).email_auth_email_subject
  # end

  # def unlock_account(account_id, key, name = nil)
  #   @email_link = rodauth(name).unlock_account_url(key: email_token(account_id, key, name))
  #   @account = Account.find(account_id)

  #   mail to: @account.email, subject: rodauth(name).unlock_account_email_subject
  # end

  private

  def email_token(account_id, key, name)
    "#{account_id}_#{rodauth(name).compute_hmac(key)}"
  end

  def rodauth(name)
    RodauthApp.rodauth(name).allocate
  end
end
