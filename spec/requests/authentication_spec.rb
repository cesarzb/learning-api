require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
    describe 'POST /authenticate' do
        it 'authenticates the client' do
            post '/api/v1/authenticate', params: { username: 'User321', password: 'password'}

            expect(response).to have_http_status(:created)
            expect(response.body).to eq(
                { 'token': '123' }.to_json
            )
        end
        
        it 'returns error when username is missing' do
            post '/api/v1/authenticate', params: { password: 'password' }
            
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.body).to eq(
                { 'error': 'param is missing or the value is empty: username' }.to_json
                )
        end
            
        it 'returns error when password is missing' do
            post '/api/v1/authenticate', params: { username: 'User321' }
            
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.body).to eq(
                { 'error': 'param is missing or the value is empty: password' }.to_json
                )
        end
    end
end