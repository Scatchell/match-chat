require 'spec_helper'

describe ChatroomsController do

  let(:valid_session) { {} }

  before { controller.stub(:authenticate_user!).and_return true }

  let(:current_user) { create(:user) }

  before { controller.stub(:current_user).and_return current_user }

  describe 'GET index' do
    it 'should assign all chatrooms as @chatrooms' do
      chatroom = create(:chatroom)
      chatroom2 = create(:chatroom)
      get :index, {}, valid_session
      assigns(:chatrooms).to_a.should eq([chatroom, chatroom2])
    end

    it 'should assign only chatrooms without an ending time as @chatrooms' do
      chatroom = create(:chatroom)
      create(:chatroom, ended_at: Time.now)

      get :index, {}, valid_session
      assigns(:chatrooms).to_a.should eq([chatroom])
    end
  end

  describe 'GET show' do
    before { controller.stub(:send_new_user_alert_for) }

    it 'assigns the requested chatroom as @chatroom' do
      chatroom = create(:chatroom)

      get :show, {:id => chatroom.to_param}, valid_session
      assigns(:chatroom).should eq(chatroom)
    end

    it 'assigns the requested chatrooms users as @users, not including the current users name' do
      user2 = create(:user, name: 'not_current_user')
      chatroom = create(:chatroom, users: [current_user, user2])

      get :show, {:id => chatroom.to_param}, valid_session
      flash[:chat_flash].include?(user2.name).should be_true
      flash[:chat_flash].include?(current_user.name).should_not be_true
    end

    it 'assigns a string to users when current user is the only user connected' do
      chatroom = create(:chatroom, users: [current_user])

      get :show, {:id => chatroom.to_param}, valid_session
      flash[:chat_flash].include?(ChatroomsController::ONLY_USER_MESSAGE).should be_true
    end
  end

  describe 'GET new' do
    it 'assigns a new chatroom as @chatroom' do
      get :new, {}, valid_session
      assigns(:chatroom).should be_a_new(Chatroom)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested chatroom as @chatroom' do
      chatroom = create(:chatroom)
      get :edit, {:id => chatroom.to_param}, valid_session
      assigns(:chatroom).should eq(chatroom)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Chatroom' do
        expect {
          post :create, {:chatroom => attributes_for(:chatroom)}, valid_session
        }.to change(Chatroom, :count).by(1)

      end

      it 'assigns a newly created chatroom as @chatroom' do
        post :create, {:chatroom => attributes_for(:chatroom)}, valid_session
        assigns(:chatroom).should be_a(Chatroom)
        assigns(:chatroom).should be_persisted
      end

      it 'redirects to the created chatroom' do
        post :create, {:chatroom => attributes_for(:chatroom)}, valid_session
        response.should redirect_to(Chatroom.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved chatroom as @chatroom' do
        # Trigger the behavior that occurs when invalid params are submitted
        Chatroom.any_instance.stub(:save).and_return(false)
        post :create, {:chatroom => {}}, valid_session
        assigns(:chatroom).should be_a_new(Chatroom)
      end

      it 're-renders the new template' do
        # Trigger the behavior that occurs when invalid params are submitted
        Chatroom.any_instance.stub(:save).and_return(false)
        post :create, {:chatroom => {}}, valid_session
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested chatroom' do
        chatroom = create(:chatroom)
        # Assuming there are no other chatrooms in the database, this
        # specifies that the Chatroom created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Chatroom.any_instance.should_receive(:update).with({'title' => 'test'})
        put :update, {:id => chatroom.to_param, :chatroom => {'title' => 'test'}}, valid_session
      end

      it 'assigns the requested chatroom as @chatroom' do
        chatroom = create(:chatroom)
        put :update, {:id => chatroom.to_param, :chatroom => attributes_for(:chatroom)}, valid_session
        assigns(:chatroom).should eq(chatroom)
      end

      it 'redirects to the chatroom' do
        chatroom = create(:chatroom)
        put :update, {:id => chatroom.to_param, :chatroom => attributes_for(:chatroom)}, valid_session
        response.should redirect_to(chatroom)
      end
    end

    describe 'with invalid params' do
      it 'assigns the chatroom as @chatroom' do
        chatroom = create(:chatroom)
        # Trigger the behavior that occurs when invalid params are submitted
        Chatroom.any_instance.stub(:save).and_return(false)
        put :update, {:id => chatroom.to_param, :chatroom => {}}, valid_session
        assigns(:chatroom).should eq(chatroom)
      end

      it 're-renders the edit template' do
        chatroom = create(:chatroom)
        # Trigger the behavior that occurs when invalid params are submitted
        Chatroom.any_instance.stub(:save).and_return(false)
        put :update, {:id => chatroom.to_param, :chatroom => {}}, valid_session
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested chatroom and all associated sessions' do
      chatroom = create(:chatroom)
      create(:session, chatroom: chatroom)

      expect {
        delete :destroy, {id: chatroom.to_param}, valid_session
      }.to change(Chatroom, :count).by(-1)

      Session.count.should == 0
    end

    it 'redirects to the topics list' do
      chatroom = create(:chatroom)
      delete :destroy, {id: chatroom.to_param}, valid_session
      response.should redirect_to(topics_url)
    end
  end

  describe 'PUT end chat' do
    it 'should not update a chats ended at time' do
      chatroom = create(:chatroom)

      chatroom.ended_at.should == nil

      expected_chatroom_ended_at_time = Time.local(2011, 1, 1, 11, 1, 1)
      Timecop.freeze(expected_chatroom_ended_at_time)

      put :end_chat, {id: chatroom.to_param}, valid_session

      disconnect_users

      Chatroom.last.ended_at.should == expected_chatroom_ended_at_time
    end
  end
end
