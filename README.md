# MultiLangAdminBlog

MultiLangAdminBlog is a modern blogging application built with Ruby on Rails. The application features an admin panel, user management, authentication, multi-language support, and more.

## Features

- **Admin Panel**: Manage posts, pages, users, and comments through an intuitive admin interface.
- **User Roles**: Support for various user types including admin, super admin, and general users.
- **Authentication**: Secure user login and registration with Devise.
- **Multi-Language Support**: Implemented using I18n for translations of posts and comments.
- **CRUD Operations**: Create, read, update, and delete posts, pages, and user accounts.
- **Media Management**: Upload and manage images with Paperclip.
- **Categories and Tags**: Organize content using categories and tags.
- **Responsive Design**: Mobile-friendly layout with modern HTML5 and CSS3.

## Getting Started

### Prerequisites

- Ruby 2.7.2
- Rails 5.2.4
- PostgreSQL

### Installation

1. **Clone the repository**:
    ```bash
    git clone https://github.com/saqibroy/us-rails-updated.git
    cd MultiLangAdminBlog
    ```

2. **Install dependencies**:
    ```bash
    bundle install
    yarn install
    ```

3. **Setup the database**:
    ```bash
    rails db:create
    rails db:migrate
    rails db:seed
    ```

4. **Start the Rails server**:
    ```bash
    rails server
    ```

5. **Access the application**:
    Open your web browser and navigate to `http://localhost:3000`.

## File Structure

### Database Schema

The database schema includes tables for users, posts, pages, categories, comments, images, and translations. Here is an overview of the schema:

```ruby name=db/schema.rb
ActiveRecord::Schema.define(version: 20160326174348) do
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
  add_index "categories", ["user_id"], name: "index_categories_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.string   "image_title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end
  add_index "images", ["user_id"], name: "index_images_on_user_id", using: :btree

  create_table "links", force: :cascade do |t|
    t.string   "url"
    t.string   "name"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "page_translations", force: :cascade do |t|
    t.integer  "page_id",    null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.text     "content"
  end
  add_index "page_translations", ["locale"], name: "index_page_translations_on_locale", using: :btree
  add_index "page_translations", ["page_id"], name: "index_page_translations_on_page_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_translations", force: :cascade do |t|
    t.integer  "post_id",    null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "title"
    t.text     "body"
  end
  add_index "post_translations", ["locale"], name: "index_post_translations_on_locale", using: :btree
  add_index "post_translations", ["post_id"], name: "index_post_translations_on_post_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.boolean  "published"
    t.datetime "published_at"
    t.integer  "user_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "arabic"
  end
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "username"
    t.string   "nom"
    t.string   "prenom"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "user_type"
  end
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
end
```

### Controllers

#### PostsController

Handles CRUD operations for posts.

```ruby name=app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all
  end

  def show
  end

  def new
    @post = current_user.posts.build
  end

  def edit
  end

  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to admin_posts_path, notice: t('forms.messages.success') }
      format.json { head :no_content }
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :published, :published_at)
  end
end
```

#### PagesController

Handles CRUD operations for pages.

```ruby name=app/controllers/pages_controller.rb
class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  def index
    @pages = Page.all
  end

  def show
  end

  def new
    @page = Page.new
  end

  def edit
  end

  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render :show, status: :created, location: @page }
      else
        format.html { render :new }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to pages_url, notice: 'Page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def page_params
    params.require(:page).permit(:name, :content)
  end
end
```

#### AdminController

Handles admin-specific actions and user management.

```ruby name=app/controllers/admin_controller.rb
class AdminController < ApplicationController
  before_action :check_user
  before_action :authenticate_user!
  before_action :set_user, only: [:user_edit, :user_update, :user_destroy]
  before_action :set_post, only: [:post_edit, :post_update]
  before_action :check_user_super, only: [:user_data, :user_new, :user_create, :user_edit, :user_update, :user_destroy]
  layout false

  def index
    @users_count = User.all.count
    if current_user.user_type == "superAdmin"
      @posts_count = Post.all.count
    else
      @users_count = nil
      @posts_count = current_user.posts.all.count
    end
  end

  def user_data
    @users = User.all
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
        format.html { redirect_to admin_user_data_path, notice: t('forms.messages.success') }
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
        format.html { redirect_to admin_user_data_path, notice: t('forms.messages.success') }
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
      format.html { redirect_to admin_user_data_path, notice: t('forms.messages.success') }
      format.json { head :no_content }
    end
  end

  def posts
    if current_user.user_type == "superAdmin"
      @posts = Post.all
    else
      @posts = current_user.posts.all
    end
  end

  def post_new
    @post = current_user.posts.build
  end

  def post_create
    @post = current_user.posts.build(post_params)
    if @l == :fr
      @post.arabic = false
    else
      @post.arabic = true
    end

    respond_to do |format|
      if @post.save
        format.html { redirect_to admin_posts_path, notice: t('forms.messages.success') }
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
        if @post.published?
          @post.published_at = Time.now
          @post.save
        else
          @post.published_at = nil
          @post.save
        end
        format.html { redirect_to admin_posts_path, notice: t('forms.messages.success') }
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

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :user_type)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :published, :image, :arabic)
  end

  def check_user
    if current_user.present?
      if current_user.user_type == "superAdmin" || current_user.user_type == "admin" || current_user.user_type == "manager"
      else
        redirect_to root_path, notice: "Access Denied!"
      end
    end
  end

  def check_user_super
    if current_user.present?
      if current_user.user_type == "superAdmin"
      else
        redirect_to root_path, notice: "Access Denied!"
      end
    end
  end
end
```

### Localization

Localization is implemented using I18n for multi-language support.

```yaml name=config/locales/en.yml
en:
  activerecord:
    attributes:
      article:
        title: "Title"
        body: "Body"
  forms:
    messages:
      success: "Operation succeeded!"
    buttons:
      edit: "Edit"
      submit: "Submit"
  menu:
    new_article: "Add an article"
  articles:
    index:
      title: "List of articles"
    edit:
      title: "Add article"
    new:
      title: "New article"
    languages:
      lang: "Language"
      fr: "Français"
      en: "English"
      ar: "العربية"
```
---

## Contributing 🤝

Contributions are welcome! Here's how to get started:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Open a pull request

---

## License 📄

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

Developed by [Saqib Sohail](mailto:sohail.cpp@gmail.com)  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?logo=linkedin)](https://linkedin.com/in/saqibroy)  
[![GitHub](https://img.shields.io/badge/GitHub-View-green?logo=github)](https://github.com/saqibroy)
