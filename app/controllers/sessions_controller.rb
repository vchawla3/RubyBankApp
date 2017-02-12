class SessionsController < ApplicationController


  def new

  end

  def create
    @person = Person.where(email: params[:email]).first
    if @person.authentication(params[:password])
      session[:person_id] = @person.id
      redirect_to root_path, notice: 'Logged in!'
    else
      flash[:error] = 'Invalid email or password'
      render :new
    end
  end

  def destroy
    session[:person_id] = nil
    redirect_to root_path, notice: 'Logged out!'

  end

end
