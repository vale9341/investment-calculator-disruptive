class CoinApi::Client
  attr_reader :asset_id, :asset_quote_id

  def exchange_rate(asset_id, asset_quote_id: 'USD')
    response = client["exchangerate/#{asset_id}/#{asset_quote_id}"].get
    parse_body(response)
  rescue RestClient::ExceptionWithResponse => _e
    {}
  end

  def list_icons
    response = client['assets/icons/32'].get
    parse_body(response)
  rescue RestClient::ExceptionWithResponse => _e
    []
  end

  private

  def client
    @client ||=
      RestClient::Resource.new(
        host,
        headers: {
          "X-CoinAPI-Key": api_key
        }
      )
  end

  def parse_body(body)
    JSON.parse(body)
  end

  def host
    ENV.fetch('COIN_API_URL')
  end

  def api_key
    ENV.fetch('COIN_API_KEY')
  end
end
