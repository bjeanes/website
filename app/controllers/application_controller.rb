# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable

  before_filter :ensure_domain
  after_filter :set_content_type

  helper :all
  tab :home

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #  protect_from_forgery :secret => 'a6a9e417376364b61645d469f04ac8cf'

  protected

  def config
    @@config = Enki::Config.default
  end
  helper_method :config

  def set_content_type
    headers['Content-Type'] ||= 'application/xhtml+xml; charset=utf-8'
  end

  def ensure_domain
    return unless Rails.env.production?
    
    domain = "bjeanes.com"
    if request.env['HTTP_HOST'] != domain
      redirect_to "http://#{domain}"
    end
  end
end
