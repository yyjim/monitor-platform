require 'google_chart'
class MeasureData < ActiveRecord::Base
  set_inheritance_column :ruby_type
  ALLOW_TYPE=['Qcm','Weight','BloodPressure','BloodSugar']
  
  OFC_GRAPH_SINGLE_TYPE =['QCM']
  OFC_GRAPH_MULTILPE_TYPE = ['Weight','BloodPressure','BloodSugar']
  
  belongs_to :user
  serialize :datas
  #validate :type_check, :in => ALLOW_TYPE, :message => "data type {{value}} is not included in the list" 
  
  def before_save
    self.datas = {} if !self.datas
    self.datas.each{|k,v|
      if v =~ /^(\d+\.\d+,\d+\.\d+|,\d+\.\d+|\d+,\d+|,\d+)+$\d*/
        self.datas[k] = v.split(',').collect!{|d| d.to_f }
      end
    }
  end
  
  def tt
    if self.datas[:values].is_a? Array
      self.datas[:values] = self.datas[:values].collect!{|q| q.to_f}
      self.save
    end
  end
  
  def self.per_page
    10
  end
  
  def before_create
    self.measured_at = Time.now if !self.measured_at
  end
  
  def get_attr(name)
    self.datas[name] rescue nil
  end
  
  def set_attr(name,value)
    self.datas[name]=value
    self.save
  end
  
  def values
    return self.datas[:values].split(',') if self.datas[:values]
  end
  
  def to_xml_format(comment=nil)
    doc = Builder::XmlMarkup.new( :target => out_string = "", :indent => 2 ) 
    doc.comment!(comment) if comment
    doc.MeasureData(:id=>self.id,:type=>(self.class.to_s ? self.class.to_s : "unknown"),
                     :measured_at=> (self.measured_at.strftime("%Y/%m/%d %H%:%M:%S") rescue "unknown"),
                    :created_at=> (self.created_at.strftime("%Y/%m/%d %H%:%M:%S") rescue "unknown" )){ 
      doc.Data{
        self.datas.each{|k,v|
          eval("doc.#{k} v")
        }
      }
    }
    return out_string 
  end
  
  def self.define_google_chart_canvas(datas=[])
    if datas.count > 500
      tmp_datas = []
      0.upto(datas.count-1).each{|i|
        tmp_datas << (datas[i]+datas[i+1])/2
      }
    end
    
    data_size = data_size.to_f
    maximun_width = 1000.0
    maximun_height = 300.0
    if data_size*2.5 < maximun_width
      canvas_width = 2.5*data_size
    end
    if max_y - min_y < 30
    end
  end
  
  def draw_google_line_chart
    x_axis_labels = (1..31).to_a.collect do |v|    
      if [1,6,25,26,31].member?(v)
        if v == 1
          "Dec 1st"
        elsif v == 31
          "Dec 31st"
        elsif v 
          "#{v}th" 
        end    
      else
        nil
      end  
    end 

    y_axis_labels = (0..10).to_a.collect do |v|
      val = 10 * v
      if val ==50 or val == 100
        val.to_s
      else
        nil
      end
    end

    series_1_y = [30,45,20,50,15,80,60,70,40,55,80]
    series_2_y = [50,10,30,55,60]

    series_1_x = [1,6,8,10,18,23,25,26,28,29,31]
    series_2_x = [1,4,6,9,11]

    series_1_xy = []
    series_2_xy = []

    series_1_x.each_with_index do |v,i|
      series_1_xy[i] = [v-1, series_1_y[i] ]
    end

    series_2_x.each_with_index do |v,i|
      series_2_xy[i] = [v-1, series_2_y[i ] ]
    end

    lcxy = GoogleChart::LineChart.new('600x480', "Projected Christmas Cheer for 2007", true)
    lcxy.data "2006", series_1_xy, '458B00'
    lcxy.data "2007", series_2_xy, 'CD2626'
    lcxy.max_value [30,100]
    lcxy.data_encoding = :simple
    lcxy.axis :x, :labels => x_axis_labels
    lcxy.axis :y, :labels => y_axis_labels
    lcxy.grid :x_step => 3.333, :y_step => 10, :length_segment => 1, :length_blank => 3
    return lcxy.to_url
  end
  
  def self.average_line(datas)
      near_datas=[]
      datas.uniq.each{|x|
        near_datas << x if datas.count(x) >= 5
      }
      average = [near_datas.first]
      near_datas.each{|x|
        average[0] = x if datas.count(x) > datas.count(average[0])
        average << x if datas.count(x) == datas.count(average[0]) && average[0] != x
      }
      return average.mean.to_i
  end
  
  def ofc_code
    title = Title.new("#{self.class.to_s.upcase} Curve")
    data1=self.datas[:values]
    if (!data1.blank? && data1.is_a?(Array))
    data1.collect!{|d| d.to_f}
    average = MeasureData.average_line(data1)

    line_dot = Line.new
    line_dot.text = "Line"
    line_dot.width = 2
    line_dot.colour = '#458B00'
    #line_dot.dot_size = 0.2
    line_dot.values = data1
   
    y = YAxis.new
    y.set_range(average-100,average+100,10)
    y_labels_txt=[]
    210.times do |t|
      if t%10 ==0
       y_labels_txt <<  (t==100 ?  average.to_s : (t < 100 ? "-#{100-t*1}"  : "+#{(t-100)}"))
      else
        y_labels_txt << ""
      end
    end
    y.labels = { :labels => y_labels_txt,:steps=>1}
    x_labels_txt=[]
    data1.count.times do |t|
       x_labels_txt << (t%10 ==0 ? t.to_s : "") 
    end
    #---------------------
    tmp = []
    x_labels = XAxisLabels.new
    x_labels.set_vertical()
    x_labels.labels = x_labels_txt
   #-----------------------
    x= XAxis.new
    x.set_steps(10)
    x.set_labels(x_labels)
    x_legend = XLegend.new("Data")
    x_legend.set_style('{font-size: 20px; color: #778877}')

    y_legend = YLegend.new("Count")
    y_legend.set_style('{font-size: 20px; color: #770077}')

    chart =OpenFlashChart.new
    chart.set_title(title)
    chart.x_axis = x
    chart.y_axis = y
    chart.set_x_legend(x_legend)
    chart.set_y_legend(y_legend)
    
    chart.set_bg_colour('#FFFFFF')

    chart.add_element(line_dot)
    return chart.to_s
    end
  end
end
