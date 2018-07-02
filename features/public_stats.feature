Feature: Public stats
  Anonymous visitors can see statistics about activity

  Scenario: Visitor sees counts of statements, companies and industries
    Given the following legislations exist:
      | Name                                         | Include in compliance stats? |
      | UK Modern Slavery Act                        | Yes                          |
      | California Transparency in Supply Chains Act | No                           |
    Given the following statements have been submitted:
      | Company name | Statement URL             | Industry     | Published | Legislations                                 |
      | Cucumber Ltd | https://cucumber.ltd/s    | Software     | Yes       | UK Modern Slavery Act                        |
      | Banana Ltd   | https://banana.io/s       | Agriculture  | No        | California Transparency in Supply Chains Act |
      | Cucumber Inc | https://cucumber.inc/s    | Retail       | Yes       | UK Modern Slavery Act                        |
      | Cucumber Plc | https://cucumber.plc/2017 | Software     | Yes       | UK Modern Slavery Act                        |
      | Cucumber Plc | https://cucumber.plc/2018 | Software     | Yes       | California Transparency in Supply Chains Act |
    When Vicky views the public stats
    Then Vicky should see the following public stats:
      | uk_statements | 3 |
      | uk_companies  | 3 |
      | us_statements | 1 |
      | us_companies  | 1 |
