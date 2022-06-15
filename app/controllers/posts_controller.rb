class PostsController < ApplicationController
    def index
        @posts = Post.all
    end

    def search
        @post = Post.where(title: params[:query])
    end

end
