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
    has_many :user_stocks
    has_many :users, through: :user_stocks

    validates :name, :ticker, presence: true

    def self.company_info(ticker_symbol)
        response = HTTParty.get("https://www.alphavantage.co/query?function=OVERVIEW&symbol=#{ticker_symbol}&apikey=#{Rails.application.credentials.alphavantage[:key]}")
        response.code == 200 && response.parsed_response.is_a?(Hash) ? response.parsed_response : nil
    end

    def self.company_name(ticker_symbol)
        info = company_info(ticker_symbol)
        info ? info['Name'] : nil
    end

    def self.company_symbol(ticker_symbol)
        info = company_info(ticker_symbol)
        info ? info['Symbol'] : nil
    end

    def self.new_lookup(ticker_symbol)
        response = HTTParty.get("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{ticker_symbol}&apikey=#{Rails.application.credentials.alphavantage[:key]}")
        if response.code == 200 && response.parsed_response.is_a?(Hash) && response.parsed_response['Global Quote']
            last_price = response.parsed_response['Global Quote']['05. price']
            name = company_name(ticker_symbol)
            symbol = company_symbol(ticker_symbol)
            begin
                new(ticker: symbol, name: name, last_price: last_price)
                # { symbol: ticker_symbol, name: name, last_price: last_price }.to_json
            rescue => exception
                nil
            end
        else
            nil
        end
    end

    def self.check_db(ticker_symbol)
        where(ticker: ticker_symbol).first
    end
end
