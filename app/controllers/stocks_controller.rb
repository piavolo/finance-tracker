class StocksController < ApplicationController
    def search
        @stock = Stock.new_lookup(params[:stock]) if params[:stock].present?
      
        if @stock
            render 'users/my_portfolio'
        else
            flash[:alert] = params[:stock].present? ? "Please enter a valid symbol to search." : "Please enter a symbol to search."
            redirect_to my_portfolio_path
        end
    end
end