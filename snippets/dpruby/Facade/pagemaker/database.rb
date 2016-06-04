require 'json'

class Database
  def self.properties(name)
    filename = name + ".json"
    JSON.load(open(filename))
  end
end
