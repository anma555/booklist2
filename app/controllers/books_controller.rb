class BooksController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    @books = current_user.books
  end
  
  def search
    if request.post? then
      isbn = params[:isbn]
      if isbn.length == 13 then 
        results = RakutenWebService::Books::Book.search({isbn: params[:isbn]})
        # render :text => results
        @search_book = results.first()
        if @search_book.present? then
          flash[:success] = '見つかりました。'
          @book = Book.new
          @book.isbn = @search_book['isbn']
          @book.title = @search_book['title']
          @book.author = @search_book['author']
          # redirect_back(fallback_location: "/")
        else
          flash.now[:danger] = '見つかりませんでした。'
        end
      else
        flash.now[:danger] = 'ISBNコードを確認してください。'
      end
    end
  end
    
  def new

  end

  def create
    @book = Book.new(book_params)
    @book_imageurl = book_imageurl(@book.isbn)
    
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
  private
  
  def book_params
    params.require(:book).permit(:isbn, :title, :author, :memo, :status)
  end
  
  def book_imageurl(isbn)
    results = RakutenWebService::Books::Book.search({isbn: isbn, })
    result = results.first()
    image_url = result["mediumImageUrl"].gsub('?_ex=120x120', '')
  end
  
end
