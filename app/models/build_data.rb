require 'mechanize'
class BuildData
  
  def initialize
    @path = "http://localhost:3006/api/datas"
    @api_key =User.first.api_key
  end
  
  def create(type,datas={})
     agent = Mechanize.new
     params = {
       :api_key => @api_key,
       "datas[type]"=>type
     }
     datas.each{|k,v|
      params["datas[datas][#{k}]"] = v
     }
     agent.post(@path,params)
     data = agent.current_page.body
     return data
  end  
  # "http://140.124.71.148:3006/api/data?api_key=459a53aa1577e7b9586962b016ee56a08719ebdd&datas[type]=Qcm&datas[datas][values]=#{value}&datas[source]=gateway"
  #   datas[Qcm]=type
  #   datas[Qcm][values]=values
  #   datas[source]=gateway
end

