@ats_campaigns @ats_captions @ats_caption_rates

Feature: Testing local_captions response from NOVA API

Scenario: Add a local caption for a deal and check LOCAL_CAPTIONS API
Given I use "AMAGI_REPORTS_DB" database and query "ATS_CAMPAIGNS, ATS_CAPTIONS, ATS_CAPTION_RATES" table
When I "insert" local deal using XML file for "ZM"
Then the response for GET for "LOCAL_CAPTIONS" URL for "current" date for "ZM" should have status "200"
And the response should "insert" deal info for "LOCAL_CAPTIONS" and channel "ZM"
When I "delete" local deal using XML file for "ZM"
Then the response should "delete" deal info for "LOCAL_CAPTIONS" and channel "ZM"

Scenario: Check local_captions response for a specific channel for current date and data should match all tables response
Given I use "AMAGI_REPORTS_DB" database and query "ATS_ROTATE_PLANS, ATS_CAMPAIGNS, ATS_CAPTIONS, ATS_CAPTION_RATES" table
When I request GET for "LOCAL_CAPTIONS" URL for "current" date for "ZM"
Then the response for GET for "LOCAL_CAPTIONS" URL for "current" date for "ZM" should have status "200"
And the response for GET "LOCAL_CAPTIONS" URL for "current" date for "ZM" should match response from tables "ATS_CAPTIONS, ATS_ROTATE_PLANS, ATS_CAMPAIGNS, ATS_CAPTION_RATES"

Scenario: Check local_captions response for a specific channel for no date
Given I use "AMAGI_REPORTS_DB" database and query "ATS_ROTATE_PLANS, ATS_CAMPAIGNS, ATS_CAPTIONS, ATS_CAPTION_RATES" table
When I request GET for "LOCAL_CAPTIONS" URL for "no" date for "ZN"
Then the response for GET for "LOCAL_CAPTIONS" URL for "no" date for "ZN" should not have status "200"

Scenario: Check local_captions response for an invalid channel code for current date
Given I use "AMAGI_REPORTS_DB" database and query "ATS_ROTATE_PLANS, ATS_CAMPAIGNS, ATS_CAPTIONS, ATS_CAPTION_RATES" table
When I request GET for "LOCAL_CAPTIONS" URL for "current" date for "TSTCHANNEL"
Then output of "LOCAL_CAPTIONS" url for "current" date for "TSTCHANNEL" should have "empty"

Scenario: Update caption details in ATS_CAPTIONS and check local_captions response for a specific channel for current date
Given I use "AMAGI_REPORTS_DB" database and query "ATS_ROTATE_PLANS, ATS_CAMPAIGNS, ATS_CAPTIONS, ATS_CAPTION_RATES" table
When I use "AMAGI_REPORTS_DB" database and query "LOCAL_CAPTIONS" table and "update" a "caption" for "ZM"
Then the response for GET for "LOCAL_CAPTIONS" URL for "current" date for "ZM" should have status "200"
And the response for GET "LOCAL_CAPTIONS" URL for "current" date for "ZM" should match response from tables "ATS_CAPTIONS, ATS_ROTATE_PLANS, ATS_CAMPAIGNS, ATS_CAPTION_RATES"
And the response should reflect changes in "caption update" for "LOCAL_CAPTIONS" and channel "ZM"

Scenario: Update caption rates in ATS_CAPTIONS_RATES and check local_captions response for a specific channel for current date
Given I use "AMAGI_REPORTS_DB" database and query "ATS_CAPTION_RATES" table
When I use "AMAGI_REPORTS_DB" database and query "LOCAL_CAPTIONS" table and "update" a "caption rate" for "ZM"
Then the response for GET for "LOCAL_CAPTIONS" URL for "current" date for "ZM" should have status "200"
And the response for GET "LOCAL_CAPTIONS" URL for "current" date for "ZM" should match response from tables "ATS_CAPTIONS, ATS_ROTATE_PLANS, ATS_CAMPAIGNS, ATS_CAPTION_RATES"
And the response should reflect changes in "caption rates update" for "LOCAL_CAPTIONS" and channel "ZM"

Scenario: Delete a caption in ATS_CAPTIONS
Given I use "AMAGI_REPORTS_DB" database and query "ATS_CAPTIONS" table
When I use "AMAGI_REPORTS_DB" database and query "LOCAL_CAPTIONS" table and "delete" a "caption" for "ZM"
Then the response for GET for "LOCAL_CAPTIONS" URL for "current" date for "ZM" should have status "200"
And the response for GET "LOCAL_CAPTIONS" URL for "current" date for "ZM" should match response from tables "ATS_CAPTIONS, ATS_ROTATE_PLANS, ATS_CAMPAIGNS, ATS_CAPTION_RATES"
And the response should reflect changes in "caption delete" for "LOCAL_CAPTIONS" and channel "ZM"

Scenario: Update city in ATS_CAMPAIGNS
Given I use "AMAGI_REPORTS_DB" database and query "ATS_CAMPAIGNS" table
When I use "AMAGI_REPORTS_DB" database and query "ATS_CAMPAIGNS" table and "update" a "city" for "ZM"
Then the response for GET for "LOCAL_CAPTIONS" URL for "current" date for "ZM" should have status "200"
And the response for GET "LOCAL_CAPTIONS" URL for "current" date for "ZM" should match response from tables "ATS_CAPTIONS, ATS_ROTATE_PLANS, ATS_CAMPAIGNS, ATS_CAPTION_RATES"
And the response should reflect changes in "city update" for "LOCAL_CAPTIONS" and channel "ZM"


