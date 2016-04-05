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

  def tableau
    send_file("#{Rails.root}/public/CKM.twb",
    filename: "CKM_tableau_analysis.twb")
  end
end
