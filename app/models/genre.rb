class Genre < ActiveRecord::Base
  #has_many :books, dependent: :destroy
  # This is if I want to delete a genre along with all books using this genre
  has_many :book_genres
  has_many :books, through: :book_genres
end
