require 'spec_helper'
require 'chartkick/remote'

describe Chartkick::Remote::Helper, type: :helper do
  anonymous_routes = ActionDispatch::Routing::RouteSet.new.tap do |routes|
    routes.draw { resources :anonymous }
  end

  describe "when the standalone option is set" do
    it "includes a link to the standalone version of the chart" do

      @controller.singleton_class.class_eval do
        include Chartkick::Remote
        include anonymous_routes.url_helpers
        chartkick_remote
      end

      helper.singleton_class.class_eval do
        include anonymous_routes.url_helpers
      end

      @controller.params.merge!(
        action: :index,
        controller: :anonymous
      )

      expect(helper.line_chart(standalone: true) { [[0,1]] }).to have_tag :a #, with: { href: /_chartkick_remote_standalone/ }
    end
  end
end
