# This file is part of Moodle - http://moodle.org/
#
# Moodle is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Moodle is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Moodle.  If not, see <http://www.gnu.org/licenses/>.
#
# Tests for toggle course section visibility in non edit mode in snap.
#
# @package    theme_snap
# @autor      Rafael Monterroza rafael.monterroza@blackboard.com
# @copyright  Copyright (c) 2019 Blackboard Inc. (http://www.blackboard.com)
# @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later


@theme @theme_snap @snap_message @javascript
Feature: Snap message send messages
  As a user
  I need to be able to send a message

  Background:
    Given the following "courses" exist:
      | fullname | shortname | category | groupmode |
      | Course 1 | C1        | 0        | 1         |
    And the following "users" exist:
      | username | firstname | lastname | email                |
      | student1 | Student   | 1        | student1@example.com |
      | student2 | Student   | 2        | student2@example.com |
    And the following "course enrolments" exist:
      | user     | course | role |
      | student1 | C1     | student |
      | student2 | C1     | student |
    And the following "groups" exist:
      | name    | course | idnumber | enablemessaging |
      | Group 1 | C1     | G1       | 1               |
    And the following "group members" exist:
      | user     | group |
      | student1 | G1 |
      | student2 | G1 |
    And the following config values are set as admin:
      | messaging        | 1 |
      | messagingminpoll | 1 |

  Scenario: Send a message to a group conversation in snap
    Given I log in as "student1"
    And I am on site homepage
    And I click on ".js-snap-pm-trigger.snap-my-courses-menu" "css_element"
    And I follow "View my messages"
    And I click on "//span[contains(text(),\"Group\")]" "xpath_element"
    And "Group 1" "group_message" should exist
    And I select "Group 1" conversation in messaging
    When I send "Hi!" message in the message area
    Then I should see "Hi!" in the ".message.clickable[data-region='message']" "css_element"
    And I log out
    And I log in as "student2"
    And I am on site homepage
    And I click on ".js-snap-pm-trigger.snap-my-courses-menu" "css_element"
    And I follow "View my messages"
    And "Group 1" "group_message" should exist
    And I select "Group 1" conversation in messaging
    Then I should see "Hi!" in the ".message.clickable[data-region='message']" "css_element"

  Scenario: Send a message to a starred conversation in snap
    Given I log in as "student1"
    And I am on site homepage
    And I click on ".js-snap-pm-trigger.snap-my-courses-menu" "css_element"
    And I follow "View my messages"
    And I click on "//span[contains(text(),\"Group\")]" "xpath_element"
    Then "Group 1" "group_message" should exist
    And I select "Group 1" conversation in messaging
    And I click on "conversation-actions-menu-button" "button"
    And I click on "Star" "link" in the "//div[@data-region='header-container']" "xpath_element"
    And I click on "//span[contains(text(),\"Starred\")]" "xpath_element"
    And I should see "Group 1"
    And I select "Group 1" conversation in messaging
    And I send "Hi!" message in the message area
    Then I should see "Hi!" in the ".message.clickable[data-region='message']" "css_element"
    And I click on "//span[contains(text(),\"Group\")]" "xpath_element"
    And I should not see "Group 1" in the "Group" "group_message_tab"
    And I log out
    And I log in as "student2"
    And I am on site homepage
    And I click on ".js-snap-pm-trigger.snap-my-courses-menu" "css_element"
    And I follow "View my messages"
    And "Group 1" "group_message" should exist
    And I select "Group 1" conversation in messaging
    Then I should see "Hi!" in the ".message.clickable[data-region='message']" "css_element"

  Scenario: Send a message to a private conversation via contacts in snap
    Given the following "message contacts" exist:
      | user     | contact |
      | student1 | student2 |
    And I log in as "student1"
    And I am on site homepage
    And I click on ".js-snap-pm-trigger.snap-my-courses-menu" "css_element"
    And I follow "View my messages"
    And I click on "Contacts" "link"
    And I click on "Student 2" "link" in the "//*[@data-section='contacts']" "xpath_element"
    When I send "Hi!" message in the message area
    Then I should see "Hi!" in the ".message.clickable[data-region='message']" "css_element"
    And I log out
    And I log in as "student2"
    And I am on site homepage
    And I click on ".js-snap-pm-trigger.snap-my-courses-menu" "css_element"
    And I follow "View my messages"
    And "Student 1" "group_message" should exist
    And I select "Student 1" conversation in messaging
    Then I should see "Hi!" in the ".message.clickable[data-region='message']" "css_element"