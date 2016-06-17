@ro_spot_details @ro_signature_captions @ro_campaign_details @expected_played_times @ad_play_statuses

Feature: Testing response for signature_captions

Scenario: Check signature_captions response for a specific channel
Given I use "AMAGI_REPORTS_DB" database and query "RO_CAMPAIGN_DETAILS,RO_SPOT_DETAILS" table
When I request GET for "SIGNATURE_CAPTIONS" URL for "current" date for "ZN"
Then the response for GET for "SIGNATURE_CAPTIONS" URL for "current" date for "ZN" should have status "200"
And the response for GET "SIGNATURE_CAPTIONS" URL for "current" date for "ZN" should match response from tables "RO_SPOT_DETAILS,RO_CAMPAIGN_DETAILS"

Scenario: Check signature_captions response for a specific channel after new data is added to tables
Given I use "AMAGI_REPORTS_DB" database and query "RO_CAMPAIGN_DETAILS,RO_SPOT_DETAILS" table
When I use "AMAGI_REPORTS_DB" database and query "SIGNATURE_CAPTIONS" table and "add" a "signature" for "ZT"
Then the response for GET for "SIGNATURE_CAPTIONS" URL for "current" date for "ZT" should have status "200"
And the response for GET "SIGNATURE_CAPTIONS" URL for "current" date for "ZT" should match response from tables "RO_SPOT_DETAILS,RO_CAMPAIGN_DETAILS"
And output of "SIGNATURE_CAPTIONS" url for "current" date for "ZT" should have "ASTRM_01_020"

Scenario: Check signature_captions response for a specific channel after new data is deleted from tables
Given I use "AMAGI_REPORTS_DB" database and query "RO_CAMPAIGN_DETAILS,RO_SPOT_DETAILS" table
When I use "AMAGI_REPORTS_DB" database and query "SIGNATURE_CAPTIONS" table and "delete" a "signature" for "ZT"
Then the response for GET for "SIGNATURE_CAPTIONS" URL for "current" date for "ZT" should have status "200"
And the response for GET "SIGNATURE_CAPTIONS" URL for "current" date for "ZT" should match response from tables "RO_SPOT_DETAILS,RO_CAMPAIGN_DETAILS"
And output of "SIGNATURE_CAPTIONS" url for "current" date for "ZT" should not have "deleted data"

Scenario: Delete data from "RO_SIGNATURE_CAPTIONS" and empty set should be displayed
Given I use "AMAGI_REPORTS_DB" database and query "RO_CAMPAIGN_DETAILS,RO_SPOT_DETAILS,RO_SIGNATURE_CAPTIONS" table
When I use "AMAGI_REPORTS_DB" database and delete all row in "RO_SPOT_DETAILS,RO_SIGNATURE_CAPTIONS" for "ZT" 
Then the response for GET for "SIGNATURE_CAPTIONS" URL for "current" date for "ZT" should have status "200"
And output of "SIGNATURE_CAPTIONS" url for "current" date for "ZT" should have "empty"

Scenario: Delete data from "RO_CAMPAIGN_DETAILS" and empty set should be displayed
Given I use "AMAGI_REPORTS_DB" database and query "RO_CAMPAIGN_DETAILS,RO_SPOT_DETAILS" table
When I use "AMAGI_REPORTS_DB" database and delete all row in "RO_CAMPAIGN_DETAILS" for "IB" 
Then the response for GET for "SIGNATURE_CAPTIONS" URL for "current" date for "IB" should have status "200"
And output of "SIGNATURE_CAPTIONS" url for "current" date for "IB" should have "empty"

Scenario: Check signature_captions response for a specific channel for past date after data is updated in tables on current date
Given I use "AMAGI_REPORTS_DB" database and query "RO_CAMPAIGN_DETAILS,RO_SPOT_DETAILS" table
When I use "AMAGI_REPORTS_DB" database and query "SIGNATURE_CAPTIONS" table and "update past" a "signature" for "ZN"
Then the response for GET for "SIGNATURE_CAPTIONS" URL for "past" date for "ZN" should have status "200"
And the response for GET "SIGNATURE_CAPTIONS" URL for "past" date for "ZN" should match response from tables "RO_SPOT_DETAILS,RO_CAMPAIGN_DETAILS"
And output of "SIGNATURE_CAPTIONS" url for "past" date for "ZN" should have "TEST_SIGNATURE"

Scenario: Check signature_captions response for a specific channel for future date after data is updated in tables on current date
Given I use "AMAGI_REPORTS_DB" database and query "RO_CAMPAIGN_DETAILS,RO_SPOT_DETAILS" table
When I use "AMAGI_REPORTS_DB" database and query "SIGNATURE_CAPTIONS" table and "update future" a "signature" for "ZN"
Then the response for GET for "SIGNATURE_CAPTIONS" URL for "future" date for "ZN" should have status "200"
And the response for GET "SIGNATURE_CAPTIONS" URL for "future" date for "ZN" should match response from tables "RO_SPOT_DETAILS,RO_CAMPAIGN_DETAILS"
And output of "SIGNATURE_CAPTIONS" url for "future" date for "ZN" should have "TEST_SIGNATURE"

Scenario: Delete data from "RO_CAMPAIGN_DETAILS,RO_SIGNATURE_CAPTIONS" and empty set should be displayed
Given I use "AMAGI_REPORTS_DB" database and query "RO_CAMPAIGN_DETAILS,RO_SIGNATURE_CAPTIONS" table
When I use "AMAGI_REPORTS_DB" database and delete all row in "RO_CAMPAIGN_DETAILS,RO_SIGNATURE_CAPTIONS" for "TN" 
Then the response for GET for "SIGNATURE_CAPTIONS" URL for "current" date for "TN" should have status "200"
And output of "SIGNATURE_CAPTIONS" url for "current" date for "TN" should have "empty"

