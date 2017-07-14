Feature: Amend pages
  Background: Logged in as admin
    Given Joe is logged in

  Scenario: Create page
    When Joe creates a new page
    And Joe visits the page
    Then Joe should see the new page on the website

  Scenario: Edit page
    When Joe edits an existing page
    And Joe visits the page
    Then Joe should see the updated page on the website

  Scenario: Publish page
    When Joe publishes a page
    And Vicky is logged in
    And Vicky visits the page
    Then Vicky should see the page on the website

  Scenario: Unpublish page
    When Joe unpublishes a page
    And Vicky is logged in
    And Vicky visits the page
    Then Vicky should not see the page on the website

  Scenario: Delete page
    When Joe deletes an existing page
    And Joe visits the page
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

  Scenario: Visitors can only see published pages in the menu
    Given the following pages exist:
      | title  | published |
      | Page A | yes       |
      | Page B | no        |
      | Page C | yes       |
    When Vicky is logged in
    Then Vicky should see the following pages on the website:
      | title  |
      | Page A |
      | Page C |

  Scenario: Visitors can only visit published pages
    Given the following pages exist:
      | title  | published |
      | Page A | no        |
    When Vicky is logged in
    And Vicky visits the page "Page A"
    Then Vicky should not see the page on the website
