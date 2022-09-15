module Sample
  module Models
    class Post
      include Mongoid::Document

      field :title, type: String
      field :body, type: String

      has_many :comments
    end
  end
end
