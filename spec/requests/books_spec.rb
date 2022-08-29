require 'rails_helper'

RSpec.describe "book API", type: :request do
    it "index page returns books" do
        FactoryBot.create(:book, title: "Interesting book", author: "Smart man")
        FactoryBot.create(:book, title: "Boring book", author: "Wise man")

        get '/api/v1/books'
        
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).size).to eq(2)
    end
end