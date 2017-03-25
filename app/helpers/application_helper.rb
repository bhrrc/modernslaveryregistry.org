module ApplicationHelper
  def yes_no(bool)
    content_tag :span, bool ? 'yes' : 'no', class: "tag #{bool ? 'is-success' : 'is-danger'}"
  end
end
