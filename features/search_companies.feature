Feature: Search companies

  Background:
    Given the following statements have been submitted:
      | company_name | statement_url          | country        | sector      |
      | Cucumber Ltd | https://cucumber.ltd/s | United Kingdom | Software    |
      | Banana Ltd   | https://banana.io/s    | France         | Agriculture |
      | Cucumber Inc | https://cucumber.inc/s | United States  | Retail      |

  Scenario: Search by name
    When Joe searches for "cucumber"
    Then Joe should only see "Cucumber Ltd, Cucumber Inc" in the search results

  Scenario: Filter by sector
    When Joe selects sector "Agriculture"
    Then Joe should only see "Banana Ltd" in the search results
