@windows

Feature: Testing dayparts response for Nova API

Scenario: Check response of dayparts API for channels ZN,ZT,ZC and TN for weekend

Given I use "AMAGI_REPORTS_DB" database and query "WINDOWS" table
When I request GET for "DAYPARTS" URL for next "Sunday" for channels "ZN,ZT,ZC,TN"
Then the response for GET for "DAYPARTS" URL for next "Sunday" for channels "ZN,ZT,ZC,TN" should have status "200"
And output of "DAYPARTS" URL and table for next "Sunday" for channels "ZN,ZT,ZC,TN" should match

Scenario: Check response of dayparts API for channels ZN,ZT,ZC and TN for weekday
Given I use "AMAGI_REPORTS_DB" database and query "WINDOWS" table
When I request GET for "DAYPARTS" URL for next "Monday" for channels "ZN,ZT,ZC,TN"
Then the response for GET for "DAYPARTS" URL for next "Monday" for channels "ZN,ZT,ZC,TN" should have status "200"
And output of "DAYPARTS" URL and table for next "Monday" for channels "ZN,ZT,ZC,TN" should match

Scenario: Check response of dayparts for channels ZN,ZT,ZC and TN for weekdend after data is inserted for weekend
Given I use "AMAGI_REPORTS_DB" database and query "WINDOWS" table
When I use "AMAGI_REPORTS_DB" database and query "WINDOWS" table and "insert" dayparts for "ZN,ZT,ZC,TN" for next "Sunday"
Then output of "DAYPARTS" URL and table for next "Monday" for channels "ZN,ZT,ZC,TN" should match
And output of "DAYPARTS" URL and table for next "Sunday" for channels "ZN,ZT,ZC,TN" should match


Scenario: Check response of dayparts for channels ZN,ZT,ZC and TN for weekdend after data is deleted for weekend
Given I use "AMAGI_REPORTS_DB" database and query "WINDOWS" table
When I use "AMAGI_REPORTS_DB" database and query "WINDOWS" table and "delete" dayparts for "ZN,ZT,ZC,TN" for next "Sunday"
And I request GET for "DAYPARTS" URL for next "Sunday" for channels "ZN,ZT,ZC,TN"
And output of "DAYPARTS" URL and table for next "Sunday" for channels "ZN,ZT,ZC,TN" should match


Scenario: Check response of dayparts for channels ZN,ZT,ZC and TN for weekday after data is inserted
Given I use "AMAGI_REPORTS_DB" database and query "WINDOWS" table
When I use "AMAGI_REPORTS_DB" database and query "WINDOWS" table and "insert" dayparts for "ZN,ZT,ZC,TN" for next "Monday"
And I request GET for "DAYPARTS" URL for next "Sunday" for channels "ZN,ZT,ZC,TN"
Then output of "DAYPARTS" URL and table for next "Sunday" for channels "ZN,ZT,ZC,TN" should match
And output of "DAYPARTS" URL and table for next "Monday" for channels "ZN,ZT,ZC,TN" should match


Scenario: Check response of dayparts for channels ZN,ZT,ZC and TN for weekday after data is deleted
Given I use "AMAGI_REPORTS_DB" database and query "WINDOWS" table
When I use "AMAGI_REPORTS_DB" database and query "WINDOWS" table and "delete" dayparts for "ZN,ZT,ZC,TN" for next "Monday"
And I request GET for "DAYPARTS" URL for next "Monday" for channels "ZN,ZT,ZC,TN"
And output of "DAYPARTS" URL and table for next "Monday" for channels "ZN,ZT,ZC,TN" should match

Scenario: Check response of dayparts for channels ZN,ZT,ZC and TN for weekday where valid_till is past
Given I use "AMAGI_REPORTS_DB" database and query "WINDOWS" table
When I use "AMAGI_REPORTS_DB" database and query "WINDOWS" table and update "valid_till"  to "past" for "ZN,ZT,ZC,TN" for next "Monday"
And I request GET for "DAYPARTS" URL for next "Monday" for channels "ZN,ZT,ZC,TN"
And output of "DAYPARTS" URL and table for next "Monday" for channels "ZN,ZT,ZC,TN" should match
And output of "DAYPARTS" URL and table for next "Monday" for channels "ZN,ZT,ZC,TN" should have "empty"


Scenario: Check response of dayparts for channels ZN,ZT,ZC and TN for weekday where valid_till is past
Given I use "AMAGI_REPORTS_DB" database and query "WINDOWS" table
When I use "AMAGI_REPORTS_DB" database and query "WINDOWS" table and update "valid_till"  to "future" for "ZN,ZT,ZC,TN" for next "Monday"
And I request GET for "DAYPARTS" URL for next "Monday" for channels "ZN,ZT,ZC,TN"
And output of "DAYPARTS" URL and table for next "Monday" for channels "ZN,ZT,ZC,TN" should match
And output of "DAYPARTS" URL and table for next "Monday" for channels "ZN,ZT,ZC,TN" should not have "empty"

Scenario: Check response of dayparts for channels ZN,ZT,ZC and TN for weekday where win_begin and win_end is updated
Given I use "AMAGI_REPORTS_DB" database and query "WINDOWS" table
When I use "AMAGI_REPORTS_DB" database and query "WINDOWS" table and update "win_times" of "ZN,ZT,ZC,TN" for next "Monday"
And I request GET for "DAYPARTS" URL for next "Monday" for channels "ZN,ZT,ZC,TN"
And output of "DAYPARTS" URL and table for next "Monday" for channels "ZN,ZT,ZC,TN" should match



Scenario: Check response of dayparts for channel ZN after channel code is updated to TEST
Given I use "AMAGI_REPORTS_DB" database and query "WINDOWS" table
When I use "AMAGI_REPORTS_DB" database and query "WINDOWS" table and "update" channel code of "ZN" 
And I request GET for "DAYPARTS" URL for next "Sunday" for channels "TEST"
Then the response for GET for "DAYPARTS" URL for "current" date for "TEST" should have status "200"
And output of "DAYPARTS" URL and table for next "Sunday" for channels "TEST" should match
And output of "DAYPARTS" URL and table for next "Monday" for channels "TEST" should match
#And output of "DAYPARTS" URL and table for next "Monday" for channels "ZN" should be empty
And change "WINDOWS" table "channel_code" from "TEST" to "ZN"

