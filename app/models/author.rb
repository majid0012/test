class Author < ApplicationRecord
    has_many :books, inverse_of: :author
end
