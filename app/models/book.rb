class Book < ActiveRecord::Base

  has_many :book_genres
  has_many :genres, through: :book_genres

  scope :finished, ->{ where.not(finished_on: nil) }
  scope :recent, ->{ where('finished_on > ?', 2.days.ago) }
  scope :search, ->(keyword){ where('keywords LIKE ?', "%#{keyword.downcase}%") if keyword.present? }
  # anything in the keywords attribute that matches the word in keyword in lowercase
  # wildcards is for anything that comes before or anything that comes after the keyword

  # this is filtering by genre id, and by writing sql
  # scope :filter_book, ->(genre_id){ joins(:book_genres).where('book_genres.genre_id = ?', genre_id) if genre_id.present? }
  # another way:
  # scope :filter_book, ->(genre_id){ joins(:book_genres).where(book_genres: {genre_id: genre_id}) if genre_id.present? }

  # this is filtering by genre name
  scope :filter_book, ->(name){ joins(:genres).where('genres.name = ?', name) if name.present? }

  before_save :set_keywords # this will run the callbacks before each save

  # if you are using class definition for search:
  # def search
  #   if keyword.present?
  #     where(title:keyword)
  #   else
  #     all #this part is required if you are using class definition, but not required in scope, because scope will return a collection for you
  #   and
  # end

  def finished?
    finished_on.present?
  end

  protected
    def set_keywords
      # must use self. otherwise keyword is just a local variable, it is not referencing the model's property
      # if you want to just read the keyword, you don't need to use .self
      # but if you want to assign a value to a property, you need to use .self
      self.keywords = [title, author, description].map(&:downcase).join(' ')
      # get the text from title, author and description, set to lowercase, join each item in the array with a space in between, thus returns a string.
      # Result in keywords of a book:
      # "hyperion dan simmons probably my favorite science fiction book (and series) i've ever read. hyperion is written in a style similar to the canterbury tales, in which a series of stories are told by the main characters. each story is a gem in itself, but alude to the larger storyline. the scope of the story is ambitious - spanning time, planets religion and love."
    end

end
