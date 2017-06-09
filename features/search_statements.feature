Feature: Search statements

  Background:
    Given the following statements have been submitted:
      | company_name | statement_url          | country        | sector      | verified_by | contributor_email |
      | Cucumber Ltd | https://cucumber.ltd/s | United Kingdom | Software    | Patricia    |                   |
      | Banana Ltd   | https://banana.io/s    | France         | Agriculture | Patricia    |                   |
      | Cucumber Inc | https://cucumber.inc/s | United States  | Retail      |             | bob@host.com      |

  Scenario: Search by company name
    Given Joe is logged in
    When Joe searches for "cucumber"
    Then Joe should only see "Cucumber Ltd, Cucumber Inc" in the search results

  Scenario: Filter by sector
    When Joe selects sector "Agriculture"
    Then Joe should only see "Banana Ltd" in the search results

  Scenario: Only admins can see draft statements
    When Joe searches for "cucumber"
    Then Joe should only see "Cucumber Ltd" in the search results

  Scenario: Download statements when not logged in as admin
    When Patricia downloads all statements
    Then Patricia should see all the published statements

  Scenario: Download statements when logged in as admin
    Given Patricia is logged in
    When Patricia downloads all statements
    Then Patricia should see all the statements including drafts