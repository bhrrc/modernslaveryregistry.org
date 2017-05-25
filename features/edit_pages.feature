Feature: Amend pages
  Background: Logged in as admin
    Given Joe is logged in

  Scenario: Create new page
    When Joe creates a new page
    Then Joe should see the new page on the website

  Scenario: Edit existing page
    When Joe edits an existing page
    Then Joe should see the updated page on the website

  Scenario: Delete existing page
    When Joe deletes an existing page
    Then Joe should not see the deleted page on the website

  Scenario: Change menu order
    Given the following pages exist:
      | title  |
      | Page A |
      | Page B |
      | Page C |
    When Joe moves the page "Page A" down
    And Joe moves the page "Page C" up
    Then Joe should see the following menu on the website:
      | title  |
      | Page B |
      | Page C |
      | Page A |
