class HomeController < ApplicationController
  def index
  end

  def answer
    @delta = Carrier.find(46)
  end

  def methodology
  end

  def smart_score
  end
end
