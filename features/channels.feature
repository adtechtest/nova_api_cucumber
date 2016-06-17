Feature: NOVA API test automation

Scenario: Testing channels output from Nova API

Given I use "MSO_DB" database and query "CHANNELS" table
When I request GET for "CHANNELS" URL for "no" date for "null"
Then the response for GET for "CHANNELS" URL for "no" date should have status "200"
And output of "CHANNELS" table and url for "no" date for "null" should match

Given I use "MSO_DB" database and query "CHANNELS" table
When I use "MSO_DB" database and query "CHANNELS" table and set "VALID_TO" as "null" for "all"
Then the response for GET for "CHANNELS" URL for "no" date should have status "200"
And output of "CHANNELS" table and url for "no" date for "null" should match

Scenario: Testing channels output from Nova API after setting a future valid_to date
Given I use "MSO_DB" database and query "CHANNELS" table
When I use "MSO_DB" database and query "CHANNELS" table and set "VALID_TO" as "future date" for "ZN"
Then the response for GET for "CHANNELS" URL for "current" date should have status "200"
And output of "CHANNELS" table and url for "current" date for "null" should match
And output of "CHANNELS" url for "current" date for "null" should have "ZN"

Scenario: Testing channels output from Nova API after setting a past valid_to date
Given I use "MSO_DB" database and query "CHANNELS" table
When I use "MSO_DB" database and query "CHANNELS" table and set "VALID_TO" as "past date" for "ZN"
Then the response for GET for "CHANNELS" URL for "current" date should have status "200"
And output of "CHANNELS" table and url for "current" date for "null" should match
And output of "CHANNELS" url for "current" date for "null" should not have "ZN"

Scenario: Testing channels output from Nova API when a new channel is inserted
Given I use "MSO_DB" database and query "CHANNELS" table
When I use "MSO_DB" database and query "CHANNELS" table and "add" new valid "CHANNEL"
Then the response for GET for "CHANNELS" URL for "no" date should have status "200"
And output of "CHANNELS" table and url for "no" date for "null" should match
And output of "CHANNELS" url for "no" date for "null" should have "TEST"

Scenario: Testing channels output from Nova API when a channel entry is deleted
Given I use "MSO_DB" database and query "CHANNELS" table
When I use "MSO_DB" database and query "CHANNELS" table and "delete" new valid "CHANNEL"
Then the response for GET for "CHANNELS" URL for "no" date should have status "200"
And output of "CHANNELS" table and url for "no" date for "null" should match
And output of "CHANNELS" url for "no" date for "null" should not have "TEST"

Scenario: Add an invalid channel to the CHANNELS table
Given I use "MSO_DB" database and query "CHANNELS" table
When I use "MSO_DB" database and query "CHANNELS" table and "add" new invalid "CHANNEL"
Then the response for GET for "CHANNELS" URL for "no" date should have status "200"
And output of "CHANNELS" table and url for "no" date for "null" should match
And output of "CHANNELS" url for "no" date for "null" should not have "TEST"

@channels

Scenario: Delete an invalid channel to the CHANNELS table
Given I use "MSO_DB" database and query "CHANNELS" table
When I use "MSO_DB" database and query "CHANNELS" table and "delete" new invalid "CHANNEL"
Then the response for GET for "CHANNELS" URL for "no" date should have status "200"
And output of "CHANNELS" table and url for "no" date for "null" should match
And output of "CHANNELS" url for "no" date for "null" should not have "TEST"


