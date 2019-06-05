Feature: Publish statement

  Anyone can _submit_ a statement, but only admins can _publish_ them.
  There are several ways to publish a statement:

  Scenario: Admin publishes a statement as it's submitted
    Given Patricia is logged in
    When Patricia submits the following statement:
      | Company name       | Cucumber Ltd                               |
      | Related companies  | Gherkin Dudes, Cuke Labs                   |
      | Country            | United Kingdom                             |
      | Statement URL      | https://cucumber.io/anti-slavery-statement |
      | Period covered     | 2015-2017                                  |
      | Signed by director | Yes                                        |
      | Approved by board  | No                                         |
      | Link on front page | No                                         |
      | Published          | Yes                                        |
      | Company number     | 00123                                      |
    Then Patricia should see that the latest statement for "Cucumber Ltd" was verified by herself
    And Patricia should see that the latest statement for "Cucumber Ltd" was contributed by herself

  Scenario: Admin submits a draft statement without publishing it
    Given Patricia is logged in
    When Patricia submits the following statement:
      | Company name       | Cucumber Ltd                               |
      | Country            | United Kingdom                             |
      | Statement URL      | https://cucumber.io/anti-slavery-statement |
      | Signed by director | Yes                                        |
      | Approved by board  | No                                         |
      | Link on front page | No                                         |
      | Published          | No                                         |
      | Company number     | 00123                                      |
    Then Patricia should see that the latest statement for "Cucumber Ltd" is not published
    And Patricia should see that the latest statement for "Cucumber Ltd" was not verified
    And Patricia should see that the latest statement for "Cucumber Ltd" was contributed by herself

  Scenario: Admin publishes a statement submitted by someone else
    When Vicky submits the following statement:
      | Company name       | Cucumber Ltd                               |
      | Statement URL      | https://cucumber.io/anti-slavery-statement |
      | Contributor email  | vicky@host.com                             |
    Given Patricia is logged in
    Then Patricia should see that the latest statement for "Cucumber Ltd" is not published
    And Patricia should see that the latest statement for "Cucumber Ltd" was not verified
    And Patricia should see that the latest statement for "Cucumber Ltd" was contributed by "vicky@host.com"

  Scenario: Admin deletes a statement
    When Vicky submits the following statement:
      | Company name       | Cucumber Ltd                               |
      | Statement URL      | https://cucumber.io/anti-slavery-statement |
      | Contributor email  | vicky@host.com                             |
    Given Patricia is logged in
    When Patricia deletes the statement for "Cucumber Ltd"
    Then Patricia should see that no statement for "Cucumber Ltd" exists
