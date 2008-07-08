# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def fmt_money(m)
    number_with_precision(m,2)
  end
end
