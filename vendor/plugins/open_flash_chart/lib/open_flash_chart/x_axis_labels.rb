module OpenFlashChart

  class XAxisLabels < Base
    def set_vertical
      @rotate = 270
    end
    def rotate(angle)
      @rotate = angle
    end
  end

end
