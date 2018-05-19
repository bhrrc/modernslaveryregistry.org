Feature: Statements over time stats

  # temporarily visible to admins only
  Scenario: Visitor sees cumulative total of published statements by month
    Given the following statements have been submitted:
      | Company name | Statement URL             | Industry    | Published | Date seen  |
      | Cucumber Ltd | https://cucumber.ltd/s    | Software    | Yes       | 2018-01-20 |
      | Banana Ltd   | https://banana.io/s       | Agriculture | No        | 2018-01-20 |
      | Cucumber Inc | https://cucumber.inc/s    | Retail      | Yes       | 2018-02-21 |
      | Cucumber Plc | https://cucumber.plc/2017 | Software    | Yes       | 2018-02-20 |
    When Joe is logged in
    And Joe views the stats of statements added by month
    Then Joe sees the following statements added by month:
      | Month         | Statements |
      | January 2018  | 1          |
      | February 2018 | 3          |
