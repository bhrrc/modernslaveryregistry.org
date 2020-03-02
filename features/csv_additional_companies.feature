@csv
Feature: CSV additional companies

  Background:
    Given the following legislations exist:
      | Name  |
      | Act X |
      | Act Y |
    Given the following statements have been submitted:
      | Company name | Related companies | Statement URL               | Company number |
      | Cucumber Ltd | Cuke Labs,CukeHub | https://cucumber.ltd/s/2017 |             10 |
      | Banana Ltd   |                   | https://banana.io/s/2018    |             11 |
      | Cucumber Inc |                   | https://cucumber.inc/s/2018 |             12 |

  Scenario: Administrator exports to CSV
    Given Patricia is logged in
    When Patricia downloads the CSV for "Cucumber Ltd"
    Then the CSV should contain:
      | Company      | URL                          |
      | Cucumber Ltd | https://cucumber.ltd/s/2017  |
      | CukeHub      | https://cucumber.ltd/s/2017  |
      | Cuke Labs    | https://cucumber.ltd/s/2017  |

#  Scenario: Administrator exports to CSV with additional companies
