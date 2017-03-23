Feature: Register company
  Every statement in the registry belongs to a company.
  Companies can have multiple statements, so they should
  be registered independently of their statements.

  Scenario: Register a new company
    Given Patricia has permission to register companies
    When Patricia registers company "Cucumber Ltd"
    Then Patricia should see company "Cucumber Ltd"
