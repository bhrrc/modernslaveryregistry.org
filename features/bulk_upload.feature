Feature: Bulk upload
  In order to save time when adding many statements
  Admins are able to use a CSV file to add multiple statements quickly

  Scenario: Administrator bulk uploads statements
    Given Patricia is logged in
    When Patricia uploads a CSV with the following statements:
      | company_name  | country        | statement_url                               | published |
      | Cucumber Ltd  | United Kingdom | https://cucumber.io/anti-slavery-statement  | yes       |
      | BigCorp       | United Kingdom | https://bigcorp.com/anti-slavery-statement  | yes       |
    Then Patricia should see 1 statement for "Cucumber Ltd" with:
      | Statement URL         | https://cucumber.io/anti-slavery-statement |
      | Signed by director    | No                                         |
      | Approved by board     | Unspecified                                |
      | Link on front page    | No                                         |

  Scenario: Administrator bulk uploads statements with some invalid URLs
    Given Patricia is logged in
    When Patricia uploads a CSV with the following statements:
      | company_name  | country        | statement_url                                 | published |
      | BigCorp       | United Kingdom | https://bigcorp.com+%22msa%22&hl=en&tbs=qdr:m | yes       |
      | Cucumber Ltd  | United Kingdom | https://cucumber.io/anti-slavery-statement    | yes       |
    Then Patricia should see 1 statement for "Cucumber Ltd" with:
      | Statement URL         | https://cucumber.io/anti-slavery-statement |
      | Signed by director    | No                                         |
      | Approved by board     | Unspecified                                |
      | Link on front page    | No                                         |
