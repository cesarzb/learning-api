require 'rails_helper'

RSpec.describe 'book API', type: :request do
    describe 'GET /books' do
        before do
            FactoryBot.create(:book)
            FactoryBot.create(:book)
        end
        it 'returns all books' do

            get '/api/v1/books'
            
            expect(response).to have_http_status(:success)
            expect(JSON.parse(response.body).size).to eq(2)
        end
    end

    describe 'POST /books' do
        it 'creates a book' do
            expect{ 
                post '/api/v1/books', params: { book: FactoryBot.attributes_for(:book) }     
            }.to change { Book.count }.from(0).to(1)
            
            expect(response).to have_http_status(:created)
        end
    end

    describe 'DELETE /books/:id' do
        let!(:book) { FactoryBot.create(:book) }
        it 'deletes a book' do
            expect{
                delete "/api/v1/books/#{book.id}"
            }.to change { Book.count }.from(1).to(0)
            expect(response).to have_http_status(:no_content)
        end
    end
end