require 'rails_helper'

RSpec.describe 'Book API', type: :request do
    let(:author)   { FactoryBot.create(:author) }


    describe 'GET /books' do    
        let!(:book)         { FactoryBot.create(:book, author: author) }
        let!(:other_book)   { FactoryBot.create(:book, author: author) }
        
        it 'returns all books' do
            get '/api/v1/books'
            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(2)
            expect(response_body).to eq(
                [
                    {
                    'id' => book.id,
                    'title' => "#{book.title}",
                    'author_name' => "#{author.first_name} #{author.last_name}",
                    'author_age' => author.age,
                    },
                    {
                    'id' => other_book.id,
                    'title' => "#{other_book.title}",
                    'author_name' => "#{author.first_name} #{author.last_name}",
                    'author_age' => author.age,
                    }
                ]
            )
        end

        it 'returns subset of books with limit' do
            get '/api/v1/books', params: { limit: 1 }
            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(1)
            expect(response_body).to eq(
                [    
                    {
                        'id' => book.id,
                        'title' => "#{book.title}",
                        'author_name' => "#{author.first_name} #{author.last_name}",
                        'author_age' => author.age                    
                    }
                ]
            )
        end

        it 'returns subset of books with limit and offset' do
            get '/api/v1/books', params: { limit: 1, offset: 1 }
            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(1)
            expect(response_body).to eq(
                [
                    {
                        'id' => other_book.id,
                        'title' => "#{other_book.title}",
                        'author_name' => "#{author.first_name} #{author.last_name}",
                        'author_age' => author.age
                    }
                ]
            )
        end
    end

    describe 'POST /books' do
        let!(:user) { FactoryBot.create(:user, username: "BookSeller99", password: "password") }
        
        it 'creates a book' do
            book_params = FactoryBot.attributes_for(:book)
            author_params = FactoryBot.attributes_for(:author)
 
            expect{
                post '/api/v1/books', params: { 
                    book: book_params, 
                    author: author_params 
                }, headers: { "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxfQ.LsDBc77pnaGAayIYeTv98TEjixb-9X-cY3hchoPshpQ" }
            }.to change { Book.count }.from(0).to(1)
            expect(response).to have_http_status(:created)
            expect(response_body).to eq(
                {
                    'id' => 1,
                    'title' => "#{book_params[:title]}",
                    'author_name' => "#{author_params[:first_name]} #{author_params[:last_name]}",
                    'author_age' => author_params[:age]
                }
            )
        end
    end

    describe 'DELETE /books/:id' do
        let!(:book)     { FactoryBot.create(:book, author: author) }
        let!(:user)     { FactoryBot.create(:user, username: "BookSeller99", password: "password") }

        it 'deletes a book' do
            expect{
                delete "/api/v1/books/#{book.id}",
                headers: { "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxfQ.LsDBc77pnaGAayIYeTv98TEjixb-9X-cY3hchoPshpQ" }
            }.to change { Book.count }.from(1).to(0) 
            expect(response).to have_http_status(:no_content)
        end
    end
end