Feature: Testing filler_captions response for NOVA API

Scenario: Check filler_captions response for a specific channel
Given I use "AMAGI_REPORTS_DB" database and query "FILLER_CAPTIONS" table
When I request GET for "FILLER_CAPTIONS" URL for "no" date for "ZN"
Then the response for GET for "FILLER_CAPTIONS" URL for "no" date for "ZN" should have status "200"
And output of "FILLER_CAPTIONS" table and url for "no" date for "ZN" should match

Scenario: Add a row for a channel in FILLER_CAPTIONS table and check filler_captions response
Given I use "AMAGI_REPORTS_DB" database and query "FILLER_CAPTIONS" table
When I use "AMAGI_REPORTS_DB" database and query "FILLER_CAPTIONS" table and "add" new valid "row"
Then the response for GET for "FILLER_CAPTIONS" URL for "no" date for "ZC" should have status "200"
And output of "FILLER_CAPTIONS" table and url for "no" date for "ZC" should match
And output of "FILLER_CAPTIONS" url for "no" date for "ZC" should have "TESTAD"

Scenario: Delete a row for a channel in FILLER_CAPTIONS table and check filler_captions response
Given I use "AMAGI_REPORTS_DB" database and query "FILLER_CAPTIONS" table
When I use "AMAGI_REPORTS_DB" database and query "FILLER_CAPTIONS" table and "delete" new valid "row"
Then the response for GET for "FILLER_CAPTIONS" URL for "current" date for "ZC" should have status "200"
And output of "FILLER_CAPTIONS" table and url for "current" date for "ZC" should match
And output of "FILLER_CAPTIONS" url for "no" date for "ZC" should not have "TESTAD"

Scenario: Set valid_till as null for all rows of a channel in FILLER_CAPTIONS table and check filler_captions response
Given I use "AMAGI_REPORTS_DB" database and query "FILLER_CAPTIONS" table
When I use "AMAGI_REPORTS_DB" database and query "FILLER_CAPTIONS" table and set "VALID_TILL" as "null" for "ZN"
Then the response for GET for "FILLER_CAPTIONS" URL for "current" date for "ZN" should have status "200"
And output of "FILLER_CAPTIONS" table and url for "current" date for "ZN" should match

Scenario: Set valid_till as future date for all rows of a channel in FILLER_CAPTIONS table and check filler_captions response
Given I use "AMAGI_REPORTS_DB" database and query "FILLER_CAPTIONS" table
When I use "AMAGI_REPORTS_DB" database and query "FILLER_CAPTIONS" table and set "VALID_TILL" as "future date" for "ZN"
Then the response for GET for "FILLER_CAPTIONS" URL for "current" date for "ZN" should have status "200"
And output of "FILLER_CAPTIONS" table and url for "current" date for "ZN" should match

Scenario: Set valid_till as past date for all rows of a channel in FILLER_CAPTIONS table and check filler_captions response
Given I use "AMAGI_REPORTS_DB" database and query "FILLER_CAPTIONS" table
When I use "AMAGI_REPORTS_DB" database and query "FILLER_CAPTIONS" table and set "VALID_TILL" as "past date" for "ZN"
Then the response for GET for "FILLER_CAPTIONS" URL for "current" date for "ZN" should have status "200"
And output of "FILLER_CAPTIONS" table and url for "current" date for "ZN" should match
And output of "FILLER_CAPTIONS" url for "current" date for "ZC" should have "empty"

Scenario: Update a row for a channel in FILLER_CAPTIONS and check filler_captions response
Given I use "AMAGI_REPORTS_DB" database and query "FILLER_CAPTIONS" table
When I use "AMAGI_REPORTS_DB" database and query "FILLER_CAPTIONS" table and "update" a "row"
Then the response for GET for "FILLER_CAPTIONS" URL for "no" date for "ZT" should have status "200"
And output of "FILLER_CAPTIONS" table and url for "no" date for "ZT" should match
And output of "FILLER_CAPTIONS" url for "no" date for "TST" should not be empty
And change "FILLER_CAPTIONS" table "channel_id" from "TST" to "ZT"
