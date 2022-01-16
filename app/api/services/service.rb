class Service

  def initialize
    @responses = {}
  end


  private

  def get_url(url)
    if @responses[url].nil? # If a request has not been sent to a url yet, send a request and save the response
      raw_response = Faraday.get(url)

      @responses[url] = JSON.parse(raw_response.body)
    else # If a request has been sent to a url already, re-use the response it got back from a previous request
      @responses[url]
    end
  end

end
