class Display
  def show
    rows.times.each do |i|
      puts row_text(i)
    end
  end
end
