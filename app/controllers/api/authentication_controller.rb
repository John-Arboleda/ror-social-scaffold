class Api::Users::Posts::CommentsController < ApiApplicationController
	include Response

	before_action :set_user, only: [:create]
	before_action :set_article, only: [:index, :create]

	def index
		json_response(@post.comments)
	end

	def create
		@comment = Comment.new(create_params)
		@comment.user = current_user
		@comment.post = @post
		if @comment.save
			json_response({ data: "Comment was saved successfully!" }, 201)
		else
			json_response("Sorry, something went wrong!")
		end
	end

	private

	def create_params
		params.require(:comment).permit(:content)
	end

	def set_user
    @user = User.find(params[:user_id])
  end

  def set_article
    @post = Post.find(params[:post_id])
  end
end