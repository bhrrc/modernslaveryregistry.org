Feature: List statements
  Statements are listed on the front page as well
  as on individual company pages.

  Scenario: List all statements
    Given the following statement have been registered:
      | company_name | statement_url                                   |
      | Cucumber Ltd | https://cucumber.io/anti-slavery-statement-2015 |
      | Banana Ltd   | https://banana.io/anti-slavery-statement        |
      | Cucumber Ltd | https://cucumber.io/anti-slavery-statement-2016 |
    Then Patricia should see 3 statements total
