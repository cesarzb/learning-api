class GreetingJob < ApplicationJob
  queue_as :default

  def perform(*args)
    uri = URI('http://localhost:3005/api/v1/sit')
    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Get.new uri
    
      response = http.request request
    end  
  end
end
