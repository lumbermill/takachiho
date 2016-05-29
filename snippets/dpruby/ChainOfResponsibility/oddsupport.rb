class OddSupport < Support
  def resolve(trouble)
    trouble.number % 2 == 1
  end
end
