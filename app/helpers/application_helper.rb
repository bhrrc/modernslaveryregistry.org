module ApplicationHelper
  def title(text)
    content_for :title, text
  end

  def yes_no(bool)
    if bool.nil?
      content_tag :span, 'Unspecified', class: 'tag is-light'
    else
      content_tag :span, bool ? 'Yes' : 'No', class: "tag #{bool ? 'is-success' : 'is-danger'}"
    end
  end

  def yes_no_not_explicit(text)
    return content_tag :span, 'Unspecified', class: 'tag is-light' if text.nil?

    css_classes_by_text = {
      'Yes' => 'is-success',
      'No'  => 'is-danger',
      'Not explicit' => 'is-warning'
    }
    text = 'No' unless css_classes_by_text.key?(text)
    css_class = css_classes_by_text[text]
    content_tag :span, text, class: "tag #{css_class}"
  end

  def content_type_tag(content_type)
    if content_type.nil?
      content_tag :span, 'Unknown', class: 'tag is-light'
    elsif content_type =~ /html/
      content_tag :span, 'HTML', class: 'tag is-success'
    elsif content_type =~ /pdf/
      content_tag :span, 'PDF', class: 'tag is-warning'
    else
      content_tag :span, content_type, class: 'tag is-danger'
    end
  end

  def admin?
    current_user && current_user.admin?
  end

  def back_or_root
    request.referer.present? ? request.referer : root_path
  end

  def banner_page
    Page.include_drafts(admin?).as_list.find(&:banner?)
  end
end
