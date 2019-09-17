Feature: Search statements

  Background:
    Given the following legislations exist:
      | Name  |
      | Act X |
      | Act Y |
    Given the following statements have been submitted:
      | Company name | Related companies | Statement URL          | Country        | Industry    | Verified by | Legislations | Published | Company number |
      | Cucumber Ltd | Cuke Labs         | https://cucumber.ltd/s | United Kingdom | Software    | Patricia    | Act X        | Yes       | 00123 |
      | Banana Ltd   |                   | https://banana.io/s    | France         | Agriculture | Patricia    | Act X, Act Y | Yes       | 769574 |
      | Cucumber Inc |                   | https://cucumber.inc/s | United States  | Retail      |             | Act Y        | No        | 967574 |
    And the company "Strawberries Ltd" has been submitted

  Scenario: Search by exact company name
    Given Joe is logged in
    When Joe searches for "cucumber ltd"
    Then Joe should only see "Cucumber Ltd" in the search results

  Scenario: Search by company name with 'limited' instead of 'ltd'
    Given Joe is logged in
    And a search alias from 'limited' to 'ltd' exists
    When Joe searches for "cucumber limited"
    Then Joe should only see "Cucumber Ltd" in the search results

  Scenario: Search by related company name
    Given Joe is logged in
    When Joe searches for "cuke"
    Then Joe should only see "Cucumber Ltd, Cuke Labs" in the search results

  Scenario: Search for company with no published statements
    Given Joe is logged in
    When Joe searches for "cucumber inc"
    Then Joe should only see "Cucumber Inc" in the search results

  Scenario: Filter by industry
    When Joe selects industry "Agriculture"
    Then Joe should only see "Banana Ltd" in the search results

  Scenario: Filter by country
    When Joe selects country "France"
    Then Joe should only see "Banana Ltd" in the search results

  Scenario: Submit statement links appear when a company has no statements
    When Joe visits the explore page
    Then Joe should see the following search results:
      | name             | country         | industry         | link_text        |
      | Banana Ltd       | France          | Agriculture      | 1 statement      |
      | Cucumber Inc     | United States   | Retail           | 0 statements     |
      | Cucumber Ltd     | United Kingdom  | Software         | 1 statement      |
      | Cuke Labs        | Country unknown | Industry unknown | 1 statement      |
      | Strawberries Ltd | United Kingdom  | Industry unknown | Submit statement |

  Scenario: Filter by legislation
    When Joe selects legislation "Act X"
    Then Joe should see the following search results:
      | name             | country         | industry         | link_text        |
      | Banana Ltd       | France          | Agriculture      | 1 statement      |
      | Cucumber Inc     | United States   | Retail           | 0 statements     |
      | Cucumber Ltd     | United Kingdom  | Software         | 1 statement      |
      | Cuke Labs        | Country unknown | Industry unknown | 0 statements     |
      | Strawberries Ltd | United Kingdom  | Industry unknown | Submit statement |

  Scenario: Download statements when not logged in as admin
    When Patricia downloads the full CSV
    Then Patricia should see all the published statements
