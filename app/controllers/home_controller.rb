class HomeController < ApplicationController
  def index
    @test = t('say_hello')
  end
end
