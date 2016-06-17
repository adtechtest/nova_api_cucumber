
Feature: Testing CITIES API for Nova API

Scenario: Query CITIES table and compare with cities.json API output

Given I use "MSO_DB" database and query "CITIES" table
When I request GET for "CITIES" URL for "current" date for "ZN"
Then the response for GET for "CITIES" URL for "current" date for "ZN" should have status "200"
And output of "CITIES" table and url for "current" date for "ZN" should match

Scenario: Query CITIES table and set valid_till as NULL for all cities
Given I use "MSO_DB" database and query "CITIES" table
When I use "MSO_DB" database and query "CITIES" table and set "VALID_TO" as "null" for "all"
Then the response for GET for "CITIES" URL for "current" date for "ZT" should have status "200"
And output of "CITIES" table and url for "current" date for "ZT" should match

Scenario: Query CITIES table and set valid_till as past date for all cities
Given I use "MSO_DB" database and query "CITIES" table
When I use "MSO_DB" database and query "CITIES" table and set "VALID_TO" as "past date" for "all"
Then the response for GET for "CITIES" URL for "current" date for "ZT" should have status "200"
And output of "CITIES" table and url for "current" date for "ZT" should match
And output of "CITIES" url for "current" date for "ZN" should have "empty"

Scenario: Query CITIES table and set valid_till as future date for all cities
Given I use "MSO_DB" database and query "CITIES" table
When I use "MSO_DB" database and query "CITIES" table and set "VALID_TO" as "future date" for "all"
Then the response for GET for "CITIES" URL for "current" date for "ZT" should have status "200"
And output of "CITIES" table and url for "current" date for "ZT" should match

Scenario: Query CITIES table and set valid_till as past date for "Bengaluru" city and NULL for all other cities
Given I use "MSO_DB" database and query "CITIES" table
When I use "MSO_DB" database and query "CITIES" table and set "VALID_TO" as "past date" for "Bengaluru"
Then the response for GET for "CITIES" URL for "current" date for "ZN" should have status "200"
And output of "CITIES" table and url for "current" date for "ZN" should match
And output of "CITIES" url for "current" date for "ZN" should not have "Bengaluru"

Scenario: Add a valid city to the CITIES table
Given I use "MSO_DB" database and query "CITIES" table
When I use "MSO_DB" database and query "CITIES" table and "add" new valid "CITY"
Then the response for GET for "CITIES" URL for "current" date for "ZN" should have status "200"
And output of "CITIES" table and url for "current" date for "ZN" should match
And output of "CITIES" url for "current" date for "ZN" should have "Test City"

Scenario: Delete an valid city to the CITIES table
Given I use "MSO_DB" database and query "CITIES" table
When I use "MSO_DB" database and query "CITIES" table and "delete" new valid "CITY"
Then the response for GET for "CITIES" URL for "current" date for "ZN" should have status "200"
And output of "CITIES" table and url for "current" date for "ZN" should match
And output of "CITIES" url for "current" date for "ZN" should not have "Test City"

Scenario: Add an invalid city to the CITIES table
Given I use "MSO_DB" database and query "CITIES" table
When I use "MSO_DB" database and query "CITIES" table and "add" new invalid "CITY"
Then the response for GET for "CITIES" URL for "current" date for "ZN" should have status "200"
And output of "CITIES" table and url for "current" date for "ZN" should match
And output of "CITIES" url for "current" date for "ZN" should not have "Test City"

Scenario: Delete an invalid city to the CITIES table
Given I use "MSO_DB" database and query "CITIES" table
When I use "MSO_DB" database and query "CITIES" table and "delete" new invalid "CITY"
Then the response for GET for "CITIES" URL for "current" date for "ZT" should have status "200"
And output of "CITIES" table and url for "current" date for "ZT" should match
And output of "CITIES" url for "current" date for "ZT" should not have "Test City"

Scenario: Get API with an invalid channel code
Given I use "MSO_DB" database and query "CITIES" table
When I request GET for "CITIES" URL for "current" date with invalid "channel"
Then the response for GET for "CITIES" URL for "current" date and invalid "channel" and should not have status "200"

@cities

Scenario: Get API without the date string
Given I use "MSO_DB" database and query "CITIES" table
When I request GET for "CITIES" URL for "ZN"
Then the response for GET for "CITIES" URL for "no" date for "ZN" should not have status "200"


 
