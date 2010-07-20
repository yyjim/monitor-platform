class BloodPressure < MeasureData
  
  def before_create
    super
  end
  
  def self.build_data
    b= BuildData.new()
    data = {:systolic=>rand(30)+100,
    :diastolic=>rand(30)+60,
    :pulse=>rand(30)+50}
    b.create('blood_pressure',data)
  end
  
  def self.ofc_code(user)
    data = user.blood_pressures
    title = Title.new("Blood Pressure Curve")
    systolic_pressures = data.collect{|d| d.datas[:systolic].to_i}
    diastolic_pressures = data.collect{|d| d.datas[:diastolic].to_i}
    pulses=data.collect{|d| d.datas[:pulse].to_i}
   # if (!data1.blank? && data1.is_a?(Array))
#    average = MeasureData.average_line(data1)

   # line = ScatterLine.new("#DB1750", 3)
   # line.values = data1
   # line.default_dot_style = dot

    systolic_line_dot = LineDot.new
    systolic_line_dot.text = "systolic"
    systolic_line_dot.width = 2
    systolic_line_dot.colour = '#00ff00'
    systolic_line_dot.dot_size = 3
    systolic_line_dot.values = systolic_pressures
    
    diastolic_line_dot = LineDot.new
    diastolic_line_dot.text = "diastolic"
    diastolic_line_dot.width = 2
    diastolic_line_dot.colour = '#ff0000'
    diastolic_line_dot.dot_size = 3
    diastolic_line_dot.values = diastolic_pressures
    
    pulse_line_dot = LineDot.new
    pulse_line_dot.text = "pulse"
    pulse_line_dot.width = 2
    pulse_line_dot.colour = '#453300'
    pulse_line_dot.dot_size = 3
    pulse_line_dot.values = pulses

    y = YAxis.new
    y_max = systolic_pressures.max > 130 ? systolic_pressures.max+20 : 150
    y.set_range(0,y_max,10)
    y_labels_txt=[]
    # 210.times do |t|
    #   if t%10 ==0
    #    y_labels_txt <<  (t==100 ?  average.to_s : (t < 100 ? "-#{100-t*1}"  : "+#{(t-100)}"))
    #   else
    #     y_labels_txt << ""
    #   end
    # end
    
   # y.labels = { :labels => y_labels_txt,:steps=>1}
    x_labels_txt=[]
      # data1.count.times do |t|
      #     x_labels_txt << (t%10 ==0 ? t.to_s : "") 
      #  end
      data.each{|d|
        x_labels_txt << d.created_at.strftime("%Y/%m/%d")
      }
    #---------------------
    tmp = []
    x_labels = XAxisLabels.new
    x_labels.rotate(45)
    x_labels.labels = x_labels_txt
   #-----------------------
    x= XAxis.new
    x.set_steps(1)
    x.set_labels(x_labels)
    x_legend = XLegend.new("date")
    x_legend.set_style('{font-size: 20px; color: #778877}')

    y_legend = YLegend.new("value")
    y_legend.set_style('{font-size: 20px; color: #770077}')

    chart =OpenFlashChart.new
    chart.set_title(title)
    chart.x_axis = x
    chart.y_axis = y
    chart.set_x_legend(x_legend)
    chart.set_y_legend(y_legend)
    
    chart.set_bg_colour('#FFFFFF')
    chart.add_element(systolic_line_dot)
    chart.add_element(diastolic_line_dot)
    chart.add_element(pulse_line_dot)
    return chart.to_s
  end
end