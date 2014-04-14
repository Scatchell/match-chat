require 'spec_helper'

describe ChatroomsController do

  let(:valid_attributes) { {} }

  let(:valid_session) { {} }

  before { controller.stub(:authenticate_user!).and_return true }

  let(:current_user) { User.create!(email: 'test@test.com', password: 'testtest', name: 'test') }

  before { controller.stub(:current_user).and_return current_user }

  describe 'GET index' do
    it 'assigns all chatrooms as @chatrooms' do
      chatroom = Chatroom.create! valid_attributes
      chatroom2 = Chatroom.create! valid_attributes
      get :index, {}, valid_session
      assigns(:chatrooms).to_a.should eq([chatroom, chatroom2])
    end
  end

  describe 'GET show' do
    before { controller.stub(:alert_chatroom_of_new_user) }

    it 'assigns the requested chatroom as @chatroom' do
      chatroom = Chatroom.create! valid_attributes

      get :show, {:id => chatroom.to_param}, valid_session
      assigns(:chatroom).should eq(chatroom)
    end

    it 'assigns the requested chatrooms users as @users, not including the current users name' do
      #todo make name on user manditory
      #todo extract the long User.create to some common method or helper for these tests
      user2 = User.create!(email: 'test2@test.com', password: 'testtest', name: 'user2')
      chatroom = Chatroom.create! users: [current_user, user2]

      get :show, {:id => chatroom.to_param}, valid_session
      flash[:notice].include?(user2.name).should be_true
      flash[:notice].include?(current_user.name).should_not be_true
    end

    it 'assigns a string to users when current user is the only user connected' do
      chatroom = Chatroom.create! users: [current_user]

      get :show, {:id => chatroom.to_param}, valid_session
      flash[:notice].include?(ChatroomsController::ONLY_USER_MESSAGE).should be_true
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
      chatroom = Chatroom.create! valid_attributes
      get :edit, {:id => chatroom.to_param}, valid_session
      assigns(:chatroom).should eq(chatroom)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Chatroom' do
        expect {
          post :create, {:chatroom => valid_attributes}, valid_session
        }.to change(Chatroom, :count).by(1)

      end

      it 'assigns a newly created chatroom as @chatroom' do
        post :create, {:chatroom => valid_attributes}, valid_session
        assigns(:chatroom).should be_a(Chatroom)
        assigns(:chatroom).should be_persisted
      end

      it 'redirects to the created chatroom' do
        post :create, {:chatroom => valid_attributes}, valid_session
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
        chatroom = Chatroom.create! valid_attributes
        # Assuming there are no other chatrooms in the database, this
        # specifies that the Chatroom created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Chatroom.any_instance.should_receive(:update).with({'title' => 'test'})
        put :update, {:id => chatroom.to_param, :chatroom => {'title' => 'test'}}, valid_session
      end

      it 'assigns the requested chatroom as @chatroom' do
        chatroom = Chatroom.create! valid_attributes
        put :update, {:id => chatroom.to_param, :chatroom => valid_attributes}, valid_session
        assigns(:chatroom).should eq(chatroom)
      end

      it 'redirects to the chatroom' do
        chatroom = Chatroom.create! valid_attributes
        put :update, {:id => chatroom.to_param, :chatroom => valid_attributes}, valid_session
        response.should redirect_to(chatroom)
      end
    end

    describe 'with invalid params' do
      it 'assigns the chatroom as @chatroom' do
        chatroom = Chatroom.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Chatroom.any_instance.stub(:save).and_return(false)
        put :update, {:id => chatroom.to_param, :chatroom => {}}, valid_session
        assigns(:chatroom).should eq(chatroom)
      end

      it 're-renders the edit template' do
        chatroom = Chatroom.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Chatroom.any_instance.stub(:save).and_return(false)
        put :update, {:id => chatroom.to_param, :chatroom => {}}, valid_session
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested chatroom and all associated sessions' do
      chatroom = Chatroom.create! valid_attributes
      Session.create!(chatroom: chatroom)

      expect {
        delete :destroy, {:id => chatroom.to_param}, valid_session
      }.to change(Chatroom, :count).by(-1)

      Session.count.should == 0
    end

    it 'redirects to the chatrooms list' do
      chatroom = Chatroom.create! valid_attributes
      delete :destroy, {:id => chatroom.to_param}, valid_session
      response.should redirect_to(chatrooms_url)
    end
  end

end
