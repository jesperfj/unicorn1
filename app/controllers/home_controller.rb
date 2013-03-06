require 'random_gaussian'

class HomeController < ApplicationController

  WAIT_MEAN = ENV['WAIT_MEAN'].to_f || 0.1

  # 1sigma = p841
  # 2sigma = p977
  # 3sigma = p998

  WAIT_SDEV = ENV['WAIT_SDEV'].to_f || 0.02

  def index
    sleep [WAIT.rand,0].max
    render :nothing => true, :status => :ok
  end

  protected

    WAIT = RandomGaussian.new(WAIT_MEAN,WAIT_SDEV)

end


