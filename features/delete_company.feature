Feature: Delete Company

  Scenario: Deleting a company with no statements
    Given the company "Sausage Ltd" has been submitted
    And Patricia is logged in
    When Patricia deletes the company "Sausage Ltd"
    Then Patricia should find no company called "Sausage Ltd" exists
