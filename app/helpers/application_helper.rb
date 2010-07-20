# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def menu_selected(page_name,selected_name)
      page_name == selected_name ? 'selected' : nil
  end
end
