class MembersController < ApplicationController

  def show
    @profile = User.find(1)
  end
  
  def index
  
  end
  
  
  
  end