require "test_helper"
require "cells-slim"
require "cells-hamlit"

require "formular/frontend/foundation6"

require "reform"
require "reform/form/dry"



class Comment < Struct.new(:body, :replies, :uuid, :errors) # TODO: remove errors!
  class Form < Reform::Form
    include Dry::Validations

    property :body

    validation :default do
      key(:body, &:filled?)
    end

    collection :replies do
      property :email
    end
  end




  class NewCell < Cell::ViewModel
    include Cell::Slim
    # include Cell::Hamlit

    self.view_paths = ['test/fixtures']

    def show
      render
    end

    def form(model:nil, **options, &block)
      Formular::Foundation6::Builder.new(model: model).form(options, &block)
    end



  end
end

#@template=#<Erbse::Template:0x9aa53f8 @src="
# @output_buffer = output_buffer;
# @output_buffer.safe_append='New\n\n'.freeze;
# @output_buffer.append=  form model do |f|
# @output_buffer.safe_append='\n  ID for '.freeze;@output_buffer.append=( model.class );@output_buffer.safe_append=': '.freeze;@output_buffer.append=( f.input :id );@output_buffer.safe_append='\n'.freeze;   #raise \n end \n@output_buffer.safe_append='\n'.freeze; inner = capture do \n@output_buffer.safe_append='\n  '.freeze;@output_buffer.append=( self.class );@output_buffer.safe_append='\n'.freeze; end \n@output_buffer.to_s

class Cell::ViewModel
  module Capture
    # Only works with Slim, so far.
    def capture(*args)
      yield(*args)
    end
  end
end


class Form < Cell::ViewModel
  include Cell::Slim
  # include Cell::Hamlit
end

class Foundation6Test < Minitest::Spec
  Reply = Struct.new(:email, :errors)

  let (:model) { Comment.new("Nice!", [Reply.new]) }

  it { Comment::NewCell.new(model).().must_equal "<New></New><form action=\"/posts\">ID<input name=\"body\" type=\"text\" /><fieldset><input name=\"replies[email]\" type=\"text\" /></fieldset><input type=\"button\" value=\"Submit\" /><input name=\"uuid\" type=\"text\" value=\"0x\" /></form>" }


  describe "with errors" do
    let (:model) do
      Comment::Form.new(Comment.new(nil, []))
    end

    before { model.validate({}) }

    it do
      Comment::NewCell.new(model).().must_equal "<New></New><form action=\"/posts\">ID
<label class=\"error\">
<input class=\"error\" name=\"body\" type=\"text\" />
</label>
<small class=\"error\">[\"body must be filled\"]</small>
<input type=\"button\" value=\"Submit\" /><input name=\"uuid\" type=\"text\" value=\"0x\" /></form>".gsub("\n", "")
    end
  end
end