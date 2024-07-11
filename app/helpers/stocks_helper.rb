module StocksHelper
  def stock_tracking_message(user, stock)
    if user.stock_already_tracked?(stock.ticker)
      "#{stock.name} is already in your portfolio."
    elsif !user.under_stock_limit?
      "You are already tracking 10 stocks."
    end
  end
end
