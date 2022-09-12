require 'rails_helper'

RSpec.describe Api::V1::BooksController, type: :controller do
    describe 'GET action' do
        it 'has a max limit of 100' do
            expect(Book).to receive(:limit).with(100).and_call_original
    
            get :index, params: { limit: 999 }            
        end
    end

    describe 'POST action' do
        let!(:book_name) { 'Some book' }
        
        it 'calls UpdateSkuJob while creating book' do
            expect(UpdateSkuJob).to receive(:perform_later).with(book_name)

            post :create, params: {
                author: { first_name: 'Foo', last_name: 'Bar', age: 34 },
                book: { title: book_name }
            }
        end
    end
end