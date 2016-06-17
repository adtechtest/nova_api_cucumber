@ro_spot_details @ro_signature_captions @ro_campaign_details @expected_played_times @ad_play_statuses

Feature: Available masters API response

Scenario: Check available_masters response for a specific channel
Given I use "AMAGI_REPORTS_DB" database and query "RO_CAMPAIGN_DETAILS,RO_SPOT_DETAILS" table
When I request GET for "AVAILABLE_MASTERS" URL for "current" date for "IB"
Then the response for GET for "AVAILABLE_MASTERS" URL for "current" date for "IB" should have status "200"
And the response for GET "AVAILABLE_MASTERS" URL for "current" date for "IB" should match response from tables "RO_SPOT_DETAILS,RO_CAMPAIGN_DETAILS"

Scenario: Check available_masters response for a specific channel after new data is added to tables to present date
Given I use "AMAGI_REPORTS_DB" database and query "RO_CAMPAIGN_DETAILS,RO_SPOT_DETAILS" table
When I use "AMAGI_REPORTS_DB" database and query "AVAILABLE_MASTERS" table and "add" a "signature" for "ZN"
Then the response for GET for "AVAILABLE_MASTERS" URL for "current" date for "ZN" should have status "200"
And the response for GET "AVAILABLE_MASTERS" URL for "current" date for "ZN" should match response from tables "RO_SPOT_DETAILS,RO_CAMPAIGN_DETAILS"


Scenario: Check available_masters response for a specific channel after new data is deleted from tables
Given I use "AMAGI_REPORTS_DB" database and query "RO_CAMPAIGN_DETAILS,RO_SPOT_DETAILS" table
When I use "AMAGI_REPORTS_DB" database and query "AVAILABLE_MASTERS" table and "delete" a "signature" for "ZN"
Then the response for GET for "AVAILABLE_MASTERS" URL for "current" date for "ZN" should have status "200"
And the response for GET "AVAILABLE_MASTERS" URL for "current" date for "ZN" should match response from tables "RO_SPOT_DETAILS,RO_CAMPAIGN_DETAILS"

Scenario: Check available_masters response for a specific channel after data is updated from tables
Given I use "AMAGI_REPORTS_DB" database and query "RO_CAMPAIGN_DETAILS,RO_SPOT_DETAILS" table
When I use "AMAGI_REPORTS_DB" database and query "AVAILABLE_MASTERS" table and "update" a "spot count" for "IB"
Then the response for GET for "AVAILABLE_MASTERS" URL for "current" date for "IB" should have status "200"
And the response for GET "AVAILABLE_MASTERS" URL for "current" date for "IB" should match response from tables "RO_SPOT_DETAILS,RO_CAMPAIGN_DETAILS"

Scenario: Delete data from "RO_SPOT_DETAILS" and empty set should be displayed
Given I use "AMAGI_REPORTS_DB" database and query "RO_CAMPAIGN_DETAILS,RO_SPOT_DETAILS" table
When I use "AMAGI_REPORTS_DB" database and delete all row in "RO_SPOT_DETAILS" for "ZC"
Then the response for GET for "AVAILABLE_MASTERS" URL for "current" date for "ZC" should have status "200"
And output of "AVAILABLE_MASTERS" url for "current" date for "ZC" should have "empty"

Scenario: Delete data from "RO_CAMPAIGN_DETAILS" and empty set should be displayed
Given I use "AMAGI_REPORTS_DB" database and query "RO_CAMPAIGN_DETAILS,RO_SPOT_DETAILS" table
When I use "AMAGI_REPORTS_DB" database and delete all row in "RO_CAMPAIGN_DETAILS" for "IB"
Then the response for GET for "AVAILABLE_MASTERS" URL for "current" date for "IB" should have status "200"
And output of "AVAILABLE_MASTERS" url for "current" date for "IB" should have "empty"

Scenario: Delete data from "RO_CAMPAIGN_DETAILS,RO_SPOT_DETAILS" and empty set should be displayed
Given I use "AMAGI_REPORTS_DB" database and query "RO_CAMPAIGN_DETAILS,RO_SPOT_DETAILS" table
When I use "AMAGI_REPORTS_DB" database and delete all row in "RO_CAMPAIGN_DETAILS,RO_SPOT_DETAILS" for "TN"
Then the response for GET for "AVAILABLE_MASTERS" URL for "current" date for "TN" should have status "200"
And output of "AVAILABLE_MASTERS" url for "current" date for "TN" should have "empty"

