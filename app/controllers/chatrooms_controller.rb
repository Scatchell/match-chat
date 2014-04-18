class ChatroomsController < ApplicationController
  before_action :set_chatroom, only: [:show, :edit, :update, :destroy]

  before_filter :authenticate_user!, only: [:create, :new, :update, :destroy, :show]

  # GET /chatrooms
  # GET /chatrooms.json
  def index
    @chatrooms = Chatroom.all
  end

  # GET /chatrooms/1
  # GET /chatrooms/1.json
  ONLY_USER_MESSAGE = 'You\'re the only user here at the moment, hopefully someone will join soon.'

  def show
    chatrooms_users = @chatroom.users

    if !chatrooms_users.include? current_user
      chatrooms_users.push current_user
    end

    alert_chatroom_of_new_user(@chatroom)

    chatrooms_users_names = chatrooms_users.select { |user| user != current_user }.collect(&:name)

    @messages = @chatroom.messages.order(:created_at)

    currently_connect_users_string = "Currently connected users: <strong>#{chatrooms_users_names.join(', ')}</strong>" unless chatrooms_users_names.nil?
    flash[:chat_flash] = chatrooms_users_names.empty? ? ONLY_USER_MESSAGE : currently_connect_users_string
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
    if @chatroom.session
      @chatroom.session.destroy
    end

    @chatroom.destroy

    respond_to do |format|
      format.html { redirect_to topics_url }
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
    message = "<li><span class=\"created_at\">[#{Time.now.strftime('%H:%M')}]</span> #{current_user.name} has connected!</li>"

    PrivatePub.publish_to('/messages/new/' + chatroom.id.to_s,
                          "$('#chat').append('#{message}');")
  end
end
