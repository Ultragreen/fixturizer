module Sample
  module Models
    class Comment
      include Mongoid::Document

      field :name, type: String
      field :message, type: String

      belongs_to :post
    end
  end
end