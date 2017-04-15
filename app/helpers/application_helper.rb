module ApplicationHelper
  def yes_no(bool)
    if bool.nil?
      content_tag :span, 'Unspecified', class: "tag is-light"
    else
      content_tag :span, bool ? 'Yes' : 'No', class: "tag #{bool ? 'is-success' : 'is-danger'}"
    end
  end

  def yes_no_not_explicit(text)
    if text.nil?
      return content_tag :span, 'Unspecified', class: "tag is-light"
    end

    css_classes_by_text = {
      'Yes' => 'is-success',
      'No'  => 'is-danger',
      'Not explicit' => 'is-warning',
    }
    text = 'No' unless css_classes_by_text.has_key?(text)
    css_class = css_classes_by_text[text]
    content_tag :span, text, class: "tag #{css_class}"
  end

  def admin?
    current_user && current_user.admin?
  end

  def back_or_root
    request.referer.present? ? request.referer : root_path
  end
end
