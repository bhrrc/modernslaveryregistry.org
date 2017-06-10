module Admin
  class DashboardController < AdminController
    def show
      @total = 0
      @stats = { approved_by_board: 0, link_on_front_page: 0, signed_by_director: 0, fully_compliant: 0 }
      Statement.latest.to_a.map do |s|
        @stats[:approved_by_board] += 1 if s.approved_by_board == 'Yes'
        @stats[:link_on_front_page] += 1 if s.link_on_front_page?
        @stats[:signed_by_director] += 1 if s.signed_by_director?
        @stats[:fully_compliant] += 1 if s.fully_compliant?
        @total += 1
      end
    end
  end
end
