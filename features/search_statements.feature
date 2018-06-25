Feature: Search statements

  Background:
    Given the following legislations exist:
      | Name  |
      | Act X |
      | Act Y |
    And the following statements have been submitted:
      | Company name | Subsidiary names | Statement URL          | Country        | Industry    | Verified by | Legislations | Published |
      | Cucumber Ltd | Cuke Labs        | https://cucumber.ltd/s | United Kingdom | Software    | Patricia    | Act X        | Yes       |
      | Banana Ltd   |                  | https://banana.io/s    | France         | Agriculture | Patricia    | Act X, Act Y | Yes       |
      | Cucumber Inc |                  | https://cucumber.inc/s | United States  | Retail      |             | Act Y        | No        |

  Scenario: Search by company name
    Given Joe is logged in
    When Joe searches for "cucumber"
    Then Joe should only see "Cucumber Inc, Cucumber Ltd" in the search results

  Scenario: Search by company name with misspelling
    Given Joe is logged in
    When Joe searches for "cucimber"
    Then Joe should only see "Cucumber Inc, Cucumber Ltd" in the search results

  Scenario: Search by subsidiary name
    Given Joe is logged in
    When Joe searches for "cuke"
    Then Joe should only see "Cucumber Ltd" in the search results

  Scenario: Filter by industry
    When Joe selects industry "Agriculture"
    Then Joe should only see "Banana Ltd" in the search results

  Scenario: Filter by legislations
    When Joe selects legislation "Act Y"
    Then Joe should only see "Banana Ltd" in the search results
    When Joe selects legislation "Act X, Act Y"
    Then Joe should only see "Banana Ltd, Cucumber Ltd" in the search results

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
