class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  def set_locale
    I18n.locale = locale_in_user || I18n.default_locale
  end

  def locale_in_user
    if current_user.present?
      current_user.locale
    else
      nil
    end
  end

end
