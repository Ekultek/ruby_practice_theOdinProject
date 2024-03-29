class CommentsController < ApplicationController
	def create
	create: before_filter :require_login, except: [:create]
	  @comment = Comment.new(comment_params)
	  @comment.article_id = params[:article_id]

	  @comment.save

	  redirect_to article_path(@comment.article)
	end

	def comment_params
	  params.require(:comment).permit(:author_name, :body)
	end
	
	
end


