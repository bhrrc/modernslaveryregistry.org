Feature: List statements
  Statements are listed on the explore page as well
  as on individual company pages.

  Background:
    Given the following statements have been submitted:
      | company_name | statement_url                                   | date_seen  |
      | Cucumber Ltd | https://cucumber.io/anti-slavery-statement-2015 | 2015-05-05 |
      | Banana Ltd   | https://banana.io/anti-slavery-statement        | 2017-01-01 |
      | Cucumber Ltd | https://cucumber.io/anti-slavery-statement-2016 | 2016-06-06 |

  Scenario: List all statements by one company
    When Patricia finds all statements by "Cucumber Ltd"
    Then Patricia should see the following statements:
      | date_seen  |
      | 2016-06-06 |
      | 2015-05-05 |
