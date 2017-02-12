class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  private
  
  def current_user
    Person.where(id: session[:person_id]).first
  end
  helper_method :current_user
end
