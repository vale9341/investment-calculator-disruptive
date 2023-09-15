require 'rails_helper'

RSpec.describe LandingPagesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/landing_pages').to route_to(
        'landing_pages#index', action: 'index'
      )
    end
  end
end
