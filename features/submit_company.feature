Feature: Submit company
  Every statement in the registry belongs to a company,
  and a company can have multiple statements, typically
  one for each financial year.

  Before submitting a statement, the company must exist,
  so we offer a way to submit companies independently.

  The system may contain a large number of companies
  without statements. Those companies may be imported
  from a list of company names obtained elsewhere.

  Scenario: Administrator submits a new company
    Given Patricia is logged in
    When Patricia submits the following company:
      | Company name   | Cucumber Ltd                     |
      | Company HQ     | United Kingdom                   |
      | Industry       | Software                         |
      | Statement URL  | http://cucumber.io/msa-statement |
      | Period Covered | 2016-2017                        |
      | Company number | 00123                            |

    Then Patricia should find company "Cucumber Ltd" in the admin interface with:
      | Industry      | Software                         |
    And Patricia should see 1 statement for "Cucumber Ltd" with:
      | Statement URL      | http://cucumber.io/msa-statement |
      | Period Covered     | 2016-2017                        |
    And Patricia should not receive a thank you for submitting email

  Scenario: Administrator submits a new company as a visitor
    Given Patricia is logged in
    When Patricia submits the following company as a visitor:
      | Company name   | Cucumber Ltd                     |
      | Company HQ     | United Kingdom                   |
      | Industry       | Software                         |
      | Statement URL  | http://cucumber.io/msa-statement |
      | Period Covered | 2016-2017                        |
      | Company number | 00123                            |

  Scenario: Visitor submits a new company
    When Vicky submits the following company:
      | Company name  | Cucumber Ltd                     |
      | Statement URL | http://cucumber.io/msa-statement |
      | Your email    | vicky@somewhere.com              |
    And Patricia is logged in
    Then Patricia should find company "Cucumber Ltd" in the admin interface
    And "vicky@somewhere.com" should receive a thank you for submitting email
