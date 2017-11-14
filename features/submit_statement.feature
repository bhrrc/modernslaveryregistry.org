Feature: Submit statement
  Statements are registered from a company page

  Scenario: Administrator submits statement for new company
    Given Patricia is logged in
    When Patricia submits the following statement:
      | company_name       | Cucumber Ltd                               |
      | country            | United Kingdom                             |
      | url                | https://cucumber.io/anti-slavery-statement |
      | signed_by_director | Yes                                        |
      | approved_by_board  | No                                         |
      | link_on_front_page | No                                         |
    Then Patricia should see 1 statement for "Cucumber Ltd" with:
      | url                | https://cucumber.io/anti-slavery-statement |
      | signed_by_director | Yes                                        |
      | approved_by_board  | No                                         |
      | link_on_front_page | No                                         |

  Scenario: Administrator submits statement for existing company
    Given the company "Cucumber Ltd" has been submitted
    And Patricia is logged in
    When Patricia submits the following statement for "Cucumber Ltd":
      | url                | https://cucumber.io/anti-slavery-statement |
      | signed_by_director | No                                         |
      | approved_by_board  | Not explicit                               |
      | link_on_front_page | Yes                                        |
    Then Patricia should see 1 statement for "Cucumber Ltd" with:
      | url                | https://cucumber.io/anti-slavery-statement |
      | signed_by_director | No                                         |
      | approved_by_board  | Not explicit                               |
      | link_on_front_page | Yes                                        |

  Scenario: Visitor submits statement for existing company
    Given the company "Featurist Ltd" has been submitted
    When Vicky submits the following statement for "Featurist Ltd":
      | url                | https://featurist.co.uk/anti-slavery-statement |
    Then Vicky should see a thank you message
    When Patricia is logged in
    Then Patricia should see 1 statement for "Featurist Ltd" with:
      | url                | https://featurist.co.uk/anti-slavery-statement |

  Scenario: Administrator edits existing statement
    Given Patricia is logged in
    And Patricia has submitted the following statement:
      | company_name       | Cucumber Ltd                               |
      | url                | https://cucumber.io/anti-slavery-statement |
      | signed_by_director | Yes                                        |
      | approved_by_board  | No                                         |
      | link_on_front_page | No                                         |
    When Patricia updates the statement for "Cucumber Ltd" to:
      | url                | https://cucumber.io/updated-statement      |
      | signed_by_director | No                                         |
      | approved_by_board  | Yes                                        |
      | link_on_front_page | Yes                                        |
    Then Patricia should see 1 statement for "Cucumber Ltd" with:
      | url                | https://cucumber.io/updated-statement      |
      | signed_by_director | No                                         |
      | approved_by_board  | Yes                                        |
      | link_on_front_page | Yes                                        |

  Scenario: Administrator submits statement with missing details
    Given the company "Cucumber Ltd" has been submitted
    And Patricia is logged in
    When Patricia submits the following statement for "Cucumber Ltd":
      | signed_by_director | No                                         |
      | approved_by_board  | Not explicit                               |
      | link_on_front_page | Yes                                        |
    Then Patricia should see that the statement was invalid and not saved
