class WelcomesController < ApplicationController
  def home
  	if @l == :fr
  	@new_posts=Post.all.where(arabic: false).limit(3).order('created_at DESC')
  	@ran_posts = Post.all.where(arabic: false).order("RANDOM()").limit(3)
  else
    @new_posts=Post.all.where(arabic: true).limit(3).order('created_at DESC')
    @ran_posts = Post.all.where(arabic: true).order("RANDOM()").limit(3)
  end
  
  end

  def contact

  end
end
