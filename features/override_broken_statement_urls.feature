Feature: Override Broken Statement URLs

  Scenario: Administrator marks broken URL as not broken
    Given a statement was submitted for "Cucumber Ltd" that responds with a 404
    And Patricia is logged in
    When Patricia marks the URL for "Cucumber Ltd" as not broken
    And Patricia views the latest snapshot of the statement for "Cucumber Ltd"
    Then Patricia should see a JPEG snapshot of the statement for "Cucumber Ltd"
