Feature: Testing planned_locals API response for Nova API

Scenario: Call the planned_locals API and check Nova API response
Given I use "AMAGI_REPORTS_DB" database and query "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES" table
When I request GET for "PLANNED_LOCALS" URL for "current" date for "ZN"
Then the response for GET for "PLANNED_LOCALS" URL for "current" date for "ZN" should have status "200"
And the response for GET "PLANNED_LOCALS" URL for "current" date for "ZN" should match response from tables "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES"

Scenario: Delete data for asrun pending for ZN for past date and check Nova API response for planned_locals
Given I use "AMAGI_REPORTS_DB" database and query "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES" table
When I use "AMAGI_REPORTS_DB" database and query "AD_PLAY_STATUSES" table and "delete" data for "asrun_pending" for "ZN"
Then the response for GET for "PLANNED_LOCALS" URL for "current" date for "ZN" should have status "200"
And the response for GET "PLANNED_LOCALS" URL for "current" date for "ZN" should match response from tables "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES"

Scenario: Delete all data for asrun pending for ZN for past date and check Nova API response for planned locals
Given I use "AMAGI_REPORTS_DB" database and query "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES" table
When I use "AMAGI_REPORTS_DB" database and query "AD_PLAY_STATUSES" table and "delete" all data for "asrun_pending" for "ZN"
#(Example:  delete from ad_play_statuses where channel_code='ZC'  and date='2016-03-10' and also change rotates table;)
Then the response for GET for "PLANNED_LOCALS" URL for "current" date for "ZN" should have status "200"
And the response for GET "PLANNED_LOCALS" URL for "current" date for "ZN" should match response from tables "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES"

Scenario: Add schedules for future date where rotates are not present for ZT and check planned_locals response
Given I use "AMAGI_REPORTS_DB" database and query "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES" table
When I use "AMAGI_REPORTS_DB" database and query "SCHEDULES" table and "add" a "schedule" for "ZN"
#(get valid_till date of all past captions to future date. From list of all captions, make schedule for future date for a particular date)

Then the response for GET for "PLANNED_LOCALS" URL for "current" date for "ZN" should have status "200"
And the response for GET "PLANNED_LOCALS" URL for "current" date for "ZN" should match response from tables "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES"


Scenario: Add schedules for future date where rotates are present for ZT and check planned_locals response
Given I use "AMAGI_REPORTS_DB" database and query "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES" table
When I use "AMAGI_REPORTS_DB" database and query "PLANNED_LOCALS" table and "add" a "schedule" for "ZN"
#(get valid_till date of all past captions to future date. From list of all captions, make schedule for future date for a particular date, add rotates for those dates)
Then the response for GET for "PLANNED_LOCALS" URL for "current" date for "ZN" should have status "200"
And the response for GET "PLANNED_LOCALS" URL for "current" date for "ZN" should match response from tables "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES"

Scenario: Delete schedules for future date where rotates are present for ZN and check planned_locals response
Given I use "AMAGI_REPORTS_DB" database and query "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES" table
When I use "AMAGI_REPORTS_DB" database and for "PLANNED_LOCALS" API, change the "future" schedule date to "past" for "ZN"
#(Example:  Change schedule date from future date to past date;)
Then the response for GET for "PLANNED_LOCALS" URL for "current" date for "ZN" should have status "200"
And the response for GET "PLANNED_LOCALS" URL for "current" date for "ZN" should match response from tables "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES"


Scenario: Update total rotates and check make good for that caption from Nova API response
Given I use "AMAGI_REPORTS_DB" database and query "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES" table
When I use "AMAGI_REPORTS_DB" database and query "ATS_ROTATE_PLANS" table and "update" data for "total rotates" for "ZC"
#( For that caption, change total_rotates data)
Then the response for GET for "PLANNED_LOCALS" URL for "current" date for "ZC" should have status "200"
And the response for GET "PLANNED_LOCALS" URL for "current" date for "ZC" should match response from tables "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES"

Scenario: Update played rotates and check make good for that caption from Nova API response
Given I use "AMAGI_REPORTS_DB" database and query "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES" table
When I use "AMAGI_REPORTS_DB" database and query "AD_PLAY_STATUSES" table and "update" data for "played rotates" for "ZC"
Then the response for GET for "PLANNED_LOCALS" URL for "current" date for "ZC" should have status "200"
And the response for GET "PLANNED_LOCALS" URL for "current" date for "ZC" should match response from tables "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES"

Scenario: Update future overschedule and check make good for that caption from Nova API response
Given I use "AMAGI_REPORTS_DB" database and query "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES" table
When I use "AMAGI_REPORTS_DB" database and query "SCHEDULES" table and "update" data for "future overscheduled" for "ZC"
Then the response for GET for "PLANNED_LOCALS" URL for "current" date for "ZC" should have status "200"
And the response for GET "PLANNED_LOCALS" URL for "current" date for "ZC" should match response from tables "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES"

Scenario: Update planned_so_far and check make good for that caption from Nova API response
Given I use "AMAGI_REPORTS_DB" database and query "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES" table
When I use "AMAGI_REPORTS_DB" database and query "ATS_ROTATE_PLANS" table and "update" data for "planned_so_far" for "ZC"
Then the response for GET for "PLANNED_LOCALS" URL for "current" date for "ZC" should have status "200"
And the response for GET "PLANNED_LOCALS" URL for "current" date for "ZC" should match response from tables "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES"

Scenario: Update schedule_type and check make good for that caption from Nova API response
Given I use "AMAGI_REPORTS_DB" database and query "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES" table
When I use "AMAGI_REPORTS_DB" database and query "ATS_ROTATE_PLANS" table and "update" data for "schedule type" for "ZC"
Then the response for GET for "PLANNED_LOCALS" URL for "current" date for "ZC" should have status "200"
And the response for GET "PLANNED_LOCALS" URL for "current" date for "ZC" should match response from tables "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES"

Scenario: Update end date and check make good for that caption from Nova API response 
Given I use "AMAGI_REPORTS_DB" database and query "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES" table
When I use "AMAGI_REPORTS_DB" database and query "ATS_CAPTIONS" table and "update" data for "end date" for "ZC"
Then the response for GET for "PLANNED_LOCALS" URL for "current" date for "ZC" should have status "200"
And the response for GET "PLANNED_LOCALS" URL for "current" date for "ZC" should match response from tables "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES"

Scenario: Add new local caption for "IB" and check Nova API response
Given I use "AMAGI_REPORTS_DB" database and query "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES" table
When I "create" local deal using XML file
Then the response for GET for "PLANNED_LOCALS" URL for "current" date for "ZC" should have status "200"
And the response for GET "PLANNED_LOCALS" URL for "current" date for "ZC" should match response from tables "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES"
And the output for "PLANNED_LOCALS" URL should "have" information for new signature

Scenario: Delete local caption for "IB" and check Nova API response
Given I use "AMAGI_REPORTS_DB" database and query "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES" table
When I "delete" local deal using XML file
Then the response for GET for "PLANNED_LOCALS" URL for "current" date for "ZC" should have status "200"
And the response for GET "PLANNED_LOCALS" URL for "current" date for "ZC" should match response from tables "ATS_ROTATE_PLANS,SCHEDULES,ATS_CAPTIONS,ATS_CAMPAIGNS,AD_PLAY_STATUSES"
And the output for "PLANNED_LOCALS" URL should "not have" information for new signature

