require 'test_helper'
require 'formular/helper'
require 'trailblazer/cell'
require 'cell/slim'
require 'reform'
require 'reform/form/dry'

class User::Cell
  class NewBootstrap3 < Trailblazer::Cell
    include Cell::Slim
    include Formular::Helper

    self.view_paths = ['test/doc/bootstrap3/concept']

    def show
      render view: :new
    end

  end
end


# basic form + password input, select input and file input
class TestNewUserBootstrap3 < Minitest::Spec
  let(:model) { User.new(1, "Luca", "Rossi", "Male", "01/01/1980", "luca@email.com", "password", "password", "image_path") }
  let(:new_form) { <<-XML
    <form id="new_user" enctype="multipart/form-data" action="/users" method="post" accept-charset="utf-8">
      <input name="utf8" type="hidden" value="✓"/>
      <div class="form-group">
        <input placeholder="Firstname" name="firstname" id="firstname" value="Luca" type="text" class="form-control"/>
      </div>
      <div class="form-group">
        <input placeholder="Lastname" name="lastname" id="lastname" value="Rossi" type="text" class="form-control"/>
      </div>
      <div class="form-group">
        <select name="gender" id="gender" class="form-control">
          <option value="Male" selected="selected">Male</option>
          <option value="Female">Female</option>
          <option value="You">You</option>
        </select>
      </div>
      <div class="form-group">
        <input placeholder="Date of birth:" name="dob" id="dob" value="01/01/1980" type="text" class="form-control"/>
      </div>
      <div class="form-group">
        <input placeholder="Email" name="email" id="email" value="luca@email.com" type="text" class="form-control"/>
      </div>
      <div class="form-group">
        <input placeholder="Password" type="password" name="password" id="password" class="form-control"/>
      </div>
      <div class="form-group">
        <input placeholder="Confirm Password" type="password" name="confirm_password" id="confirm_password" class="form-control"/>
      </div>
      <div class="form-group">
        <label for="avatar" class="control-label">Profile image</label>
        <input type="file" name="avatar" id="avatar" value="image_path"/>
      </div>
      <button class="btn btn-default" type="submit">Create User</button>
    </form>
    XML
  }

  let(:new_form_with_errors) { <<-XML
    <form id="new_user" enctype="multipart/form-data" action="/users" method="post" accept-charset="utf-8">
      <input name="utf8" type="hidden" value="✓"/>
      <div class="form-group">
        <input placeholder="Firstname" name="firstname" id="firstname" value="Luca" type="text" class="form-control"/>
      </div>
      <div class="form-group">
        <input placeholder="Lastname" name="lastname" id="lastname" value="Rossi" type="text" class="form-control"/>
      </div>
      <div class="form-group">
        <select name="gender" id="gender" class="form-control">
          <option value="Male" selected="selected">Male</option>
          <option value="Female">Female</option>
          <option value="You">You</option>
        </select>
      </div>
      <div class="form-group">
        <input placeholder="Date of birth:" name="dob" id="dob" value="01/01/1980" type="text" class="form-control"/>
      </div>
      <div class="form-group has-error">
        <input placeholder="Email" name="email" id="email" value="" type="text" class="form-control"/>
        <span class="help-block">must be filled</span>
      </div>
      <div class="form-group has-error">
        <input placeholder="Password" type="password" name="password" id="password" value="" class="form-control"/>
        <span class="help-block">must be filled</span>
      </div>
      <div class="form-group has-error">
        <input placeholder="Confirm Password" type="password" name="confirm_password" id="confirm_password" value="" class="form-control"/>
        <span class="help-block">must be filled</span>
      </div>
      <div class="form-group">
        <label for="avatar" class="control-label">Profile image</label>
        <input type="file" name="avatar" id="avatar" value="image_path"/>
      </div>
      <button class="btn btn-default" type="submit">Create User</button>
    </form>
    XML
  }

  let(:form_format) { <<-XML
     <form id="new_user" enctype="multipart/form-data" action="/users" method="post" accept-charset="utf-8">
      <input name="utf8" type="hidden" value="✓"/>
    </form>
    XML
  }

  let(:input_no_error) { <<-XML
     <form id="new_user" enctype="multipart/form-data" action="/users" method="post" accept-charset="utf-8">
      <div class="form-group">
        <input placeholder="Email" name="email" id="email" value="luca@email.com" type="text" class="form-control"/>
      </div>
    </form>
    XML
  }

  let(:input_with_error) { <<-XML
     <form id="new_user" enctype="multipart/form-data" action="/users" method="post" accept-charset="utf-8">
      <div class="form-group has-error">
        <input placeholder="Email" name="email" id="email" value="" type="text" class="form-control"/>
        <span class="help-block">must be filled</span>
      </div>
    </form>
    XML
  }

  let(:input_password_type) { <<-XML
     <form id="new_user" enctype="multipart/form-data" action="/users" method="post" accept-charset="utf-8">
      <div class="form-group">
        <input placeholder="Password" type="password" name="password" id="password" class="form-control"/>
      </div>
    </form>
    XML
  }

  let(:submit_button) { <<-XML
     <form id="new_user" enctype="multipart/form-data" action="/users" method="post" accept-charset="utf-8">
      <button class="btn btn-default" type="submit">Create User</button>
    </form>
    XML
  }

  let(:select_input) { <<-XML
    <form id="new_user" enctype="multipart/form-data" action="/users" method="post" accept-charset="utf-8">
      <div class="form-group">
        <select name="gender" id="gender" class="form-control">
          <option value="Male" selected="selected">Male</option>
          <option value="Female">Female</option>
          <option value="You">You</option>
        </select>
      </div>
    </form>
    XML
  }

    let(:input_file_type_with_label) { <<-XML
     <form id="new_user" enctype="multipart/form-data" action="/users" method="post" accept-charset="utf-8">
      <div class="form-group">
        <label for="avatar" class="control-label">Profile image</label>
        <input type="file" name="avatar" id="avatar" value="image_path"/>
      </div>
    </form>
    XML
  }



  it "valid inital rendering" do
    form = User::Contract::New.new(model)
    html = User::Cell::NewBootstrap3.new(form).()
    assert_xml_contain html, form_format
    assert_xml_contain html, input_no_error
    assert_not_xml_contain html, input_with_error
    assert_xml_contain html, input_password_type
    assert_xml_contain html, submit_button
    assert_xml_contain html, select_input
    assert_xml_contain html, input_file_type_with_label
    assert_xml_equal html, new_form
  end

  it "redering with errors" do
    form = User::Contract::New.new(model)
    form.validate(email: "", password: "", confirm_password: "")
    html = User::Cell::NewBootstrap3.new(form).()
    assert_xml_contain html, form_format
    assert_xml_contain html, input_with_error
    assert_not_xml_contain html, input_no_error
    assert_xml_contain html, submit_button
    assert_xml_equal html, new_form_with_errors
  end
end

