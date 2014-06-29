require 'spec_helper'

require 'chartkick_remote'

AnonymousRoutes = ActionDispatch::Routing::RouteSet.new.tap do |routes|
  routes.draw { resources :anonymous }
end

describe Chartkick::Remote::Helper, type: :helper do
  describe "when the standalone option is set" do
    it "includes a link to the standalone version of the chart" do

      @controller.singleton_class.class_eval do
        include Chartkick::Remote
        include AnonymousRoutes.url_helpers
        chartkick_remote
      end

      helper.singleton_class.class_eval do
        include AnonymousRoutes.url_helpers
      end

      @controller.params.merge!(
        action: :index,
        controller: :anonymous
      )

      expect(helper.line_chart(standalone: true) { [[0,1]] }).to have_tag :a #, with: { href: /_chartkick_remote_standalone/ }
    end
  end
end
