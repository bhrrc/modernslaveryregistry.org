Feature: User admin
  Administrators can manage users

  Background: Logged in as admin, user accounts exist
    Given Patricia is logged in
    And Vicky has a user account

  Scenario: Search users
    When Patricia searches users
    Then Patricia should see Patricia and Vicky

  Scenario: Make user into administrator
    When Patricia makes Vicky an administrator
    Then Vicky should have admin access

  Scenario: Make user into non-administrator
    When Patricia makes Vicky a non-administrator
    Then Vicky should not have admin access
