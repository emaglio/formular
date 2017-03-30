require 'test_helper'
require 'formular/builders/bootstrap4'
require 'formular/element/bootstrap4'

describe Formular::Element::Bootstrap4 do
  let(:builder) { Formular::Builders::Bootstrap4.new }
  let(:collection_array) { COLLECTION_ARRAY }

  describe Formular::Element::Bootstrap4::Input do
    # it '#to_s with value' do
    #   element = builder.input(:name, value: 'Joseph Smith')
    #   element.to_s.must_equal %(<fieldset class="form-group"><input value="Joseph Smith" name="name" id="name" type="text" class="form-control"/></fieldset>)
    # end

    it "tring this" do
      element = builder.help_block(error: "test")
      element.to_s.must_equal ""
      
    end
  end
end