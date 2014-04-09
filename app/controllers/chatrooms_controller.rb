class ChatroomsController < ApplicationController
  before_action :set_chatroom, only: [:show, :edit, :update, :destroy]

  before_filter :authenticate_user!, only: [:create, :new, :update, :destroy, :show]

  # GET /chatrooms
  # GET /chatrooms.json
  def index
    @chatrooms = Chatroom.all
    @topics = Topic.all
  end

  # GET /chatrooms/1
  # GET /chatrooms/1.json
  def show
    if !@chatroom.users.include? current_user
      @chatroom.users.push current_user
    end

    alert_chatroom_of_new_user(@chatroom)

    @users = @chatroom.users.nil? ? 'none' : @chatroom.users.collect(&:name)
    @messages = @chatroom.messages.order(:created_at)
  end

  def append_chat
    # Thread.new do
    #   sleep(5)
    #   puts 'sending...'
    #   append_chat
    # end
  end

  # GET /chatrooms/new
  def new
    @chatroom = Chatroom.new
  end

  # GET /chatrooms/1/edit
  def edit
  end

  # POST /chatrooms
  # POST /chatrooms.json
  def create
    @chatroom = Chatroom.new(chatroom_params)

    respond_to do |format|
      if @chatroom.save
        format.html { redirect_to @chatroom, notice: 'Chatroom was successfully created.' }
        format.json { render action: 'show', status: :created, location: @chatroom }
      else
        format.html { render action: 'new' }
        format.json { render json: @chatroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chatrooms/1
  # PATCH/PUT /chatrooms/1.json
  def update
    respond_to do |format|
      if @chatroom.update(chatroom_params)
        format.html { redirect_to @chatroom, notice: 'Chatroom was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @chatroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chatrooms/1
  # DELETE /chatrooms/1.json
  def destroy
    #todo write test for the following comment
    # @chatroom.sessions.destroy_all
    @chatroom.destroy

    respond_to do |format|
      format.html { redirect_to chatrooms_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_chatroom
    @chatroom = Chatroom.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def chatroom_params
    params[:chatroom].permit(:title, :description)
  end

  private
  def alert_chatroom_of_new_user(chatroom)
    message = "<li><span class=\"created_at\">[#{Time.now.strftime('%H:%M')}]</span>#{current_user.name} has connected!</li>"

    PrivatePub.publish_to('/messages/new/' + chatroom.id.to_s,
                          "$('#chat').append('#{message}');")
  end
end
