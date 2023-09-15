# Suggestions to run project

This project use global variables that is necessary to call the services the https://docs.coinapi.io/.

To create env file run in terminal touch .env and add the next variables with the his credentials.
```ruby
DATABASE_PASSWORD=example
DATABASE_USER=example

COIN_API_URL=https://rest.coinapi.io/v1/
COIN_API_KEY=api_key
```
if is necessary add other crypto to show in the landing page, add the register with his values in the file `information_cryptos.csv`.

```ruby
# Example the orden and values
asset_id = BTC
asset_name = Bitcoin
monthly_percentage = 5
```
