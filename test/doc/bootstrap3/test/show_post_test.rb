require 'test_helper'
require 'formular/helper'
require 'trailblazer/cell'
require 'cell/slim'

class Post::Cell
  class ShowBootstrap3 < Trailblazer::Cell
    include Cell::Slim
    include Formular::Helper

    self.view_paths = ['test/doc/bootstrap3/concept']

    def show
      render view: :show
    end

  end
end


#this is good to show how to have nested form + hidden input + radio and checkbox input
class TestShowPostBootstrap3 < Minitest::Spec
  let(:user) { User.new(1, "Luca", "Rossi", "Male", "01/01/1980", "luca@email.com", "password", "password", "image_path") }
  let(:model) { Post.new(1, "Formular", "Subtitle", "I'm telling you what Formular is", user, []) }
  let(:new_form) { <<-XML
    <form method="post" id="new_comment" action="/opinions/create" accept-charset="utf-8">
      <input name="utf8" type="hidden" value="✓"/>
      <div class="form-group">
        <input type="hidden" value="current_user.email" name="opinions[][user][email]" id="opinions_0_user_email" class="form-control"/>
      </div>
      <div class="form-group">
        <textarea rows="3" placeholder="Your Comment" name="opinions[][body]" id="opinions_0_body" class="form-control"></textarea>
      </div>
      <div class="form-group">
        <div class="radio">
          <label><input type="radio" name="opinions[][weight]" value="0" id="opinions_0_weight_0"/> Neutral</label>
        </div>
        <div class="radio">
          <label><input type="radio" name="opinions[][weight]" value="1" id="opinions_0_weight_1"/> Agreed</label>
        </div>
        <div class="radio">
          <label><input type="radio" name="opinions[][weight]" value="2" id="opinions_0_weight_2"/> Not Agreed</label>
        </div>
      </div>
      <div class="form-group">
        <input value="0" name="opinions[][public]" type="hidden"/>
        <div class="checkbox">
          <label><input name="opinions[][public]" id="opinions_0_public" type="checkbox" value="1"/> Public?</label>
        </div>
      </div>
      <button class="btn btn-default" type="submit">Create Comment</button>
    </form>
    XML
  }

  let(:new_form_with_errors) { <<-XML
    <form method="post" id="new_comment" action="/opinions/create" accept-charset="utf-8">
      <input name="utf8" type="hidden" value="✓"/>
      <div class="form-group">
        <input type="hidden" value="current_user.email" name="opinions[][user][email]" id="opinions_0_user_email" class="form-control"/>
      </div>
      <div class="form-group has-error">
        <textarea rows="3" placeholder="Your Comment" name="opinions[][body]" id="opinions_0_body" class="form-control"></textarea>
        <span class="help-block">must be filled</span>
      </div>
      <div class="form-group has-error">
        <div class="radio">
          <label><input type="radio" name="opinions[][weight]" value="0" id="opinions_0_weight_0"/> Neutral</label>
        </div>
        <div class="radio">
          <label><input type="radio" name="opinions[][weight]" value="1" id="opinions_0_weight_1"/> Agreed</label>
        </div>
        <div class="radio">
          <label><input type="radio" name="opinions[][weight]" value="2" id="opinions_0_weight_2"/> Not Agreed</label>
        </div>
        <span class="help-block">must be filled</span>
      </div>
      <div class="form-group">
        <input value="0" name="opinions[][public]" type="hidden"/>
        <div class="checkbox">
          <label><input name="opinions[][public]" id="opinions_0_public" type="checkbox" value="1"/> Public?</label>
        </div>
      </div>
      <button class="btn btn-default" type="submit">Create Comment</button></form>
    XML
  }


  let(:form_format) { <<-XML
    <form method="post" id="new_comment" action="/opinions/create" accept-charset="utf-8">
      <input name="utf8" type="hidden" value="✓"/>
    </form>
    XML
  }

  let(:nested_input_no_error) { <<-XML
     <form method="post" id="new_comment" action="/opinions/create" accept-charset="utf-8">
      <div class="form-group">
        <textarea rows="3" placeholder="Your Comment" name="opinions[][body]" id="opinions_0_body" class="form-control"></textarea>
      </div>
    </form>
    XML
  }

  let(:nested_input_with_error) { <<-XML
     <form method="post" id="new_comment" action="/opinions/create" accept-charset="utf-8">
      <div class="form-group has-error">
        <div class="radio">
          <label><input type="radio" name="opinions[][weight]" value="0" id="opinions_0_weight_0"/> Neutral</label>
        </div>
        <div class="radio">
          <label><input type="radio" name="opinions[][weight]" value="1" id="opinions_0_weight_1"/> Agreed</label>
        </div>
        <div class="radio">
          <label><input type="radio" name="opinions[][weight]" value="2" id="opinions_0_weight_2"/> Not Agreed</label>
        </div>
        <span class="help-block">must be filled</span>
      </div>
    </form>
    XML
  }

  let(:submit_button) { <<-XML
     <form method="post" id="new_comment" action="/opinions/create" accept-charset="utf-8">
      <button class="btn btn-default" type="submit">Create Comment</button>
    </form>
    XML
  }

    let(:radio_input) { <<-XML
      <form method="post" id="new_comment" action="/opinions/create" accept-charset="utf-8">
        <div class="form-group">
          <div class="radio">
            <label><input type="radio" name="opinions[][weight]" value="0" id="opinions_0_weight_0"/> Neutral</label>
          </div>
          <div class="radio">
            <label><input type="radio" name="opinions[][weight]" value="1" id="opinions_0_weight_1"/> Agreed</label>
          </div>
          <div class="radio">
            <label><input type="radio" name="opinions[][weight]" value="2" id="opinions_0_weight_2"/> Not Agreed</label>
          </div>
        </div>
      </form>
    XML
  }

  let(:checkbox_input) { <<-XML
    <form method="post" id="new_comment" action="/opinions/create" accept-charset="utf-8">
      <div class="form-group">
        <input value="0" name="opinions[][public]" type="hidden"/>
        <div class="checkbox">
          <label><input name="opinions[][public]" id="opinions_0_public" type="checkbox" value="1"/> Public?</label>
        </div>
      </div>
    </form>
    XML
  }


  it "valid inital rendering" do
    form = Post::Contract::Show.new(model)
    form.prepopulate!(user: user)
    html = Post::Cell::ShowBootstrap3.new(form).()
    assert_xml_contain html, form_format
    assert_xml_contain html, nested_input_no_error
    assert_not_xml_contain html, nested_input_with_error
    assert_xml_contain html, submit_button
    assert_xml_contain html, radio_input
    assert_xml_contain html, checkbox_input
    assert_xml_equal html, new_form
  end

  it "redering with errors" do
    form = Post::Contract::Show.new(model)
    form.prepopulate!(user: user)
    form.validate(body: "", weight: "")
    html = Post::Cell::ShowBootstrap3.new(form).()
    assert_xml_contain html, form_format
    assert_xml_contain html, nested_input_with_error
    assert_xml_contain html, submit_button
    assert_xml_equal html, new_form_with_errors
  end
end

