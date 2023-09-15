class LandingPagesController < ApplicationController
  helper_method :cryptos, :cryptos_for_select

  private

  def cryptos
    @cryptos ||= CoinApi::InformationCryptos.new.cryptos
  end

  def cryptos_for_select
    cryptos.each_with_object([]) do |crypto, arr|
      arr << [crypto['asset_name'], crypto['asset_id']]
    end
  end
end
