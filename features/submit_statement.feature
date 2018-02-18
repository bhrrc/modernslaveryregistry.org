Feature: Submit statement
  Statements are registered from a company page

  Scenario: Administrator submits statement for new company
    Given Patricia is logged in
    And the following legislations exist:
      | Name              | Requires statement attributes |
      | Green Edibles Act | approved_by_board             |
      | Vegetables Act    |                               |
    When Patricia submits the following statement:
      | Company name          | Cucumber Ltd                               |
      | Country               | United Kingdom                             |
      | Statement URL         | https://cucumber.io/anti-slavery-statement |
      | Signed by director    | Yes                                        |
      | Approved by board     | Not explicit                               |
      | Link on front page    | No                                         |
      | Legislations          | Green Edibles Act, Vegetables Act          |
      | Published             | Yes                                        |
      | Also covers companies | Gherkin Holdings                           |
    Then Patricia should see 1 statement for "Cucumber Ltd" with:
      | Statement URL         | https://cucumber.io/anti-slavery-statement |
      | Signed by director    | Yes                                        |
      | Approved by board     | Not explicit                               |
      | Link on front page    | No                                         |
      | Legislations          | Green Edibles Act, Vegetables Act          |
      | Also covers companies | Gherkin Holdings                           |

  Scenario: Administrator submits statement for existing company
    Given the company "Cucumber Ltd" has been submitted
    And Patricia is logged in
    When Patricia submits the following statement for "Cucumber Ltd":
      | Statement URL      | https://cucumber.io/anti-slavery-statement |
      | Signed by director | No                                         |
      | Approved by board  | Not explicit                               |
      | Link on front page | Yes                                        |
      | Published          | Yes                                        |
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
    When Patricia updates the statement for "Featurist Ltd" to:
      | Approved by board  | No                                             |
      | Published          | Yes                                            |
    Then Patricia should see 1 statement for "Featurist Ltd" with:
      | Statement URL      | https://featurist.co.uk/anti-slavery-statement |

  Scenario: Administrator edits existing statement
    Given Patricia is logged in
    And Patricia has submitted the following statement:
      | Company name          | Cucumber Ltd                               |
      | Statement URL         | https://cucumber.io/anti-slavery-statement |
      | Signed by director    | Yes                                        |
      | Approved by board     | No                                         |
      | Link on front page    | No                                         |
      | Published             | Yes                                        |
    When Patricia updates the statement for "Cucumber Ltd" to:
      | Statement URL         | https://cucumber.io/updated-statement      |
      | Signed by director    | No                                         |
      | Approved by board     | Yes                                        |
      | Link on front page    | Yes                                        |
      | Also covers companies | Gherkin Holdings                           |
    Then Patricia should see 1 statement for "Cucumber Ltd" with:
      | Statement URL         | https://cucumber.io/updated-statement      |
      | Signed by director    | No                                         |
      | Approved by board     | Yes                                        |
      | Link on front page    | Yes                                        |

  Scenario: Administrator publishes new statement with missing details
    Given the company "Cucumber Ltd" has been submitted
    And Patricia is logged in
    And the legislation "UK Modern Slavery Act" requires values for the following attributes:
      | Attribute          |
      | Signed by director |
      | Approved by board  |
      | Link on front page |
    When Patricia submits the following statement for "Cucumber Ltd":
      | Legislations       | UK Modern Slavery Act |
      | Published          | Yes                   |
    Then Patricia should see that the statement was not saved due to the following errors:
      | Message                           |
      | Url can't be blank                |
      | Link on front page can't be blank |
      | Approved by board can't be blank  |
      | Signed by director can't be blank |

  Scenario: Administrator publishes existing statement with missing details
    Given Patricia is logged in
    And Patricia has submitted the following statement:
      | Company name       | Cucumber Ltd                               |
      | Statement URL      | https://cucumber.io/anti-slavery-statement |
    And the legislation "UK Modern Slavery Act" requires values for the following attributes:
      | Attribute          |
      | Signed by director |
      | Approved by board  |
      | Link on front page |
    When Patricia updates the statement for "Cucumber Ltd" to:
    | Legislations       | UK Modern Slavery Act |
    | Published          | Yes                   |
    Then Patricia should see that the statement was not saved due to the following errors:
      | Message                           |
      | Link on front page can't be blank |
      | Approved by board can't be blank  |
      | Signed by director can't be blank |
