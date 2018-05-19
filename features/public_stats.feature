Feature: Public stats
  Anonymous visitors can see statistics about activity

  Scenario: Visitor sees counts of statements, companies and industries
    Given the following statements have been submitted:
      | Company name | Statement URL             | Industry     | Published |
      | Cucumber Ltd | https://cucumber.ltd/s    | Software     | Yes       |
      | Banana Ltd   | https://banana.io/s       | Agriculture  | No        |
      | Cucumber Inc | https://cucumber.inc/s    | Retail       | Yes       |
      | Cucumber Plc | https://cucumber.plc/2017 | Software     | Yes       |
      | Cucumber Plc | https://cucumber.plc/2018 | Software     | Yes       |
    When Vicky views the public stats
    Then Vicky should see the following public stats:
      | statements | 4 |
      | companies  | 3 |
      | industries | 2 |
