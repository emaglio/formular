$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'formular'
require 'minitest/autorun'
require 'test_xml/mini_test'

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

