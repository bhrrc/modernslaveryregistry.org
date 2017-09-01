Feature: Admin dashboard
  So the public site looks the same to everyone including administrators
  Administrators have a dedicated area for admin-specific functionality
  Which is not accessible to regular users

  Scenario: Logging in as admin
    When Joe logs in
    Then Joe should see the administrator dashboard

  Scenario: Logging in as a non-admin
    When Vicky logs in
    Then Vicky should see the home page

  Scenario: Non-admins attempts to visit admin area
    Given Vicky is logged in
    When Vicky visits the administrator dashboard
    Then Vicky should not see the administrator dashboard
