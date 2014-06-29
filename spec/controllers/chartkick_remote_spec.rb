require 'spec_helper'
require 'chartkick_remote'


AnonymousRoutes = ActionDispatch::Routing::RouteSet.new.tap do |routes|
  routes.draw { resources :anonymous }
end

describe Chartkick::Remote, type: :controller do
  render_views

  controller ActionController::Base do
    include Chartkick::Remote
    chartkick_remote

    prepend_view_path 'spec/controllers/views'

    include AnonymousRoutes.url_helpers
    helper AnonymousRoutes.url_helpers

    def index
    end
  end

  describe "GET" do
    routes { AnonymousRoutes }

    it "generates a remote data source" do
      get :index, format: :html
      expect(response.body).to include '_chartkick_remote_chart_id=1'
    end

    it "returns the remote data source as json" do
      get :index, _chartkick_remote_chart_id: 1, format: :json
      expect(JSON.parse(response.body)).to eq [0,1]
    end
  end
end
