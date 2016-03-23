class AdminController < ApplicationController
  before_action :check_user
	before_action :authenticate_user!
	before_action :set_user, only: [ :user_edit, :user_update, :user_destroy]
	before_action :set_post, only: [ :post_edit, :post_update]
	before_action :check_user_super, only: [:user_data, :user_new, :user_create, :user_edit, :user_update, :user_destroy]
 layout false
  def index
  	if current_user.user_type == "superAdmin"
  		@users_count= User.all.count
  		@posts_count= Post.all.count
  		else
  		@users_count= nil
        @posts_count= current_user.posts.all.count
  	end
  end
  def user_data
    @users= User.all
    respond_to do |format|
      format.html
    end
  end
  def user_new
    @user = User.new
  end
  
  def user_create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_user_data_path, notice: 'User was successfully created.' }
        format.json { render :user_data, status: :created, location: @user }
      else
        format.html { render :user_new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  def user_edit
    
  end
  def user_update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to admin_user_data_path, notice: 'User was successfully updated.' }
        format.json { render :user_data, status: :ok, location: @user }
      else
        format.html { render :user_edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  def user_destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_user_data_path, notice: 'user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def posts
  	if current_user.user_type == "superAdmin"
  		@posts= Post.all
  	else
  	    @posts= current_user.posts.all
  	end
  end
  def post_new
  	@post= current_user.posts.build
  end
  def post_create
  	@post = current_user.posts.build(post_params)
  	if current_user.user_type == "manager"
  		@post.published= false
  	else
  		@post.published= true
  		@post.published_at= Time.now
  		
  	end
    respond_to do |format|
      if @post.save
        format.html { redirect_to admin_posts_path, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
  def post_edit
  	
  end
  def post_update
  	respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to admin_posts_path, notice: 'post was successfully updated.' }
        format.json { render :user_data, status: :ok, location: @post }
      else
        format.html { render :user_edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end


  private

    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email,:password,:password_confirmation,:user_type)
    end
    def set_post
      @post= Post.find(params[:id])
    end
    def post_params
     params.require(:post).permit(:title,:body)
    end
    def check_user
    	if current_user.user_type == "superAdmin" || current_user.user_type == "admin" || current_user.user_type == "manager"
    		else
    			redirect_to root_path, notice: "Access Denied!"
    	end
    end
    def check_user_super
      if current_user.user_type == "superAdmin"
        else
          redirect_to root_path, notice: "Access Denied!"
    end
end
