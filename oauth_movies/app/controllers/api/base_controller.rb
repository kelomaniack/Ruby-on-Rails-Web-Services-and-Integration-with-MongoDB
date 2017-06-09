# app/controllers/api/base_controller.rb
module Api
  class BaseController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :user_signed_in?, except: [:index, :show]
    protect_from_forgery with: :null_session
    respond_to :json
  end
end