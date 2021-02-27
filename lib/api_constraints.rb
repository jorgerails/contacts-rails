module ApiConstraints
  def self.matches?(request)
    request.accept == "application/vnd.contacts+json"
  end
end
