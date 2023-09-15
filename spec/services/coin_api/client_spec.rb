require 'webmock/rspec'
require 'rails_helper'

RSpec.describe CoinApi::Client do
  describe '#exchange_rate' do
    around do |ex|
      ENV['COIN_API_URL'] = 'https://example.com'
      ENV['COIN_API_KEY'] = '123456'
      ex.run
      ENV.delete 'COIN_API_URL'
      ENV.delete 'COIN_API_KEY'
    end

    context 'when response is successful' do
      let(:response) {
        {
          asset_id_base: 'BTC',
          asset_id_quote: 'USD',
          rate: 3260.3514321215056208129867667
        }
      }

      before do
        stub_request(:get, "#{ENV.fetch('COIN_API_URL')}/exchangerate/BTC/USD")
          .with(headers: { 'X-CoinAPI-Key': ENV.fetch('COIN_API_KEY') })
          .to_return(status: 200, body: response.to_json)
      end

      it 'request successfull' do
        expect(subject.exchange_rate('BTC')).to eq(JSON.parse(response.to_json))
      end
    end

    context 'when response is unsuccessful' do
      before do
        stub_request(:get, "#{ENV.fetch('COIN_API_URL')}/exchangerate/BTC/USD")
          .with(headers: { 'X-CoinAPI-Key': ENV.fetch('COIN_API_KEY') })
          .to_return(status: 500)
      end

      it 'request unsuccessfull' do
        expect(subject.exchange_rate('BTC')).to eq({})
      end
    end
  end

  describe '#list_icons' do
    around do |ex|
      ENV['COIN_API_URL'] = 'https://example.com'
      ENV['COIN_API_KEY'] = '123456'
      ex.run
      ENV.delete 'COIN_API_URL'
      ENV.delete 'COIN_API_KEY'
    end

    context 'when response is successful' do
      let(:response) {
        [
          {
            asset_id: 'BTC',
            url: 'www.url-image.com'
          }
        ]
      }

      before do
        stub_request(:get, "#{ENV.fetch('COIN_API_URL')}/assets/icons/32")
          .with(headers: { 'X-CoinAPI-Key': ENV.fetch('COIN_API_KEY') })
          .to_return(status: 200, body: response.to_json)
      end

      it 'request successfull' do
        expect(subject.list_icons).to eq(JSON.parse(response.to_json))
      end
    end

    context 'when response is unsuccessful' do
      before do
        stub_request(:get, "#{ENV.fetch('COIN_API_URL')}/assets/icons/32")
          .with(headers: { 'X-CoinAPI-Key': ENV.fetch('COIN_API_KEY') })
          .to_return(status: 500)
      end

      it 'request unsuccessfull' do
        expect(subject.list_icons).to eq([])
      end
    end
  end
end
