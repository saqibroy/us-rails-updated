class WelcomesController < ApplicationController
  def home
  	if @l == :fr
  	@new_posts=Post.all.where(arabic: false, published: true).limit(3).order('created_at DESC')
  	@ran_posts = Post.all.where(arabic: false, published: true).order("RANDOM()").limit(3)
  else
    @new_posts=Post.all.where(arabic: true,published: true).limit(3).order('created_at DESC')
    @ran_posts = Post.all.where(arabic: true,published: true).order("RANDOM()").limit(3)
  end
  
  end

  def contact

  end
end
