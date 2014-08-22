class SearchsController < ApplicationController

	#ver um tipo de resposta standard
	# { :id, :title, :tipo, :categoria,:link}
	def search_for_all
		
		@names = []
		search_in_books #search in ads
		search_in_lendings #search in tuturias
		render json: @names
	end



	private 
		def search_in_books
			book = Book.all.first(30)

			book.each do |a|
				@names << {:id => a.id, :title => a.title,:img => a.image.url(:thumb),:link => book_path(a),:tipo => "Book"}
			end
		end

		def search_in_lendings
			print "**********************************************************"

			lending = Lending.all.first(30)

			print lending
			print "**********************************************************"


			lending.each do |l|

				@names << {:id => l.id,:title => l.book.title,:img => l.image.url(:thumb),:link => lending_path(l),:tipo => "Lending"}
			end
		end

end