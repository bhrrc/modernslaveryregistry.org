@csv
Feature: CSV additional companies

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

  Scenario: Administrator exports to CSV
    Given Patricia is logged in
    When Patricia searches for "Cucumber Ltd"
    Then Patricia should only see "Cucumber Ltd" in the search results
    And Patricia clicks on "Download search results"
    Then a CSV file should be downloaded 
    And the filename should be "modernslaveryregistry-#{Time.zone.today}.csv"

  Scenario: Administrator exports to CSV with additional companies
