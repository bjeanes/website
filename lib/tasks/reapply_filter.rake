desc "Re-apply code/textile filters to all posts and comments"
task :reapply_filter => :environment do
  Post.all.each do |post|
    post.apply_filter
    post.save
  end
  
  Comment.all.each do |comment|
    comment.apply_filter
    comment.save
  end
end