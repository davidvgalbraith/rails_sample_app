class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update, :index, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :unsigned_user, only: [:new, :create]

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def unsigned_user
    redirect_to(root_url) if current_user
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def destroy
    wictim = User.find(params[:id])
    if wictim != current_user
      wictim.destroy
      flash[:success] = "User destroyed"
    end
    redirect_to users_url
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if (@user.update_attributes(user_params))
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
    
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

end
