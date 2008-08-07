module RailsVendorHelper
  include PaypalHelper
  
  def show_code_link
    link_to_function "Show Code", "toggle_code_div(this)", :class => "show_code_link"
  end
end
