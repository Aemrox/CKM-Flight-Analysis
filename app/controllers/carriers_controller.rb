class CarriersController < ApplicationController
  def show
    @carrier = Carrier.find(params[:id])
    respond_to do |format|
      format.html{}
      format.json{render json: @carrier.to_json}
    end
  end

  def index
    @carriers = Carrier.all
  end

  def delay_chart
    respond_to do |format|
      format.json{render json: Carrier.delay_chart}
    end
  end

  def taxi_chart
    respond_to do |format|
      format.json{render json: Carrier.taxi_chart}
    end
  end

  def rate_chart
    respond_to do |format|
      format.json{render json: Carrier.rate_chart}
    end
  end

  def destination_search
    @d_hash = Carrier.destination_search(params[:query])
    @city = params[:query]
    respond_to do |format|
      format.js {}
    end
  end
end
