require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'POST #register' do
    let :user do
      password = Faker::Internet.password
      {
        username: Faker::Internet.username,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        password: password,
        password_confirmation: password
      }
    end

    let :user_params do
      { user: user }
    end

    context 'when request is valid' do
      before { post :register, params: user_params }

      it 'should return 201' do
        expect(response).to have_http_status(:created)
      end

      it 'should register user' do
        expect(json['username']).to eq user[:username]
        expect(json['first_name']).to eq user[:first_name]
        expect(json['last_name']).to eq user[:last_name]
      end

      it 'should not contain password' do
        expect(json['password']).to be_nil
        expect(json['password_confirmation']).to be_nil
        expect(json['password_digest']).to be_nil
      end
    end
  end
end
