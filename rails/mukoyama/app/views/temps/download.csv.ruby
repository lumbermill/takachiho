require 'csv'
CSV.generate do |csv|
	csv << @data[0].attributes.keys
  @data.each do |model|
    csv << model.attributes.values
  end
end
