class UserDatasController < ApplicationController
  layout 'base' ,:except=>[:graph_code]
  # GET /user_datas
  # GET /user_datas.xml
  include AuthenticatedSystem
  before_filter :login_required ,:except=>[:new,:create,:activate]
  before_filter :get_data ,:only=>[:edit,:destroy,:update,:show,:graph_code]
  before_filter :get_type
  before_filter :menu_setup
  
  def menu_setup
    @menu_selected = 'measure_datas'
  end
  
  def get_data
    @user_data = current_user.measure_datas.find(params[:id]) rescue nil
    redirect_back_or('/') if !@user_data
  end
  
  def get_type
    @measure_type = params[:type].classify if params[:type]
  end
  
  def index
    @content_title = "Listing #{@measure_type} data " if MeasureData::ALLOW_TYPE.include?(@measure_type)
    # change find method later
    @user_datas = current_user.measure_datas.paginate(:all,:conditions=>{:ruby_type=>@measure_type},:page=>params[:page],:order=>"measured_at DESC")
    if MeasureData::OFC_GRAPH_MULTILPE_TYPE.include?(@measure_type)
        @graph = open_flash_chart_object(700,400,"/user_datas/trend_graph_code?measure_type=#{@measure_type}")
    end
  end

  # GET /user_datas/1
  def show
    @graph = open_flash_chart_object(700,400,"/user_datas/graph_code/#{params[:id]}}",true,'/','open-flash-chart3.swf')  if @user_data.datas[:values]
  end

  # GET /user_datas/new
  # GET /user_datas/new.xml
  def new
    @measure_type=params[:measure_type]
    if !@measure_type
      flash[:error] = '沒有量測形態'
      redirect_to :back 
      return false
    end
    @user_data = MeasureData.new
    
  end

  # GET /user_datas/1/edit
  def edit
   # @data = current.find(params[:id])
  end

  # POST /user_datas
  # POST /user_datas.xml
  def create
    @user_data=current_user.create_measure_data(params[:measure_type],params[:measure_data])
    #@data = MeasureData.new(params[:measure_data])
    respond_to do |format|
      if @user_data.save
        flash[:notice] = 'UserData was successfully created.'
        format.html { redirect_to(@user_data) }
        format.xml  { render :xml => @user_data, :status => :created, :location => @user_data }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_data.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user_datas/1
  # PUT /user_datas/1.xml
  def update
    respond_to do |format|
      if @user_data.update_attributes(params[:user_data])
        flash[:notice] = 'UserData was successfully updated.'
        format.html { redirect_to user_data_path(current_user,@user_data) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user_data.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_datas/1
  # DELETE /user_datas/1.xml
  def destroy
    @user_data.destroy
    redirect_to user_datas_path(:type=>@user_data.class.to_s.downcase)
  end
  
  def trend_graph_code
      chart= eval("#{params[:measure_type]}.ofc_code(current_user)")
      render :text =>chart 
  end
  
  def graph_code
    chart = @user_data.ofc_code
    render :text => chart
  end

end
