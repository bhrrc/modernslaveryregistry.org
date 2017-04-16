Feature: Submit statement
  Statements are registered from a company page

  Scenario: Submit statement for existing company
    Given company "Cucumber Ltd" has been submitted
    And Patricia is logged in
    When Patricia submits the following statement for "Cucumber Ltd":
      | url                | https://cucumber.io/anti-slavery-statement |
      | signed_by_director | No                                         |
      | approved_by_board  | Not explicit                               |
      | link_on_front_page | Yes                                        |
    Then Patricia should see 1 statement for "Cucumber Ltd"

  Scenario: Submit statement for new company
    Given Patricia is logged in
    When Patricia submits the following statement:
      | company_name       | Cucumber Ltd                               |
      | country            | United Kingdom                             |
      | url                | https://cucumber.io/anti-slavery-statement |
      | signed_by_director | Yes                                        |
      | approved_by_board  | No                                         |
      | link_on_front_page | No                                         |
    Then Patricia should see 1 statement for "Cucumber Ltd"

  Scenario: Edit existing statement
    Given Patricia is logged in
    Given Patricia has submitted the following statement:
      | company_name       | Cucumber Ltd                               |
      | country            | United Kingdom                             |
      | url                | https://cucumber.io/anti-slavery-statement |
      | signed_by_director | Yes                                        |
      | approved_by_board  | No                                         |
      | link_on_front_page | No                                         |
    When Patricia updates the statement for "Cucumber Ltd" to:
      | company_name       | Cucumber Limited                           |
    Then Patricia should see 1 statement for "Cucumber Limited"
