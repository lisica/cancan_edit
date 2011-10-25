class ActionView::Helpers::FormBuilder
  (field_helpers - %w(label check_box radio_button fields_for hidden_field apply_form_for_options!)).each do |selector|
    class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
      def #{selector}_with_cancan(method, options = {}) 
        options.merge!({:disabled => true}) unless (@template.can_edit? method.to_sym, @object)
        #{selector}_without_cancan(method, options)       
      end
    RUBY_EVAL
  alias_method_chain selector.to_sym, :cancan
  end
  
  def check_box_with_cancan(method, options = {}, checked_value = "1", unchecked_value = "0")
    options.merge!({:disabled => true}) unless (@template.can_edit? method.to_sym, @object) 
    check_box_without_cancan(method, options, checked_value = "1", unchecked_value = "0")
  end
  alias_method_chain :check_box, :cancan

  def radio_button_with_cancan(method, tag_value, options = {})
    options.merge!({:disabled => true}) unless (@template.can_edit? method.to_sym, @object)
    radio_button_without_cancan(method, tag_value, options)    
  end
  alias_method_chain :radio_button, :cancan
end

# password_field
# file_field
# number_field
# text_field
# text_area
# telephone_field
# email_field
# search_field
# range_field
# url_field
# phone_field
# check_box
# radio_button

