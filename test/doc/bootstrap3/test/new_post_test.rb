require 'test_helper'
require 'formular/helper'
require 'trailblazer/cell'
require 'cell/slim'
require 'reform'
require 'reform/form/dry'

class Post::Cell
  class New < Trailblazer::Cell
    include Cell::Slim
    include Formular::Helper

    self.view_paths = ['test/doc/bootstrap3/concept']

    def show
      render view: :new
    end

  end
end


module Post::Contract
  class New < Reform::Form
    feature Reform::Form::Dry

    property :title
    property :subtitle
    property :body
    property :image

    validation with: {form: true} do

      required(:title).filled
      required(:body).filled
      required(:image).filled
    end

  end
end

#this is good to show how to get the full path of a file to upload + label instead of placeholder
class TestNewPost < Minitest::Spec
  let(:model) { Post.new(1, "Formular", "Subtitle", "I'm telling you what Formular is", "path") }
  let(:new_form) { <<-XML
    <form id="new_post" enctype="multipart/form-data" action="/posts" method="post" accept-charset="utf-8">
      <input name="utf8" type="hidden" value="&#x2713;"/>
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
        <input name="body" id="body" value="I'm telling you what Formular is" type="text" class="form-control"/>
      </div>
      <div class="form-group">
        <label for="image" class="control-label">Post Image</label>
        <input type="file" name="image" id="image" value="path"/>
      </div>
      <button class="btn btn-default" type="submit">Create Post</button>
    </form>
    XML
  }

  let(:new_form_with_errors) { <<-XML
    <form id="new_post" enctype="multipart/form-data" action="/posts" method="post" accept-charset="utf-8">
      <input name="utf8" type="hidden" value="&#x2713;"/>
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
        <input name="body" id="body" value="" type="text" class="form-control"/>
        <span class="help-block">must be filled</span>
      </div>
      <div class="form-group has-error">
        <label for="image" class="control-label">Post Image</label>
        <input type="file" name="image" id="image" value=""/>
        <span class="help-block">must be filled</span>
      </div>
      <button class="btn btn-default" type="submit">Create Post</button>
    </form>
    XML
  }


  let(:form_format) { <<-XML
     <form id="new_post" enctype="multipart/form-data" action="/posts" method="post" accept-charset="utf-8">
      <input name="utf8" type="hidden" value="&#x2713;"/>
    </form>
    XML
  }

  let(:input_no_error) { <<-XML
     <form id="new_post" enctype="multipart/form-data" action="/posts" method="post" accept-charset="utf-8">
      <div class="form-group">
        <label for="title" class="control-label">Title</label>
        <input name="title" id="title" value="Formular" type="text" class="form-control"/>
      </div>
    </form>
    XML
  }

  let(:input_with_error) { <<-XML
     <form id="new_post" enctype="multipart/form-data" action="/posts" method="post" accept-charset="utf-8">
      <div class="form-group has-error">
        <label for="title" class="control-label">Title</label>
        <input name="title" id="title" value="" type="text" class="form-control"/>
        <span class="help-block">must be filled</span>
      </div>
    </form>
    XML
  }

  let(:input_file_type) { <<-XML
     <form id="new_post" enctype="multipart/form-data" action="/posts" method="post" accept-charset="utf-8">
      <div class="form-group">
        <input type="file" name="image" id="image" value="path"/>
      </div>
    </form>
    XML
  }

  let(:submit_button) { <<-XML
     <form id="new_post" enctype="multipart/form-data" action="/posts" method="post" accept-charset="utf-8">
      <button class="btn btn-default" type="submit">Create Post</button>
    </form>
    XML
  }

  it "valid inital rendering" do
    form = Post::Contract::New.new(model)
    html = Post::Cell::New.new(form).()
    assert_xml_contain html, form_format
    assert_xml_contain html, input_no_error
    assert_not_xml_contain html, input_with_error
    assert_xml_contain html, input_file_type
    assert_xml_contain html, submit_button
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

