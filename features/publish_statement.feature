Feature: Publish statement

  Anyone can _submit_ a statement, but only admins can _publish_ them.
  There are several ways to publish a statement:

  Background:
    Given Patricia is logged in

  Scenario: Admin publishes a statement as it's submitted
    When Patricia submits the following statement:
      | company_name       | Cucumber Ltd                               |
      | country            | United Kingdom                             |
      | url                | https://cucumber.io/anti-slavery-statement |
      | signed_by_director | Yes                                        |
      | approved_by_board  | No                                         |
      | link_on_front_page | No                                         |
      | published          | Yes                                        |
    Then Patricia should see that the newest statement for "Cucumber Ltd" was verified by herself

  Scenario: Admin submits a draft statement without publishing it
    When Patricia submits the following statement:
      | company_name       | Cucumber Ltd                               |
      | country            | United Kingdom                             |
      | url                | https://cucumber.io/anti-slavery-statement |
      | signed_by_director | Yes                                        |
      | approved_by_board  | No                                         |
      | link_on_front_page | No                                         |
      | published          | No                                         |
    Then Patricia should see that the newest statement for "Cucumber Ltd" is not published
    Then Patricia should see that the newest statement for "Cucumber Ltd" was not verified

  Scenario: Admin publishes a statement submitted by someone else
