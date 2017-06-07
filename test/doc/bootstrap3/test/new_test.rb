require 'test_helper'
require 'formular/helper'
require 'trailblazer/cell'
require 'cell/slim'
require 'reform'

class User::Cell
  class New < Trailblazer::Cell
    include Cell::Slim
    include Formular::Helper

    self.view_paths = ['test/doc/bootstrap3/concept']

    def show
      render view: :new
    end

    def form_authenticity_token
      "key"
    end

  end
end


module User::Contract
  class New < Reform::Form
    property :email
    property :firstname
    property :lastname
    property :password, virtual: true
    property :confirm_password, virtual: true

  end
end

class TestNew < Minitest::Spec
  describe 'valid, initial rendering' do
    let(:model) { User.new(1, "Luca", "Rossi", "luca@email.com", "password", "password") }

    it do
      form = User::Contract::New.new(model)
      User::Cell::New.new(form).().must_equal %(<div>New</div><form action="/posts" method="post" accept-charset="utf-8"><input name="utf8" type="hidden" value="✓"/><input name="comment[id]" id="comment_id" value="1" type="text"/><textarea name="comment[body]" id="comment_body">Nice!</textarea><input value="0" name="comment[public]" type="hidden"/><input value="true" name="comment[public]" id="comment_public" type="checkbox" checked="checked"/><input name="comment[replies][][content]" id="comment_replies_0_content" value="some exciting words" type="text"/><input name="comment[replies][][content]" id="comment_replies_1_content" type="text"/><input name="comment[owner][name]" id="comment_owner_name" value="Joe Blog" type="text"/><input name="comment[owner][email]" id="comment_owner_email" value="joe@somewhere.com" type="text"/><input name="comment[uuid]" id="comment_uuid" value="0x" type="text"/><input value="Submit" type="submit"/></form>)
    end
  end
end

