require 'test_helper'
require 'formular/helper'
require 'trailblazer/cell'
require 'cell/slim'
require 'reform'
require 'reform/form/dry'

class Post::Cell
  class ShowBootstrap4 < Trailblazer::Cell
    include Cell::Slim
    include Formular::Helper

    self.view_paths = ['test/doc/bootstrap4/concept']

    def show
      render view: :show
    end

  end
end


#this is good to show how to have nested form + hidden input + radio and checkbox input
class TestShowPostBootstrap4 < Minitest::Spec
  let(:user) { User.new(1, "Luca", "Rossi", "Male", "01/01/1980", "luca@email.com", "password", "password", "image_path") }
  let(:model) { Post.new(1, "Formular", "Subtitle", "I'm telling you what Formular is", user, []) }
  let(:new_form) { <<-XML
    <form method="post" id="new_comment" action="/opinions/create" accept-charset="utf-8">
      <input name="utf8" type="hidden" value="✓"/>
      <fieldset class="form-group">
        <input type="hidden" value="current_user.email" name="opinions[][user][email]" id="opinions_0_user_email" class="form-control"/>
      </fieldset>
      <fieldset class="form-group">
        <textarea rows="3" placeholder="Your Comment" name="opinions[][body]" id="opinions_0_body" class="form-control"></textarea>
      </fieldset>
      <fieldset class="form-group">
        <div class="form-check">
          <label class="form-check-label"><input type="radio" name="opinions[][weight]" value="0" id="opinions_0_weight_0" class="form-check-input"/> Neutral</label>
        </div>
        <div class="form-check">
          <label class="form-check-label"><input type="radio" name="opinions[][weight]" value="1" id="opinions_0_weight_1" class="form-check-input"/> Agreed</label>
        </div>
        <div class="form-check">
          <label class="form-check-label"><input type="radio" name="opinions[][weight]" value="2" id="opinions_0_weight_2" class="form-check-input"/> Not Agreed</label>
        </div>
      </fieldset>
      <fieldset class="form-group">
        <input value="0" name="opinions[][public]" type="hidden"/>
        <div class="form-check">
          <label class="form-check-label"><input name="opinions[][public]" id="opinions_0_public" type="checkbox" value="1" class="form-check-input"/> Public?</label>
        </div>
      </fieldset>
      <button class="btn btn-secondary" type="submit">Create Comment</button></form>
    XML
  }

  let(:new_form_with_errors) { <<-XML
    <form method="post" id="new_comment" action="/opinions/create" accept-charset="utf-8">
      <input name="utf8" type="hidden" value="✓"/>
      <fieldset class="form-group">
        <input type="hidden" value="current_user.email" name="opinions[][user][email]" id="opinions_0_user_email" class="form-control"/>
      </fieldset>
      <fieldset class="form-group has-danger">
        <textarea rows="3" placeholder="Your Comment" name="opinions[][body]" id="opinions_0_body" class="form-control"></textarea>
        <div class="form-control-feedback">must be filled</div>
      </fieldset>
      <fieldset class="form-group has-danger">
        <div class="form-check">
          <label class="form-check-label"><input type="radio" name="opinions[][weight]" value="0" id="opinions_0_weight_0" class="form-check-input"/> Neutral</label>
        </div>
        <div class="form-check">
          <label class="form-check-label"><input type="radio" name="opinions[][weight]" value="1" id="opinions_0_weight_1" class="form-check-input"/> Agreed</label>
        </div>
        <div class="form-check">
          <label class="form-check-label"><input type="radio" name="opinions[][weight]" value="2" id="opinions_0_weight_2" class="form-check-input"/> Not Agreed</label>
        </div>
        <div class="form-control-feedback">must be filled</div>
      </fieldset>
      <fieldset class="form-group">
        <input value="0" name="opinions[][public]" type="hidden"/>
        <div class="form-check">
          <label class="form-check-label"><input name="opinions[][public]" id="opinions_0_public" type="checkbox" value="1" class="form-check-input"/> Public?</label>
        </div>
      </fieldset>
    <button class="btn btn-secondary" type="submit">Create Comment</button></form>
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
      <fieldset class="form-group">
        <textarea rows="3" placeholder="Your Comment" name="opinions[][body]" id="opinions_0_body" class="form-control"></textarea>
      </fieldset>
    </form>
    XML
  }

  let(:nested_input_with_error) { <<-XML
     <form method="post" id="new_comment" action="/opinions/create" accept-charset="utf-8">
      <fieldset class="form-group has-danger">
        <div class="form-check">
          <label class="form-check-label"><input type="radio" name="opinions[][weight]" value="0" id="opinions_0_weight_0" class="form-check-input"/> Neutral</label>
        </div>
        <div class="form-check">
          <label class="form-check-label"><input type="radio" name="opinions[][weight]" value="1" id="opinions_0_weight_1" class="form-check-input"/> Agreed</label>
        </div>
        <div class="form-check">
          <label class="form-check-label"><input type="radio" name="opinions[][weight]" value="2" id="opinions_0_weight_2" class="form-check-input"/> Not Agreed</label>
        </div>
        <div class="form-control-feedback">must be filled</div>
      </fieldset>
    </form>
    XML
  }

  let(:submit_button) { <<-XML
     <form method="post" id="new_comment" action="/opinions/create" accept-charset="utf-8">
      <button class="btn btn-secondary" type="submit">Create Comment</button></form>
    </form>
    XML
  }

    let(:radio_input) { <<-XML
      <form method="post" id="new_comment" action="/opinions/create" accept-charset="utf-8">
        <fieldset class="form-group">
          <div class="form-check">
            <label class="form-check-label"><input type="radio" name="opinions[][weight]" value="0" id="opinions_0_weight_0" class="form-check-input"/> Neutral</label>
          </div>
          <div class="form-check">
            <label class="form-check-label"><input type="radio" name="opinions[][weight]" value="1" id="opinions_0_weight_1" class="form-check-input"/> Agreed</label>
          </div>
          <div class="form-check">
            <label class="form-check-label"><input type="radio" name="opinions[][weight]" value="2" id="opinions_0_weight_2" class="form-check-input"/> Not Agreed</label>
          </div>
        </fieldset>
      </form>
    XML
  }

  let(:checkbox_input) { <<-XML
    <form method="post" id="new_comment" action="/opinions/create" accept-charset="utf-8">
      <fieldset class="form-group">
        <input value="0" name="opinions[][public]" type="hidden"/>
        <div class="form-check">
          <label class="form-check-label"><input name="opinions[][public]" id="opinions_0_public" type="checkbox" value="1" class="form-check-input"/> Public?</label>
        </div>
      </fieldset>
    </form>
    XML
  }


  it "valid inital rendering" do
    form = Post::Contract::Show.new(model)
    form.prepopulate!(user: user)
    html = Post::Cell::ShowBootstrap4.new(form).()
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
    html = Post::Cell::ShowBootstrap4.new(form).()
    assert_xml_contain html, form_format
    assert_xml_contain html, nested_input_with_error
    assert_xml_contain html, submit_button
    assert_xml_equal html, new_form_with_errors
  end
end

