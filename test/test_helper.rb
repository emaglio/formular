$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'formular'
require 'minitest/autorun'
require 'test_xml/mini_test'
require 'reform'
require 'reform/form/dry'

Comment = Struct.new(:id, :body, :replies, :owner, :uuid, :public, :errors) # TODO: remove errors!
Reply   = Struct.new(:id, :content, :errors)
Owner   = Struct.new(:id, :name, :email, :errors)
COLLECTION_ARRAY = [['Option 1', 1], ['Option 2', 2]]

# Manu test
User = Struct.new(:id, :firstname, :lastname, :gender, :dob, :email, :password, :confirm_password, :avatar)
Post = Struct.new(:id, :title, :subtitle, :body, :user, :opinions)
Opinion = Struct.new(:id, :body, :weight, :public, :user)

def generate_xml(string)
  <<-XML
    #{string}
  XML
end


module Post::Contract
  class New < Reform::Form
    feature Reform::Form::Dry

    property :title
    property :subtitle
    property :body

    validation do
      required(:title).filled
      required(:body).filled
    end

    property :user, prepopulator: ->(options) { self.user = options[:user] } do
      property :email
    end

  end
end


module User::Contract
  class New < Reform::Form
    feature Reform::Form::Dry

    property :email
    property :firstname
    property :lastname
    property :gender
    property :dob #TODO: it would be cool to have an icon of this input like a calendar for the datetime-picker
    property :password, virtual: true
    property :confirm_password, virtual: true
    property :avatar

    validation do

      required(:email).filled
      required(:password).filled
      required(:confirm_password).filled
    end

  end
end


module Post::Contract
  class Show < Reform::Form
    feature Reform::Form::Dry

    collection :opinions,
      prepopulator: ->(options) {self.opinions = [Opinion.new] },
      populator: :populate_opinions! do
        property :body
        property :weight
        property :public
        validation do
          required(:body).filled
          required(:weight).filled
        end
      property :user, prepopulator: ->(options) { self.user = options[:user] } do
        property :email
      end
    end

  private
    def populate_opinions!(collection:, index:, **)
      if item = collection[index]
        item
      else
        collection.insert(index, Opinion.new)
      end
    end
  end
end
