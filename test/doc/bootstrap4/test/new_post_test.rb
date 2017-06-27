require 'test_helper'
require 'formular/helper'
require 'trailblazer/cell'
require 'cell/slim'

class Post::Cell
  class NewBootStrap4 < Trailblazer::Cell
    include Cell::Slim
    include Formular::Helper

    self.view_paths = ['test/doc/bootstrap4/concept']

    def show
      render view: :new
    end

  end
end

#this is good to show how to have nested form + label instead of placeholder
class TestNewPostBootstrap4 < Minitest::Spec
  let(:user) { User.new(1, "Luca", "Rossi", "Male", "01/01/1980", "luca@email.com", "password", "password", "image_path") }
  let(:model) { Post.new(1, "Formular", "Subtitle", "I'm telling you what Formular is", user) }
  let(:new_form) { <<-XML
    <form id="new_post" action="/posts" method="post" accept-charset="utf-8">
      <input name="utf8" type="hidden" value="✓"/>
      <fieldset class="form-group">
        <label class="form-control-label" for="title">Title</label>
        <input name="title" id="title" value="Formular" type="text" class="form-control"/>
      </fieldset>
      <fieldset class="form-group">
        <label class="form-control-label" for="subtitle">Subtitle</label>
        <input name="subtitle" id="subtitle" value="Subtitle" type="text" class="form-control"/>
      </fieldset>
      <fieldset class="form-group">
        <label class="form-control-label" for="body">Write here:</label>
        <input row="9" name="body" id="body" value="I&#39;m telling you what Formular is" type="text" class="form-control"/>
      </fieldset>
      <fieldset class="form-group">
        <input disabled="true" name="user[email]" id="user_email" value="luca@email.com" type="text" class="form-control"/>
      </fieldset>
      <button class="btn btn-secondary" type="submit">Create Post</button>
    </form>
    XML
  }

  let(:new_form_with_errors) { <<-XML
    <form id="new_post" action="/posts" method="post" accept-charset="utf-8">
      <input name="utf8" type="hidden" value="✓"/>
      <fieldset class="form-group has-danger">
        <label class="form-control-label" for="title">Title</label>
        <input name="title" id="title" value="" type="text" class="form-control form-control-danger"/>
        <div class="form-control-feedback">must be filled</div>
      </fieldset>
      <fieldset class="form-group">
        <label class="form-control-label" for="subtitle">Subtitle</label>
        <input name="subtitle" id="subtitle" value="Subtitle" type="text" class="form-control"/>
      </fieldset>
      <fieldset class="form-group has-danger">
        <label class="form-control-label" for="body">Write here:</label>
        <input row="9" name="body" id="body" value="" type="text" class="form-control form-control-danger"/>
        <div class="form-control-feedback">must be filled</div>
      </fieldset>
      <fieldset class="form-group">
        <input disabled="true" name="user[email]" id="user_email" value="luca@email.com" type="text" class="form-control"/>
      </fieldset>
      <button class="btn btn-secondary" type="submit">Create Post</button>
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
      <fieldset class="form-group">
        <label class="form-control-label" for="title">Title</label>
        <input name="title" id="title" value="Formular" type="text" class="form-control"/>
      </fieldset>
    </form>
    XML
  }

  let(:input_with_error) { <<-XML
    <form id="new_post" action="/posts" method="post" accept-charset="utf-8">
      <fieldset class="form-group has-danger">
        <label class="form-control-label" for="title">Title</label>
        <input name="title" id="title" value="" type="text" class="form-control form-control-danger"/>
        <div class="form-control-feedback">must be filled</div>
      </fieldset>
    </form>
    XML
  }

  let(:submit_button) { <<-XML
    <form id="new_post" action="/posts" method="post" accept-charset="utf-8">
      <button class="btn btn-secondary" type="submit">Create Post</button>
    </form>
    XML
  }

  let(:nested_user) { <<-XML
    <form id="new_post" action="/posts" method="post" accept-charset="utf-8">
      <fieldset class="form-group">
        <input disabled="true" name="user[email]" id="user_email" value="luca@email.com" type="text" class="form-control"/>
      </fieldset>
    </form>
    XML
  }


  it "valid inital rendering" do
    form = Post::Contract::New.new(model)
    form.prepopulate!(user: user)
    html = Post::Cell::NewBootStrap4.new(form).()
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
    html = Post::Cell::NewBootStrap4.new(form).()
    assert_xml_contain html, form_format
    assert_xml_contain html, input_with_error
    assert_not_xml_contain html, input_no_error
    assert_xml_contain html, submit_button
    assert_xml_equal html, new_form_with_errors
  end
end

