require 'csv'

class CoinApi::InformationCryptos
  attr_reader :file_path, :icons, :coin_api_client

  def initialize
    @file_path = File.join(Rails.public_path, 'information_cryptos.csv')
    @coin_api_client = CoinApi::Client.new
    @icons = coin_api_client.list_icons
  end

  def cryptos
    CSV.foreach(file_path, headers: true).each_with_object([]) do |row, arr|
      crypto = row&.to_hash&.merge(
        coin_api_client.exchange_rate(row['asset_id'])
      )&.merge(
        search_icon(row['asset_id'])
      )
      arr << crypto
    end
  end

  def search_icon(asset_id)
    return {} if icons.empty?

    icons.find { |icon| icon['asset_id'] == asset_id }
  end
end
