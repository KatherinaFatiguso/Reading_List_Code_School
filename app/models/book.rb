class Book < ActiveRecord::Base

  scope :finished, ->{ where.not(finished_on: nil) }
  scope :recent, ->{ where('finished_on > ?', 2.days.ago) }
  scope :search, ->(keyword){ where(title: keyword) if keyword.present? }
  # note with the seach scope: the keyword is case sensitive and must include all title to get result.

  # if you are using class definition for search:
  # def search
  #   if keyword.present?
  #     where(title:keyword)
  #   else
  #     all
  #   and
  # end

  def finished?
    finished_on.present?
  end

end
