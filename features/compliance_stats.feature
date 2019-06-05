Feature: Compliance stats
  Administrators can retrieve statistics about compliance

  Background:
    Given the following legislations exist:
      | Name   | Include in compliance stats? |
      | Act X  | Yes                          |
      | Act Y  | No                           |
    And Joe is logged in

  Scenario: Admin views minimum compliance stats
    Given the following statements have been submitted:
      | Company name | Statement URL     |  Date seen | Link on front page | Signed by director | Approved by board | Legislations | Published | Company number |
      | A Ltd        | https://a.io/2015 | 2015-05-05 | Yes                | Yes                | Yes               | Act X        | true      | 11223 |
      | B Ltd        | https://b.io/2017 | 2017-01-01 | Yes                | Yes                | Yes               | Act X        | true      | 11233 |
      | A Ltd        | https://a.io/2016 | 2016-06-06 | No                 | No                 | No                | Act X        | true      | 11223 |
      | C Ltd        | https://c.io/2017 | 2017-02-02 | Yes                | Yes                | No                | Act X, Act Y | true      | 11523 |
      | D Ltd        | https://d.io/2017 | 2017-02-02 | Yes                | Yes                | Yes               | Act Y        | true      | 11623 |
    When Joe views the compliance stats
    Then Joe should see the following stats:
      | Percent link on front page | 66% |
      | Percent signed by director | 66% |
      | Percent approved by board  | 33% |
      | Percent fully compliant    | 33% |

  Scenario: The latest published statement is under an act excluded from the compliance stats
    Given the following statements have been submitted:
      | Company name | Statement URL     |  Date seen | Link on front page | Signed by director | Approved by board | Legislations | Published | Company number |
      | A Ltd        | https://a.io/2015 | 2015-05-05 | Yes                | Yes                | Yes               | Act X        | true      | 11223 |
      | A Ltd        | https://a.io/2016 | 2016-06-06 | No                 | No                 | No                | Act Y        | true      | 11223 |
    When Joe views the compliance stats
    Then Joe should see the following stats:
      | Percent link on front page | 100% |
      | Percent signed by director | 100% |
      | Percent approved by board  | 100% |
      | Percent fully compliant    | 100% |
