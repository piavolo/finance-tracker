class StocksController < ApplicationController
    def search
        params[:stock].present? ? @stock = Stock.new_lookup(params[:stock]) : flash[:alert] = "Please enter a symbol to search."
        respond_to do |format|
            unless @stock == nil
                format.turbo_stream { render turbo_stream: turbo_stream.replace("result", partial: "users/result", locals: { stock: @stock }) }
                format.html { render 'users/my_portfolio' }
            else
                flash.now[:alert] ||= "Please enter a valid symbol to search."
                format.html { redirect_to my_portfolio_path, alert: flash.now[:alert] }
            end
        end
    end
end
