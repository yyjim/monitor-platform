class Api::DatasController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  include AuthenticatedSystem
  before_filter :login_from_api_key
  before_filter :check_login
  before_filter :get_data ,:only=>[:show,:destroy,:edit]


  def index
  end

  def create
      type = params[:datas][:type].downcase.pluralize
      begin 
      @data = current_user.create_measure_data(type,params[:datas].delete_if{|k,v| k=='type'}) 
      rescue 
             render :text=>'data type is wrong!!'
             return false
      end
      render :xml=> @data.save ? @data.to_xml_format('data was successfully created') : 'data attributes has some errors'
  end

  def show
      render :xml=> @data.to_xml_format()
  end

  def destroy
      render :text=> "Data was successfully deleted" if @data.destroy
  end

  def check_login
    return if logged_in?
    render :text=>'authorize failed'
  end
  
  def get_data
    @data = current_user.measure_datas.find(params[:id]) rescue nil
    return @data if @data
    render :text=>"This data does not exist!"
    return false
  end

end
