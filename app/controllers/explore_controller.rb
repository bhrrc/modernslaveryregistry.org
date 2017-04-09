class ExploreController < ApplicationController
  def index
    @companies = Company.search(params)

    sectors = Sector.with_companies.with_company_counts.order('company_count DESC')

    @section_chart_data = {
      labels: sectors.map(&:name),
      datasets: [
        {
          label: "Companies",
          # TODO: Use colors from design palette
          background_color: "rgba(66,244,226,0.2)",
          border_color: "rgba(220,220,220,1)",
          data: sectors.map(&:company_count)
        }
      ]
    }
  end
end
