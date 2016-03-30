class WelcomesController < ApplicationController
  def home
  	
  	@new_posts=Post.all.where( published: true).limit(3).order('created_at DESC')
  	@ran_posts = Post.all.where( published: true).order("RANDOM()").limit(3)
  
   
  
  
  end

  def contact

  end
end
