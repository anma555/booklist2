class ToppagesController < ApplicationController
  def index
    if logged_in? then
      redirect_to books_path
    end
  end
end
