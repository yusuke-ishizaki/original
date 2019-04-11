class TagsController < ApplicationController
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
      @tags = Tag.find(params[:id])
      @posts = []
      Post.all.each do |post|
        post.tags.each do |tag|
          if tag.name == @tags.name
            @posts << post
            break
          end
        end
      end
    end

    def create
        @tags = Tag.create(params[:name])
  end