module WelcomeHelper
  # rubocop:disable Metrics/MethodLength
  def compliance_stats_explanation(compliance_stats, industry_id)
    industry = find_industry(industry_id)

    content_tag(:p) do
      a = ActiveSupport::SafeBuffer.new('These figures are based on the most recent ')
      if industry
        b = link_to("#{compliance_stats.total} statements", explore_path(industries: [industry_id]))
        c = " published by companies under the UK Modern Slavery Act in the #{industry.name} sector in our register."
      else
        b = link_to("#{compliance_stats.total} statements", explore_path)
        c = ' from all companies publishing under the UK Modern Slavery Act in our register.'
      end

      a + b + c
    end
  end
  # rubocop:enable Metrics/MethodLength

  def find_industry(industry_id)
    return false unless industry_id

    Industry.find(industry_id)
  rescue ActiveRecord::RecordNotFound
    false
  end
end
