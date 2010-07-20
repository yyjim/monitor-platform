class WelcomeController < ApplicationController
  layout 'base'
  include AuthenticatedSystem
  
  before_filter :menu_setup
  
  def menu_setup
    @menu_selected = 'home'
  end
  
  def index 
    @user= User.new
  end

  def login 
  end
end
