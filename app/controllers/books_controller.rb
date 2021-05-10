class BooksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:edit, :destroy]
  
  def index
    @books = current_user.books.order(id: :desc).page(params[:page]).per(8)
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
    @book = Book.new(book_params)
    # @book_imageurl = book_imageurl(@book.isbn)
  end

  def create
    
    @book = current_user.books.build(book_params)
    if @book.save
      flash[:sccess] = '書籍を登録しました。'
      redirect_to books_path
    else
      @books = current_user.books.order(id: :desc).page(params[:page]).per(8)
      flash.now[:danger] = '書籍の登録に失敗しました。'
      render 'books/index'
    end 
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    
    if @book.update(book_params)
      flash[:success] = '正常に更新されました'
      redirect_to books_path
    else
      flash.now[:danger] = '更新されませんでした'
      render :edit
    end 
  end
  
  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    
    flash[:sccess] = '正常に削除されました。'
    redirect_to books_path
  end
  
  private
  
  def book_params
    params.require(:book).permit(:isbn, :title, :author, :status, :memo)
  end
  
  def correct_user
    @book = current_user.books.find_by(id: params[:id])
    unless @book
      redirect_to books_path
    end
  end
  
end