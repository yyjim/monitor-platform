module UserDatasHelper
  
  def show_data(data)
    image_tag data.draw_line_chart
  end
end
