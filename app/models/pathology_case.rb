class PathologyCase < ActiveRecord::Base
  include Abstractor::Abstractable

  scope :by_collection_date, ->(date_from, date_to) do
    if (!date_from.blank? && !date_to.blank?)
      date_range = [date_from, date_to]
    else
      date_range = []
    end

    unless (date_range.first.blank? || date_range.last.blank?)
      where("collection_date BETWEEN ? AND ?", date_range.first, date_range.last)
    end
  end

  scope :search_across_fields, ->(search_token) do
    if search_token
      where("lower(accession_number) like ?", "%#{search_token.downcase}%")
    end
  end
end