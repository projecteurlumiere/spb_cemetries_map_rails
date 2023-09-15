class CemeteriesController < ApplicationController
  def index
  end
  
  def show
    @cemetery = Cemetery.find_by(id: params[:id])
    @photos = Photo.where(cemetery_id: @cemetery.id)
  end
end
