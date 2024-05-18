# class Stock < ApplicationRecord
#     def self.new_lookup(ticker_symbol)
#         client = IEX::Api::Client.new(
#             publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
#             secret_token: Rails.application.credentials.iex_client[:secret_api_key],
#             endpoint: "https://api.iex.cloud/v1/data/core/iex_deep/#{ticker_symbol}?token=#{Rails.application.credentials.iex_client[:sandbox_api_key]}"
#         )
#         client.price(ticker_symbol)
#     end
# end

require 'httparty'
 
class Stock < ApplicationRecord
 
    def self.company_lookup(ticker_symbol)
        response = HTTParty.get("https://www.alphavantage.co/query?function=OVERVIEW&symbol=#{ticker_symbol}&apikey=#{Rails.application.credentials.alphavantage[:key]}")
        response.code == 200 && response.parsed_response.is_a?(Hash) ? response.parsed_response['Name'] : nil
        # response.code == 200 ? { symbol: ticker_symbol, name: response.parsed_response['Name'] }.to_json : nil
    end
 
    def self.new_lookup(ticker_symbol)
        response = HTTParty.get("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{ticker_symbol}&apikey=#{Rails.application.credentials.alphavantage[:key]}")
        if response.code == 200 && response.parsed_response.is_a?(Hash) && response.parsed_response['Global Quote']
            last_price = response.parsed_response['Global Quote']['05. price']
            name = company_lookup(ticker_symbol)
            new(ticker: ticker_symbol, name: name, last_price: last_price)
            # { symbol: ticker_symbol, name: name, last_price: last_price }.to_json
        else
            nil
        end
    end
end
