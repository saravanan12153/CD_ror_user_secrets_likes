class UsersController < ApplicationController
    before_action :require_login, except: [:new, :create]
    before_action :require_correct_user, only: [:show, :edit, :update, :destroy]

    def show
        @user = User.find(params[:id])
        @secrets = @user.secrets
        @secrets_liked = @user.secrets_liked.group(:id).order(:id)
    end

    def index
        if session[:user_id]
          redirect_to current_user
        else
          redirect_to '/sessions/new'
        end
    end

    def new
    end

    def edit
        @user = User.find(params[:id])
    end

    def create
        @user = User.new(name: params[:name], email: params[:email], password: params[:password])
        if @user.save
            session[:user_id] = @user.id
            redirect_to current_user
        else
            flash[:errors] = @user.errors.full_messages
            redirect_to :back
        end
    end

    def update
        @user = User.find(params[:id]).update(name: params[:name], email: params[:email])
		redirect_to '/users/'+params[:id]

    end

    def destroy
        User.find(params[:id]).destroy
        session[:user_id] = nil
        redirect_to '/sessions/new'
    end

    private
    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
