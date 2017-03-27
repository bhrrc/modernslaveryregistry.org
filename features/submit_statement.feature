Feature: Register statement
  Statements are registered from a company page

  Scenario: Submit statement for existing company
    Given company "Cucumber Ltd" has been submitted
    When Patricia submits the following statement for "Cucumber Ltd":
      | url                | https://cucumber.io/anti-slavery-statement |
      | signed_by_director | no                                         |
      | approved_by_board  | yes                                        |
      | link_on_front_page | no                                         |
    Then Patricia should see 1 statement for "Cucumber Ltd"

  @javascripx
  Scenario: Submit statement for new company
    When Patricia submits the following statement:
      | company_name       | Cucumber Ltd                               |
      | url                | https://cucumber.io/anti-slavery-statement |
      | signed_by_director | no                                         |
      | approved_by_board  | yes                                        |
      | link_on_front_page | no                                         |
    Then Patricia should see 1 statement for "Cucumber Ltd"
