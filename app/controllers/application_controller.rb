class ApplicationController < ActionController::Base
  before_filter :getgalery
  before_action :set_locale
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def after_sign_out_path_for(resource_or_scope)
    admin_path
  end

  def getgalery
    @images = Image.all
    @posts = Post.all
  end

  private

  def set_locale
    if cookies[:educator_locale] && I18n.available_locales.include?(cookies[:educator_locale].to_sym)
      @l = cookies[:educator_locale].to_sym
    else
      begin
        country_code = request.location.country_code
        if country_code
          country_code = country_code.downcase.to_sym
          # use russian for CIS countries, english for others
          [:ar, :kz, :ua, :by, :tj, :uz, :md, :az, :am, :kg, :tm].include?(country_code) ? @l = :fr : @l = :ar
        else
          @l = I18n.default_locale # use default locale if cannot retrieve this info
        end
      rescue
        @l = I18n.default_locale
      ensure
        cookies.permanent[:educator_locale] = @l
      end
    end
    I18n.locale = @l
  end
end
