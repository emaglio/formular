require 'test_helper'
require 'formular/helper'
require 'trailblazer/cell'
require 'cell/slim'
require 'reform'
require 'reform/form/dry'

class Post::Cell
  class Show < Trailblazer::Cell
    include Cell::Slim
    include Formular::Helper

    self.view_paths = ['test/doc/bootstrap3/concept']

    def show
      render view: :show
    end

    def model

    end

  end
end


module Post::Contract
  class Show < Reform::Form
    feature Reform::Form::Dry

    collection :opinions,
      prepopulator: ->(options) { opinions.size == 0 ? self.opinions = [Opinion.new] : self.opinions << Opinion.new },
      populator: :populate_opinions! do
        property :body
        property :weight
        validation do
          required(:body).filled
          required(:weight).filled
        end
    end

    property :user, prepopulator: ->(options) { self.user = options[:user] } do
      property :email
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


#this is good to show how to have nested form + label instead of placeholder
class TestNewPost < Minitest::Spec
  let(:user) { User.new(1, "Luca", "Rossi", "Male", "01/01/1980", "luca@email.com", "password", "password", "image_path") }
  let(:model) { Post.new(1, "Formular", "Subtitle", "I'm telling you what Formular is", user, []) }
  let(:new_form) { <<-XML
    <form id="new_post" action="/posts" method="post" accept-charset="utf-8">
      <input name="utf8" type="hidden" value="✓"/>
      <div class="form-group">
        <label for="title" class="control-label">Title</label>
        <input name="title" id="title" value="Formular" type="text" class="form-control"/>
      </div>
      <div class="form-group">
        <label for="subtitle" class="control-label">Subtitle</label>
        <input name="subtitle" id="subtitle" value="Subtitle" type="text" class="form-control"/>
      </div>
      <div class="form-group">
        <label for="body" class="control-label">Write here:</label>
        <input row="9" name="body" id="body" value="I'm telling you what Formular is" type="text" class="form-control"/>
      </div>
      <div class="form-group">
        <input disabled="true" name="user[email]" id="user_email" value="luca@email.com" type="text" class="form-control"/>
      </div>
      <button class="btn btn-default" type="submit">Create Post</button>
    </form>
    XML
  }

  let(:new_form_with_errors) { <<-XML
    <form id="new_post" action="/posts" method="post" accept-charset="utf-8">
      <input name="utf8" type="hidden" value="✓"/>
      <div class="form-group has-error">
        <label for="title" class="control-label">Title</label>
        <input name="title" id="title" value="" type="text" class="form-control"/>
        <span class="help-block">must be filled</span>
      </div>
      <div class="form-group">
        <label for="subtitle" class="control-label">Subtitle</label>
        <input name="subtitle" id="subtitle" value="Subtitle" type="text" class="form-control"/>
      </div>
      <div class="form-group has-error">
        <label for="body" class="control-label">Write here:</label>
        <input row="9" name="body" id="body" value="" type="text" class="form-control"/>
        <span class="help-block">must be filled</span>
      </div>
      <div class="form-group">
        <input disabled="true" name="user[email]" id="user_email" value="luca@email.com" type="text" class="form-control"/>
      </div>
      <button class="btn btn-default" type="submit">Create Post</button>
    </form>
    XML
  }


  let(:form_format) { <<-XML
     <form id="new_post" action="/posts" method="post" accept-charset="utf-8">
      <input name="utf8" type="hidden" value="✓"/>
    </form>
    XML
  }

  let(:input_no_error) { <<-XML
     <form id="new_post" action="/posts" method="post" accept-charset="utf-8">
      <div class="form-group">
        <label for="title" class="control-label">Title</label>
        <input name="title" id="title" value="Formular" type="text" class="form-control"/>
      </div>
    </form>
    XML
  }

  let(:input_with_error) { <<-XML
     <form id="new_post" action="/posts" method="post" accept-charset="utf-8">
      <div class="form-group has-error">
        <label for="title" class="control-label">Title</label>
        <input name="title" id="title" value="" type="text" class="form-control"/>
        <span class="help-block">must be filled</span>
      </div>
    </form>
    XML
  }

  let(:submit_button) { <<-XML
     <form id="new_post" action="/posts" method="post" accept-charset="utf-8">
      <button class="btn btn-default" type="submit">Create Post</button>
    </form>
    XML
  }

    let(:nested_user) { <<-XML
     <form id="new_post" action="/posts" method="post" accept-charset="utf-8">
      <div class="form-group">
        <input disabled="true" name="user[email]" id="user_email" value="luca@email.com" type="text" class="form-control"/>
      </div>
    </form>
    XML
  }


  it "valid inital rendering" do
    form = Post::Contract::Show.new(model)
    form.prepopulate!(user: user)
    form.validate(body: "", weight: "")

    raise form.inspect

    html = Post::Cell::Show.new(form).()
    assert_xml_contain html, form_format
    assert_xml_contain html, input_no_error
    assert_not_xml_contain html, input_with_error
    assert_xml_contain html, submit_button
    assert_xml_contain html, nested_user
    assert_xml_equal html, new_form
  end

  it "redering with errors" do
    form = Post::Contract::New.new(model)
    form.validate(title: "", body: "", image: "")
    html = Post::Cell::New.new(form).()
    assert_xml_contain html, form_format
    assert_xml_contain html, input_with_error
    assert_not_xml_contain html, input_no_error
    assert_xml_contain html, submit_button
    assert_xml_equal html, new_form_with_errors
  end
end

