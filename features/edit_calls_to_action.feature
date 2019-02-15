Feature: Edit Calls to Action
  Background: Logged in as admin
    Given Joe is logged in

  Scenario: Create a call to action
    When Joe creates a new call to action
    And Joe visits the homepage
    Then Joe should see the new call to action on the homepage

  Scenario: Edit a call to action
    When Joe edits an existing call to action
    And Joe visits the homepage
    Then Joe should see the updated call to action on the homepage

  Scenario: Delete a call to action
    When Joe deletes an existing call to action
    And Joe visits the homepage
    Then Joe should not see the deleted call to action on the homepage

  Scenario: Change the order of the calls to action
    When Joe changes the order of an existing call to action
    And Joe visits the homepage
    Then Joe should see the calls to action in the new order
