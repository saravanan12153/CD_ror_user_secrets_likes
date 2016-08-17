require 'rails_helper'
RSpec.describe LikesController, type: :controller do

  before do
    user = create_user
    secret = user.secrets.create(content: "Oops")
    @like = user.likes.create(user: user, secret: secret)
  end

  describe "when not logged in" do
    before do
      session[:user_id] = nil
    end

    it "user cannot add a like" do
      post :create
      expect(response).to redirect_to('/sessions/new')
    end

    it "user cannot unlike" do
      delete :destroy, id: @like
      expect(response).to redirect_to('/sessions/new')
    end
  end

  describe "when signed in as the wrong user" do
    before do
      @wrong_user = create_user 'julius', 'julius@lakers.com'
      session[:user_id] = @wrong_user.id
      @secret = Secret.create(content: 'Ooops', user_id: @user)
    end

    it "user cannot add a like" do
      post :create
      expect(response).to redirect_to("/users/#{@wrong_user.id}")
    end

    # it "user cannot unlike" do
    #   delete :destroy, id: @like
    #   expect(response).to redirect_to("/users/#{@wrong_user.id}")
    # end
  end

end
