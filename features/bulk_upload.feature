Feature: Bulk upload
  In order to save time when adding many statements
  Admins are able to use a CSV file to add multiple statements quickly

  Scenario: Administrator bulk uploads statements
    Given Patricia is logged in
    When Patricia uploads a CSV with the following statements:
      | company_name | statement_url                              |
      | Cucumber Ltd | https://cucumber.io/anti-slavery-statement |
      | BigCorp      | https://bigcorp.com/anti-slavery-statement |
    Then Patricia should see 1 statement for "Cucumber Ltd" with:
      | Statement URL         | https://cucumber.io/anti-slavery-statement |
      | Signed by director    | No                                         |
      | Approved by board     | Unspecified                                |
      | Link on front page    | No                                         |

  Scenario: Administrator bulk uploads statements with legislation
    Given the following legislations exist:
      | Name                                         | Include in compliance stats? |
      | UK Modern Slavery Act                        | Yes                          |
      | California Transparency in Supply Chains Act | No                           |
    Given Patricia is logged in
    When Patricia uploads a CSV with the following statements:
      | company_name | statement_url                              | legislation                                  |
      | Cucumber Ltd | https://cucumber.io/anti-slavery-statement | UK Modern Slavery Act                        |
      | BigCorp      | https://bigcorp.com/anti-slavery-statement | California Transparency in Supply Chains Act |
    Then Patricia should see 1 statement for "Cucumber Ltd" with:
      | Statement URL      | https://cucumber.io/anti-slavery-statement |
      | Signed by director | No                                         |
      | Approved by board  | Unspecified                                |
      | Link on front page | No                                         |
      | Legislations       | UK Modern Slavery Act                      |

  Scenario: Administrator bulk uploads statements with some invalid URLs
    Given Patricia is logged in
    When Patricia uploads a CSV with the following statements:
      | company_name | statement_url                                 |
      | BigCorp      | https://bigcorp.com+%22msa%22&hl=en&tbs=qdr:m |
      | Cucumber Ltd | https://cucumber.io/anti-slavery-statement    |
    Then Patricia should see 1 statement for "Cucumber Ltd" with:
      | Statement URL         | https://cucumber.io/anti-slavery-statement |
      | Signed by director    | No                                         |
      | Approved by board     | Unspecified                                |
      | Link on front page    | No                                         |
