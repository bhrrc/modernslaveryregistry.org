Feature: Compliance stats
  Administrators can retrieve statistics about compliance

  Background:
    Given the following statements have been submitted:
      | Company name | Statement URL             | Date seen  | Link on front page | Signed by director | Approved by board |
      | Cucumber Ltd | https://cucumber.io/2015  | 2015-05-05 | Yes                | Yes                | Yes               |
      | Banana Ltd   | https://banana.io/2017    | 2017-01-01 | Yes                | Yes                | Yes               |
      | Cucumber Ltd | https://cucumber.io/2016  | 2016-06-06 | No                 | No                 | No                |
      | Potato Ltd   | https://potato.io/2017    | 2017-02-02 | Yes                | Yes                | No                |
    And Joe is logged in

  Scenario: Admin views minimum compliance stats
    When Joe views the compliance stats
    Then Joe should see the following stats:
      | Percent link on front page | 66% |
      | Percent signed by director | 66% |
      | Percent approved by board  | 33% |
      | Percent fully compliant    | 33% |
