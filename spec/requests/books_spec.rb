require 'rails_helper'

RSpec.describe 'book API', type: :request do
    describe 'GET /books' do
        before do
            author = FactoryBot.create(:author)
            FactoryBot.create(:book, author: author)
            FactoryBot.create(:book, author: author)
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
                book_params = FactoryBot.attributes_for(:book)
                author_params = FactoryBot.attributes_for(:author)
                
                post '/api/v1/books', params: { book: book_params, author: author_params }     
            }.to change { Book.count }.from(0).to(1)
            expect(response).to have_http_status(:created)
        end
    end

    describe 'DELETE /books/:id' do
        let!(:author) { FactoryBot.create(:author) }
        let!(:book)   { FactoryBot.create(:book, author: author) }
        it 'deletes a book' do
            expect{
                delete "/api/v1/books/#{book.id}"
            }.to change { Book.count }.from(1).to(0)
            expect(response).to have_http_status(:no_content)
        end
    end
end