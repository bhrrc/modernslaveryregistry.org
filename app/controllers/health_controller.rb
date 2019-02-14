class HealthController < ApplicationController
  def show
    render plain: 'OK'
  end
end
