class Qcm < MeasureData
  
  
  # spacial function 
  # data come from gateway !!
  def before_create
    if self.datas[:source] =='gateway'
      puts "before:" + datas[:values].size.to_s
      self.datas[:values] = Qcm.parse_data(self.datas[:values])
      puts "after:" + datas[:values].size.to_s
    end
    super
  end
    
  def self.parse_data(data)
    rexg = /AA,(([a-f0-9A-F]{2},){4})FE/
    if data
      results = data.scan(rexg) 
      puts "parse cnt:"+results.size.to_s
      new_data=[]
      i=1
      results.each{|result|
        puts i
        i+=1
        puts result[0]+"\n"
        new_data << result[0].split(',').join().hex rescue next
      }
      puts new_data.inspect
      return new_data.join(',')
    end
  end
    
  def self.radom_data
    datas = []
    (1000).times do |i|
        datas << 100 + rand(500)
    end
    return datas
  end
  
  def self.demo_data(num=1)
    datas=File.open("#{RAILS_ROOT}/public/test_datas/qcm#{num}.txt").read.split("\n")
    datas.map!{|x| x.to_f}
    return datas
  end
  
  def draw_line_chart
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
    #p x_axis_labels
    datas = Qcm.demo_data
    data_size = datas.count
    #canvas_width, canvas_height = MeasureData.define_canvas_size(datas.count)
    #min_y ,max_y = datas.minmax
    average = datas.mean.to_i
    y_axis_labels = (-10..10).to_a.collect do |v|
      if v == 0
        average
      else
        val = 10 * v
        if val % 10==0
        #if val ==50 or val == 100
          v > 0 ? "+#{val.to_s}" : val.to_s
        else
          nil
        end
      end
    end
     #self.get_attr(:values).split(',').collect!{|x| x.to_f}
    
    series_1_y =  datas
    #series_2_y = [50,10,30,55,60]

    series_1_x = (0..datas.count-1).to_a
    #series_2_x = [1,4,6,9,11]

    series_1_xy = []
    series_2_xy = []

    series_1_x.each_with_index do |v,i|
      series_1_xy[i] = [v-1, series_1_y[i] ]
    end
    p series_1_xy
    # series_2_x.each_with_index do |v,i|
    #   series_2_xy[i] = [v-1, series_2_y[i ] ]
    # end
    #p series_2_xy
    lcxy = GoogleChart::LineChart.new('1000x300', "Projected Christmas Cheer for 2007", true)
    lcxy.data "2006", series_1_xy, '458B00'
    #lcxy.data "2007", series_2_xy, 'CD2626'
    lcxy.max_value [500,60]
    lcxy.data_encoding = :simple
    lcxy.axis :x, :labels => x_axis_labels
    lcxy.axis :y, :labels => y_axis_labels
    lcxy.grid :x_step => 3.333, :y_step => 10, :length_segment => 1, :length_blank => 3
    # lc = GoogleChart::LineChart.new('320x200', "Line Chart", false)
    # datas = self.get_attr(:values).split(',').collect!{|x| x.to_f}
    # #datas.collect! {|x| x.to_f } 
    # #lc.max_value [0,10]
    # lc.data "Trend 1", datas, '0000ff'
    # lc.axis :y, :range => [0,10], :color => 'ff00ff', :font_size => 16, :alignment => :center
    # lc.axis :x, :range => [0,datas.size], :color => '00ffff', :font_size => 16, :alignment => :center
     return lcxy.to_url
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
    x_legend = XLegend.new("time / 3s")
    x_legend.set_style('{font-size: 20px; color: #778877}')

    y_legend = YLegend.new("output count")
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
