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
      'No' => 'is-danger',
      'Not explicit' => 'is-warning'
    }
    text = 'No' unless css_classes_by_text.key?(text)
    css_class = css_classes_by_text[text]
    content_tag :span, text, class: "tag #{css_class}"
  end

  def content_type_tag(content_type)
    if content_type.nil?
      content_tag :span, 'Unknown', class: 'tag is-light'
    elsif /html/.match?(content_type)
      content_tag :span, 'HTML', class: 'tag is-success'
    elsif /pdf/.match?(content_type)
      content_tag :span, 'PDF', class: 'tag is-warning'
    else
      content_tag :span, content_type, class: 'tag is-danger'
    end
  end

  def industry_tag(industry)
    if industry.blank?
      content_tag :span, 'unknown', class: 'tag is-warning'
    else
      content_tag :span, industry.name, class: 'tag'
    end
  end

  def legislation_name_list
    str = Legislation.pluck(:name).map { |name| content_tag :em, name }.join(' or ')
    sanitize(str, tags: ['em'])
  end

  def admin?
    current_user&.admin?
  end

  def back_or_root
    request.referer.presence || root_path
  end

  def cache_across_pages(name)
    last_changed = Page.last_changed
    Rails.cache.fetch("#{name}/#{last_changed.to_i}/#{admin?}", expires_in: 3.days) do
      return yield
    end
  end

  def header_nav_links
    cache_across_pages('header_nav') do
      all_pages.reject(&:banner?).select(&:header?).map do |page|
        [page.short_title, page_path(page)]
      end
    end
  end

  def footer_nav_links
    cache_across_pages('footer_nav') do
      all_pages.reject(&:banner?).select(&:footer?).map do |page|
        [page.short_title, page_path(page)]
      end
    end
  end

  def all_pages
    cache_across_pages('pages') do
      Page.include_drafts(admin?).as_list.to_a
    end
  end

  def banner_page
    all_pages.find(&:banner?)
  end

  def numbers_explained_page
    all_pages.find(&:numbers_explained?)
  end
end
