class FriendsController < ApplicationController
  #before_action :authenticate_user!
  before_action :set_friend, only: [:show, :edit, :update, :destroy]

  # GET /friends
  # GET /friends.json
  def index
    @friends = Friend.all
  end

  # GET /friends/1
  # GET /friends/1.json
  def show
  end

  # GET /friends/new
  def new
    @selection = params[:id]
    @search = params[:search]
    @my_friend = Friend.all
    @friend = Friend.new
    #@my_set
    #if params[:id] != nil && params[:id] != '0'
      @my_set = User.all.where("name like ? OR email like ?", "%#{@search}%","%#{@search}%")
    #end
    @my_users = User.all

    @current_friends = Friend.where(:friend2 => current_user.id)
  end

  # GET /friends/1/edit
  def edit
  end

  # POST /friends
  # POST /friends.json
  def create
    @selection = params[:id]
    if params[:id] != '0' && params[:this_friend] == nil
      @friend = Friend.new(friend_params)
      puts "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nInside If statement: "
      puts @selection
      puts @friend['friend1']
      redirect_to new_friend_path(:id => @selection, :search => @friend['friend1'])
    else

    @friend = Friend.new

    @friend['friend2'] = current_user.id

    if params[:this_friend].present?
      @friend['friend1'] = params[:this_friend]
      already_added  = Friend.where(:friend1 => @friend['friend1'], :friend2 => current_user.id)
      if already_added.present? == false
        already_added  = Friend.where(:friend2 => @friend['friend1'], :friend1 => current_user.id)
      end
    else
      @friend['friend1'] = "Database"
    end

    if(already_added.present?)
      @friend['friend1'] = "Duplicate"
    end

    if(@friend['friend1'] == @friend['friend2'] || @friend['friend1'] == 0 )
      @friend['friend1'] = 'Repeat'
    end

    puts "\n\n\n\n\n\n\n\nThe new friend id is: "
    puts @friend.id
    puts @friend.friend1
    puts @friend.friend2

    respond_to do |format|
      if( @friend.save)
        format.html { redirect_to @friend, notice: 'Friend was successfully added.' }
        format.json { render :show, status: :created, location: @friend }
      else
        format.html { render :new }
        format.json { render json: @friend.errors, status: :unprocessable_entity }
      end
    end
    end
  end

  # PATCH/PUT /friends/1
  # PATCH/PUT /friends/1.json
  def update
    respond_to do |format|
      if @friend.update(friend_params)
        format.html { redirect_to @friend, notice: 'Friend was successfully updated.' }
        format.json { render :show, status: :ok, location: @friend }
      else
        format.html { render :edit }
        format.json { render json: @friend.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friends/1
  # DELETE /friends/1.json
  def destroy
    @friend.destroy
    respond_to do |format|
      format.html { redirect_to friends_url, notice: 'Friendship was successfully terminated.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friend
      @friend = Friend.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def friend_params
      params.require(:friend).permit(:friend1, :friend2)
    end
end
