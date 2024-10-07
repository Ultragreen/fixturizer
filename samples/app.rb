# frozen_string_literal: true

require 'sinatra'
require 'mongoid'

Mongoid.configure do |config|
  config.clients.default = {
    uri: 'mongodb://localhost:27017/testbase'

  }
  config.belongs_to_required_by_default = false
end

class Post
  include Mongoid::Document
  field :title, type: String
  field :body, type: String
  has_many :comments
  has_one :type
end


class Type
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  belongs_to :post, optional: true
end


class Comment
  include Mongoid::Document
  field :name, type: String
  field :message, type: String
  belongs_to :post
end

class Application < Sinatra::Base
  before do
    content_type 'application/json'
  end

  get '/posts' do
    Post.all.to_json
  end

  get '/posts/:post_id' do |post_id|
    post = Post.find(post_id)
    post.attributes.merge(
      comments: post.comments,
      type: post.type
    ).to_json
  end
end
