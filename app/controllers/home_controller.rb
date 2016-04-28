class HomeController < ApplicationController
  def index
    ws = Webshot::Screenshot.instance
    ws.capture "http://www.google.com/", "tmp/google.png", width: 1200, height: 900, quality: 90
  end
end