class GraphObserver
  def update(generator)
    print "GraphObserver: "
    generator.number.times do
      print "*"
    end
    print "\n"
    sleep 0.1
  end
end
