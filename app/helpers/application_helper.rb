module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge({sort: column, direction: direction}), { class: css_class }
  end

  def show_abstractor_group_all_links?
    false
  end

  def show_abstractor_all_links?
    false
  end

  def generate_index(page, i)
    ((page.to_i - 1) * 10) + i
  end
end