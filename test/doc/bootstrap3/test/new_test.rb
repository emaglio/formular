require 'test_helper'
require 'formular/helper'
require 'trailblazer/cell'
require 'cell/slim'
require 'reform'
require 'reform/form/dry'

class User::Cell
  class New < Trailblazer::Cell
    include Cell::Slim
    include Formular::Helper

    self.view_paths = ['test/doc/bootstrap3/concept']

    def show
      render view: :new
    end

  end
end


module User::Contract
  class New < Reform::Form
    feature Reform::Form::Dry

    property :email
    property :firstname
    property :lastname
    property :password, virtual: true
    property :confirm_password, virtual: true

    validation with: {form: true} do

      required(:email).filled
      required(:password).filled
      required(:confirm_password).filled
    end

  end
end

class TestNew < Minitest::Spec
  let(:model) { User.new(1, "Luca", "Rossi", "luca@email.com", "password", "password") }

  it "valid inital rendering" do
    form = User::Contract::New.new(model)
    User::Cell::New.new(form).().must_equal "<h1>New User</h1><form id=\"new_user\" action=\"/users\" method=\"post\" accept-charset=\"utf-8\"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/>"+
                                            "<div class=\"form-group\"><input placeholder=\"Firstname\" name=\"firstname\" id=\"firstname\" value=\"Luca\" type=\"text\" class=\"form-control\"/></div>"+
                                            "<div class=\"form-group\"><input placeholder=\"Lastname\" name=\"lastname\" id=\"lastname\" value=\"Rossi\" type=\"text\" class=\"form-control\"/></div>"+
                                            "<div class=\"form-group\"><input placeholder=\"Email\" name=\"email\" id=\"email\" value=\"luca@email.com\" type=\"text\" class=\"form-control\"/></div>"+
                                            "<div class=\"form-group\"><input placeholder=\"Password\" type=\"password\" name=\"password\" id=\"password\" class=\"form-control\"/></div>"+
                                            "<div class=\"form-group\"><input placeholder=\"Confirm Password\" type=\"password\" name=\"confirm_password\" id=\"confirm_password\" class=\"form-control\"/></div>"+
                                            "<button class=\"btn btn-default\" type=\"submit\"></button></form>"
  end

  it "redering with errors" do
    form = User::Contract::New.new(model)
    form.validate(email: "", password: "", confirm_password: "")
    User::Cell::New.new(form).().must_equal "<h1>New User</h1><form id=\"new_user\" action=\"/users\" method=\"post\" accept-charset=\"utf-8\"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/>"+
                                            "<div class=\"form-group\"><input placeholder=\"Firstname\" name=\"firstname\" id=\"firstname\" value=\"Luca\" type=\"text\" class=\"form-control\"/></div>"+
                                            "<div class=\"form-group\"><input placeholder=\"Lastname\" name=\"lastname\" id=\"lastname\" value=\"Rossi\" type=\"text\" class=\"form-control\"/></div>"+
                                            "<div class=\"form-group has-error\">"+
                                              "<input placeholder=\"Email\" name=\"email\" id=\"email\" value=\"\" type=\"text\" class=\"form-control\"/>"+
                                              "<span class=\"help-block\">must be filled</span>"+
                                            "</div>"+
                                            "<div class=\"form-group has-error\">"+
                                              "<input placeholder=\"Password\" type=\"password\" name=\"password\" id=\"password\" value=\"\" class=\"form-control\"/>"+
                                              "<span class=\"help-block\">must be filled</span>"+
                                            "</div>"+
                                            "<div class=\"form-group has-error\">"+
                                              "<input placeholder=\"Confirm Password\" type=\"password\" name=\"confirm_password\" id=\"confirm_password\" value=\"\" class=\"form-control\"/>"+
                                              "<span class=\"help-block\">must be filled</span>"+
                                            "</div>"+
                                            "<button class=\"btn btn-default\" type=\"submit\"></button></form>"

  end
end

