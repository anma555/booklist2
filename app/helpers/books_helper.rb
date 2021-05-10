module BooksHelper
  def book_imageurl(isbn)
    results = RakutenWebService::Books::Book.search({isbn: isbn, })
    result = results.first()
    result["mediumImageUrl"].gsub('?_ex=120x120', '')
  end
end
