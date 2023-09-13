class CemeteriesController < ApplicationController
  def index
    @cemeteries = Cemetery.all
  end
  
  def show
    @cemetery = Cemetery.find_by(id: params[:id])
    render partial: 'show'
  end
end
