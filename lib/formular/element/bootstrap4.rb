require 'formular/element'
require 'formular/elements'
require 'formular/element/modules/wrapped_control'
require 'formular/element/module'
require 'formular/element/bootstrap4/checkable_control'
require 'formular/element/bootstrap4/custom_control'
require 'formular/element/bootstrap3/column_control'

module Formular
  class Element
    module Bootstrap4
      include CheckableControl
      include CustomControl

      class Submit < Formular::Element::Button
        set_default :class, ['btn', 'btn-secondary']
        set_default :type, 'submit'
      end # class Submit

      class ErrorIcon < Formular::Element::ErrorIcon
        tag :span
        set_default :class, ['form-control-feedback']
      end # class ErrorIcon

      class Hint < Formular::Element::Small
        set_default :class, ['text-muted']
      end # class Hint

      class Input < Formular::Element::Input
        include Formular::Element::Modules::WrappedControl
        include Formular::Element::Bootstrap3::ColumnControl

        set_default :class, :input_class

        def input_class
          attributes[:type].to_s == 'file' ? %(form-control-file) : %(form-control)
        end
      end # class Input

      class Wrapper < Formular::Element::Fieldset
        set_default :class, ['form-group']
      end # class Wrapper

      class ErrorWrapper < Formular::Element::Fieldset
        set_default :class, ['form-group', 'has-feedback', 'has-error', 'has-danger']
      end # class Wrapper

      class HelpBlock < Formular::Element::HelpBlock
        tag :div
        set_default :class, ['help-block', 'with-errors']
      end #class HelpBlock

      class ListErrors < Formular::Element::ListErrors
        tag :ul
        set_default :class, ['list-unstyled', 'h6', 'text-left']
      end #class ListErros

      class ErrorText < Formular::Element::ErrorText
        tag :li
      end # class ErrorText

      class Error < Formular::Element::Error
      end# class Error

    end # module Bootstrap3
  end # class Element
end # module Formular
