class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def search
    if params[:weight]
      value = params[:weight].to_f.round(3)
      @books = []
      error_range = 0.001
      @error = 0.001
      while @books.count == 0 do
        
        value_min = value - @error
        value_max = value + @error

        @books = Book.all(:conditions => ['weight >= ? and weight <= ?', value_min, value_max])
        @book_count = @books.count
        @error = @error + error_range
      end

    else
      @books = nil
    end

  end

  # GET /books
  # GET /books.json
  def index
    @books = Book.first(25)
    @all_books = Book.all.count

    i = 0
    while i < 0 do
      value =  ((Random.rand(1000)) / 1000.0).round(3)
      i = i + 1
      a = Book.new(:barcode => "Serie 10000",:weight => value,:other_weight => value,:title => "Teste#{i}")

      a.save
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
    @book.weight = params[:weight].to_f
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render action: 'show', status: :created, location: @book }
      else
        format.html { render action: 'new' }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:barcode, :weight, :title, :other_weight)
    end
end
