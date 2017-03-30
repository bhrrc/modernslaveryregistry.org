Feature: Search companies

  Background:
    Given the following statements have been submitted:
      | company_name | statement_url                               |
      | Cucumber Ltd | https://cucumber.ltd/anti-slavery-statement |
      | Banana Ltd   | https://banana.io/anti-slavery-statement    |
      | Cucumber Inc | https://cucumber.inc/anti-slavery-statement |

  Scenario: Find by fuzzy search
    When Joe searches for "cucumber"
    Then Joe should see 2 statements in the search results
