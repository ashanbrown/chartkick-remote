require 'spec_helper'
require 'chartkick/remote'

AnonymousRoutes = ActionDispatch::Routing::RouteSet.new.tap do |routes|
  routes.draw { resources :anonymous }
end

describe Chartkick::Remote, type: :controller do
  render_views

  AnonymousController = Class.new(ActionController::Base) do
    include Chartkick::Remote

    prepend_view_path 'spec/controllers/views'

    include AnonymousRoutes.url_helpers
    helper AnonymousRoutes.url_helpers

    def index
    end
  end

  controller AnonymousController do
    chartkick_remote
  end

  describe "GET" do
    routes { AnonymousRoutes }

    it "generates a remote data source" do
      get :index, format: :html
      expect(response.body).to include '_chartkick_remote_chart_id=1'
    end

    it "returns the remote data source as json" do
      get :index, _chartkick_remote_chart_id: 1, format: :json
      expect(JSON.parse(response.body)).to eq [[0,1]]
    end

    describe "when the standalone option is set" do
      controller AnonymousController do
        chartkick_remote standalone: true
      end

      it "shows a link to enter standalone mode" do
        get :index, format: :html

        expect(response.body).to have_tag :a, { text: 'Standalone', href: '/anonymous.html?_chartkick_remote' }
      end

      it "does not show any other charts but the selected chart" do
        get :index, _chartkick_remote_chart_id: 1, _chartkick_remote_standalone: 1, format: :html

        expect(response.body).to have_tag :a, { text: 'Exit Standalone Mode', href: '/anonymous.html' }
      end

      it "shows a link to exit standalone mode" do
        get :index, _chartkick_remote_chart_id: 1, _chartkick_remote_standalone: 1, format: :html

        expect(response.body).to have_tag :a, { text: 'Exit Standalone Mode', href: '/anonymous.html' }
      end
    end
  end
end
