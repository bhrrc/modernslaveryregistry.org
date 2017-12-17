Feature: List statements
  Statements are listed on the explore page as well
  as on individual company pages.

  Background:
    Given the following statements have been submitted:
      | Company name | Statement URL                                   | Period covered |
      | Cucumber Ltd | https://cucumber.io/anti-slavery-statement-2015 | 2015-2016      |
      | Banana Ltd   | https://banana.io/anti-slavery-statement        | 2011-2012      |
      | Cucumber Ltd | https://cucumber.io/anti-slavery-statement-2016 | 2016-2017      |

  Scenario: List all statements by one company
    When Patricia finds all statements by "Cucumber Ltd"
    Then Patricia should see the following statements:
      | Period covered |
      | 2016-2017      |
      | 2015-2016      |
