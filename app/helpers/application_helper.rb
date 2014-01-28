module ApplicationHelper
  def page_title
    (@page_title.blank?) ? "Oh Hey World" : @page_title
  end
  
  def close_location_label(person_current_location, person)
    content_tag(:span, "#{person_current_location.name}") if person_current_location && (!@current_user_location || person_current_location.city_name != @current_user_location.location.city_name)
  end
  
  def standard_display_date(value)
    value.strftime("%m/%d/%Y")
  end
end
