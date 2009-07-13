class ArchivesController < ApplicationController
  tab :archives
  
  def index
    @months = Post.find_all_grouped_by_month
  end
end
