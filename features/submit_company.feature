Feature: Submit company
  Every statement in the registry belongs to a company,
  and a company can have multiple statements, typically
  one for each financial year.

  Before submitting a statement, the company must exist,
  so we offer a way to submit companies independently.

  The system may contain a large number of companies
  without statements. Those companies may be imported
  from a list of company names obtained elsewhere.

  Scenario: Submit a new company
    When Patricia submits company "Cucumber Ltd"
    Then Patricia should see company "Cucumber Ltd"
