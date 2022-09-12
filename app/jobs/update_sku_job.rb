require 'net/http'

class UpdateSkuJob < ApplicationJob
  queue_as :default

  def perform(book_name)
    uri = URI('http://localhost:3005/api/v1/sit')
    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    req.body = {sku: '123', name: book_name}.to_json
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end  
  end
end
