require 'amazon/search'


class BooksController < ApplicationController


  include Amazon::Search
  # GET /books
  # GET /books.xml
  def index
    @books = Book.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @books.to_xml }
    end
  end

  # GET /books/1
  # GET /books/1.xml
  def show
    @book = Book.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @book.to_xml }
    end
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1;edit
  def edit
    @book = Book.find(params[:id])
  end

  # POST /books
  # POST /books.xml
  def create
    @book = Book.new(params[:book])

    respond_to do |format|
      if @book.save
        flash[:notice] = 'Book was successfully created.'
        format.html { redirect_to book_url(@book) }
        format.xml  { head :created, :location => book_url(@book) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @book.errors.to_xml }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.xml
  def update
    @book = Book.find(params[:id])

    respond_to do |format|
      if @book.update_attributes(params[:book])
        flash[:notice] = 'Book was successfully updated.'
        format.html { redirect_to book_url(@book) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @book.errors.to_xml }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.xml
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url }
      format.xml  { head :ok }
    end
  end
  
  def book_search
    key ='0BCRK8ZF0WS5EXBV6182'
    secret = 'q/Dl5+qKh9cK2vdt4z3up+K2opM0T/okYHtq/ePf'
    code = params[:book][:ean]
    code.gsub!(/[^0-9X]/,'')
    locale = 'de'
    if code.size == 10 
      method = :asin_search
      locale = 'de'
      pq = "#{code}"
    elsif code.size == 13
      if code.match(/^978/)
        code = isbn_to_asin(code)
        pq = "#{code}"
        locale = 'de'
        method = :asin_search
      else
        pq = "ISBN:#{code}"
        group = code[3,1]
        locale = 'de'
        locale = 'de' if group == '3'
        locale = 'us' if group == '0' || group == '1'
        method = :power_search
      end
    else 
      render :update do |page|
        page[:message].replace_html("no useful code, sorry")
      end
      return
    end
    begin
      req  = Request.new(key, nil, locale)  # second argument optional
      logger.debug("sent: #{method} - #{pq}")
      resp = req.send(method, pq)
      product = resp.products.first
      render :update do |page|
        page[:book_title].value = product.product_name
        page[:message].replace_html("done")
      end
    rescue Amazon::Search::Request::SearchError => e
      render :update do |page|
        page[:message].replace_html(e)
      end
      
    end
    
  end
  
private
  def isbn_to_asin(code)
    return code if code.size != 13
    return code unless code.match(/^978/)
    code = code[3,9]
    code += isbn_checksum(code).to_s
  end
  
  def isbn_checksum(isbn)
    sum = 0 
    10.step( 2, -1 ) do |n|
   	  m = 10 - n 
   	  sum += n * isbn[m..m].to_i 
   	end 
   	checksum = ( 11 - (sum % 11 ) ) % 11 
   	checksum = 'X' if checksum == 10 
   	checksum.to_s 
  end
end
