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
    @friend = Friend.new
  end

  # GET /friends/1/edit
  def edit
  end

  # POST /friends
  # POST /friends.json
  def create
    @friend = Friend.new(friend_params)
    @friend['friend2'] = current_user.id
    orig = @friend['friend1']
    results = ActiveRecord::Base.connection.execute("SELECT id FROM users WHERE email=\'#{@friend['friend1']}\'")
    results2 = ActiveRecord::Base.connection.execute("SELECT id FROM users WHERE name=\'#{@friend['friend1']}\'")
    if(results.present?)
      @friend['friend1'] = results[0][0]
      already_added  = Friend.where(:friend1 => @friend['friend1'], :friend2 => current_user.id)
      if already_added.present? == false
        already_added  = Friend.where(:friend2 => @friend['friend1'], :friend1 => current_user.id)
      end
    else
      if(results2.present?)
        @friend['friend1'] = results2[0][0]
        already_added  = Friend.where(:friend1 => @friend['friend1'], :friend2 => current_user.id)
        if already_added.present? == false
          already_added  = Friend.where(:friend2 => @friend['friend1'], :friend1 => current_user.id)
        end
      else
        @friend['friend1'] = "Database"
      end
    end

    if(already_added.present?)
      @friend['friend1'] = "Duplicate"
    end

    if(orig == '')
      @friend['friend1'] = orig
    end
    if(@friend['friend1'] == @friend['friend2'] || @friend['friend1'] == 0 )
      @friend['friend1'] = 'Repeat'
    end

    respond_to do |format|
      if( @friend.save)
        format.html { redirect_to @friend, notice: 'Friend was successfully added.' }
        format.json { render :show, status: :created, location: @friend }
      else
        format.html { render :new }
        format.json { render json: @friend.errors, status: :unprocessable_entity }
        @friend['friend1'] = orig
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
      params.require(:friend).permit(:friend1)
    end
end
