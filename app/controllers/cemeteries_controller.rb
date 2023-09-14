class CemeteriesController < ApplicationController
  def index
  end
  
  def show
    @cemetery = Cemetery.find_by(id: params[:id])
  end
end
