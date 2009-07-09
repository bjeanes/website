class PostsController < ApplicationController
  def index
    @tag = params[:tag]
    @posts = Post.find_recent(:tag => @tag, :include => :tags)

    raise(ActiveRecord::RecordNotFound) if @tag && @posts.empty?

    respond_to do |format|
      format.html
      format.atom do
        if params[:feedburner] == 'true'
          render :layout => false
        else
          headers["Status"] = "301 Moved Permanently"
          redirect_to 'http://feeds.feedburner.com/begenius'
        end
      end
    end
  end

  def show
    @post = Post.find_by_permalink(*([:year, :month, :day, :slug].collect {|x| params[x] } << {:include => [:approved_comments, :tags]}))
    @comment = Comment.new
  end
end
