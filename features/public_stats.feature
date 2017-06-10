Feature: Public stats
  Anonymous visitors can see statistics about activity

  Scenario: Visitor sees counts of statements, countries and sectors
    Given the following statements have been submitted:
      | company_name | statement_url          | country        | sector      | published |
      | Cucumber Ltd | https://cucumber.ltd/s | United Kingdom | Software    | Yes       |
      | Banana Ltd   | https://banana.io/s    | France         | Agriculture | No        |
      | Cucumber Inc | https://cucumber.inc/s | United States  | Retail      | Yes       |
      | Cucumber Plc | https://cucumber.plc/s | United Kingdom | Software    | Yes       |
    When Vicky views the public stats
    Then Vicky should see the following public stats:
      | statements | 3 |
      | countries  | 2 |
      | sectors    | 2 |
