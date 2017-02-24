class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_admin_user!

  def ensure_admin_user!
    unless current_user.is_admin?
      redirect_to root_path, alert: "You don't belong there!"
    end
  end

  # GET /people
  # GET /people.json
  def index
    @users = User.all
  end

  # GET /people/1
  # GET /people/1.json
  def show
  end

  # GET /people/new
  def new
    @user = User.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  # POST /people.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'Person was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Person was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    if @user.id != 1 && @user.id != current_user.id && @user.is_super != 't'
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'Login account was successfully deleted.' }
      format.json { head :no_content }
    end
    else
      respond_to do |format|
        format.html { redirect_to users_url, alert: 'Cannot delete superuser or currently logged in admin.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:id, :name, :email, :current_account, :current_transaction, :password, :password_confirmation, :is_admin, :is_user, :is_super)
    end

end
