class TagsController < ApplicationController
    def create
        @tag = Tag.create(name: params[:name])
    end
    def new
        @tag = Tag.new
    end
    
end
