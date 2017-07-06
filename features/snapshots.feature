Feature: Snapshots

  Background: Logged in as admin (for now)
    Given Patricia is logged in

  Scenario: Snapshot of PDF statement
    Given a statement was submitted for "Cucumber Ltd" that responds with PDF
    When Patricia views the latest snapshot of the statement for "Cucumber Ltd"
    Then Patricia should see a PDF snapshot of the statement for "Cucumber Ltd"

  Scenario: Snapshot of HTML statement
    Given a statement was submitted for "Cucumber Ltd" that responds with HTML
    When Patricia views the latest snapshot of the statement for "Cucumber Ltd"
    Then Patricia should see a PNG snapshot of the statement for "Cucumber Ltd"
