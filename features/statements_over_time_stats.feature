Feature: Statements over time stats

  # temporarily visible to admins only
  Scenario: Visitor sees cumulative total of published statements by month
    Given the following legislations exist:
      | Name                                         | Requires statement attributes |
      | UK Modern Slavery Act                        | approved_by_board             |
      | California Transparency in Supply Chains Act |                               |
    Given the following statements have been submitted:
      | Company name | Statement URL             | Industry    | Published |  Date seen | Legislations          |
      | Cucumber Ltd | https://cucumber.ltd/s    | Software    | Yes       | 2018-01-20 | UK Modern Slavery Act |
      | Banana Ltd   | https://banana.io/s       | Agriculture | No        | 2018-01-20 | UK Modern Slavery Act |
      | Cucumber Inc | https://cucumber.inc/s    | Retail      | Yes       | 2018-02-21 | UK Modern Slavery Act |
      | Cucumber Plc | https://cucumber.plc/2017 | Software    | Yes       | 2018-02-20 | UK Modern Slavery Act |
    When Joe is logged in
    And Joe views the stats of statements added by month
    Then Joe sees the following statements added by month:
      | label         | statements | uk_act | us_act |
      | January 2018  |          1 | 1      | 0      |
      | February 2018 |          3 | 2      | 0      |
