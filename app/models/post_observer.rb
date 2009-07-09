class PostObserver < ActiveRecord::Observer
  def after_save(post)
    begin
      open("http://feedburner.google.com/fb/a/pingSubmit?bloglink=#{CGI.escape(Enki::Config.default[:url].to_s)}")
    rescue
      RAILS_DEFAULT_LOGGER.debug("Could not ping feedburner")
    end
  end
end