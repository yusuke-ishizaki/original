class TagsController < ApplicationController
    def create
        @tag = Tag.create(name: params[:name])
    end
    def new
        @tag = Tag.new
    end
    def index
        @tags = []
        Tag.order("name ASC").each do |tag|
          i = 0
          @tags.each do |t|
            if tag.name != t.name
              i += 1
            end
          end
          if i == @tags.length
            @tags << tag
          end
        end
      end
    
      def show
        @tag = Tag.find(params[:id])
        @posts = []
        Post.all.each do |post|
          post.tags.each do |tag|
            if tag.name == @tag.name
              @posts << post
              break
            end
          end
        end
      end
end
