Feature: Compliance stats
  Administrators can retrieve statistics about compliance

  Background:
    Given the following statements have been submitted:
      | company_name | statement_url             | date_seen  | link_on_front_page | signed_by_director | approved_by_board |
      | Cucumber Ltd | https://cucumber.io/2015  | 2015-05-05 | Yes                | Yes                | Yes               |
      | Banana Ltd   | https://banana.io/2017    | 2017-01-01 | Yes                | Yes                | Yes               |
      | Cucumber Ltd | https://cucumber.io/2016  | 2016-06-06 | No                 | No                 | No                |
      | Potato Ltd   | https://potato.io/2017    | 2017-02-02 | Yes                | Yes                | No                |
    And Joe is logged in

  Scenario: Admin views minimum compliance stats
    When Joe views the compliance stats
    Then Joe should see the following stats:
      | percent_link_on_front_page | 66% |
      | percent_signed_by_director | 66% |
      | percent_approved_by_board  | 33% |
      | percent_fully_compliant    | 33% |
