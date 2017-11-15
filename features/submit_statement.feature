Feature: Submit statement
  Statements are registered from a company page

  Scenario: Administrator submits statement for new company
    Given Patricia is logged in
    When Patricia submits the following statement:
      | Company name       | Cucumber Ltd                               |
      | Country            | United Kingdom                             |
      | Statement URL      | https://cucumber.io/anti-slavery-statement |
      | Signed by director | Yes                                        |
      | Approved by board  | No                                         |
      | Link on front page | No                                         |
    Then Patricia should see 1 statement for "Cucumber Ltd" with:
      | Statement URL      | https://cucumber.io/anti-slavery-statement |
      | Signed by director | Yes                                        |
      | Approved by board  | No                                         |
      | Link on front page | No                                         |

  Scenario: Administrator submits statement for existing company
    Given the company "Cucumber Ltd" has been submitted
    And Patricia is logged in
    When Patricia submits the following statement for "Cucumber Ltd":
      | Statement URL      | https://cucumber.io/anti-slavery-statement |
      | Signed by director | No                                         |
      | Approved by board  | Not explicit                               |
      | Link on front page | Yes                                        |
    Then Patricia should see 1 statement for "Cucumber Ltd" with:
      | Statement URL      | https://cucumber.io/anti-slavery-statement |
      | Signed by director | No                                         |
      | Approved by board  | Not explicit                               |
      | Link on front page | Yes                                        |

  Scenario: Visitor submits statement for existing company
    Given the company "Featurist Ltd" has been submitted
    When Vicky submits the following statement for "Featurist Ltd":
      | Statement URL      | https://featurist.co.uk/anti-slavery-statement |
    Then Vicky should see a thank you message
    When Patricia is logged in
    Then Patricia should see 1 statement for "Featurist Ltd" with:
      | Statement URL      | https://featurist.co.uk/anti-slavery-statement |

  Scenario: Administrator edits existing statement
    Given Patricia is logged in
    And Patricia has submitted the following statement:
      | Company name       | Cucumber Ltd                               |
      | Statement URL      | https://cucumber.io/anti-slavery-statement |
      | Signed by director | Yes                                        |
      | Approved by board  | No                                         |
      | Link on front page | No                                         |
    When Patricia updates the statement for "Cucumber Ltd" to:
      | Statement URL      | https://cucumber.io/updated-statement      |
      | Signed by director | No                                         |
      | Approved by board  | Yes                                        |
      | Link on front page | Yes                                        |
    Then Patricia should see 1 statement for "Cucumber Ltd" with:
      | Statement URL      | https://cucumber.io/updated-statement      |
      | Signed by director | No                                         |
      | Approved by board  | Yes                                        |
      | Link on front page | Yes                                        |

  Scenario: Administrator submits statement with missing details
    Given the company "Cucumber Ltd" has been submitted
    And Patricia is logged in
    When Patricia submits the following statement for "Cucumber Ltd":
      | Signed by director | No                                         |
      | Approved by board  | Not explicit                               |
      | Link on front page | Yes                                        |
    Then Patricia should see that the statement was invalid and not saved
