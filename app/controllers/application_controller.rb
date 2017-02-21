class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    attributes = [:id, :name, :email, :current_account, :current_transaction, :password, :password_confirmation, :is_admin, :is_user, :is_super]
    attributes2 = [:id, :name, :email, :current_account, :current_transaction, :password, :password_confirmation, :is_admin, :is_user, :is_super, :current_password]

    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    devise_parameter_sanitizer.permit(:account_update, keys: attributes2)

    #devise_parameter_sanitizer.for(:sign_up).push()
    #devise_parameter_sanitizer.for(:account_update).push(:id, :name, :email, :current_account, :current_transaction, :password, :password_confirmation, :is_admin, :is_user, :is_super, :current_password)
  end

end
