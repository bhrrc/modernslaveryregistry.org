Feature: Publish statement

  Anyone can _submit_ a statement, but only admins can _publish_ them.
  There are several ways to publish a statement:

  Scenario: Admin publishes a statement as it's submitted
    Given Patricia is logged in
    When Patricia submits the following statement:
      | company_name       | Cucumber Ltd                               |
      | country            | United Kingdom                             |
      | url                | https://cucumber.io/anti-slavery-statement |
      | signed_by_director | Yes                                        |
      | approved_by_board  | No                                         |
      | link_on_front_page | No                                         |
      | published          | Yes                                        |
    Then Patricia should see that the newest statement for "Cucumber Ltd" was verified by herself
    And Patricia should see that the newest statement for "Cucumber Ltd" was contributed by herself

  Scenario: Admin submits a draft statement without publishing it
    Given Patricia is logged in
    When Patricia submits the following statement:
      | company_name       | Cucumber Ltd                               |
      | country            | United Kingdom                             |
      | url                | https://cucumber.io/anti-slavery-statement |
      | signed_by_director | Yes                                        |
      | approved_by_board  | No                                         |
      | link_on_front_page | No                                         |
      | published          | No                                         |
    Then Patricia should see that the newest statement for "Cucumber Ltd" is not published
    And Patricia should see that the newest statement for "Cucumber Ltd" was not verified
    And Patricia should see that the newest statement for "Cucumber Ltd" was contributed by herself

  Scenario: Admin publishes a statement submitted by someone else
    When Vicky submits the following statement:
      | company_name       | Cucumber Ltd                               |
      | url                | https://cucumber.io/anti-slavery-statement |
      | contributor_email  | vicky@host.com                             |
    Given Patricia is logged in
    Then Patricia should see that the newest statement for "Cucumber Ltd" is not published
    And Patricia should see that the newest statement for "Cucumber Ltd" was not verified
    And Patricia should see that the newest statement for "Cucumber Ltd" was contributed by vicky@host.com

  Scenario: Admin deletes a statement
    When Vicky submits the following statement:
      | company_name       | Cucumber Ltd                               |
      | url                | https://cucumber.io/anti-slavery-statement |
      | contributor_email  | vicky@host.com                             |
    Given Patricia is logged in
    When Patricia deletes the statement for "Cucumber Ltd"
    Then Patricia should see that no statement for "Cucumber Ltd" exists
