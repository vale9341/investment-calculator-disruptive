require 'webmock/rspec'
require 'rails_helper'

RSpec.describe CoinApi::InformationCryptos do
  let(:response_exchange_rate) {
    {
      asset_id_base: 'BTC',
      asset_id_quote: 'USD',
      rate: 3260.3514321215056208129867667
    }
  }

  let(:response_icons) {
    [
      {
        asset_id: 'BTC',
        url: 'www.url-image.com'
      },
      {
        asset_id: 'ETH',
        url: 'www.url-image-2.com'
      },
      {
        asset_id: 'ADA',
        url: 'www.url-image-3.com'
      }
    ]
  }

  around do |ex|
    ENV['COIN_API_URL'] = 'https://example.com'
    ENV['COIN_API_KEY'] = '123456'
    ex.run
    ENV.delete 'COIN_API_URL'
    ENV.delete 'COIN_API_KEY'
  end

  let(:subject) { described_class.new }

  describe '#cryptos' do
    before do
      stub_request(:get, "#{ENV.fetch('COIN_API_URL')}/exchangerate/BTC/USD")
        .with(headers: { 'X-CoinAPI-Key': ENV.fetch('COIN_API_KEY') })
        .to_return(status: 200, body: response_exchange_rate.to_json)

      stub_request(:get, "#{ENV.fetch('COIN_API_URL')}/exchangerate/ETH/USD")
        .with(headers: { 'X-CoinAPI-Key': ENV.fetch('COIN_API_KEY') })
        .to_return(status: 200, body: response_exchange_rate.to_json)

      stub_request(:get, "#{ENV.fetch('COIN_API_URL')}/exchangerate/ADA/USD")
        .with(headers: { 'X-CoinAPI-Key': ENV.fetch('COIN_API_KEY') })
        .to_return(status: 200, body: response_exchange_rate.to_json)

      stub_request(:get, "#{ENV.fetch('COIN_API_URL')}/assets/icons/32")
        .with(headers: { 'X-CoinAPI-Key': ENV.fetch('COIN_API_KEY') })
        .to_return(status: 200, body: response_icons.to_json)
    end

    context 'when return array the information cryptos' do
      it 'response successful' do
        expect(subject.cryptos.length).to eq 3
      end
    end
  end
end
