Feature: Testing import_schedule response for NOVA API

Scenario: Importing schedule for a particular channel and date should be successful and data should be entered in the tables
Given I use "AMAGI_REPORTS_DB" database and query "SCH_MATRIX_BREAKS,SCH_MATRIX_LOCAL_ADS,SCHEDULES,WINDOWS" table
When I add JSON file "./data/schedule.json" for "ZC" for "current" for "import_schedule" API
Then the status should be "0" and result should be "success"
And the data from "./data/schedule.json" should be added for "import_schedule" API



Scenario: Importing schedule for a different channel and date should not be successful and data should not be entered in the tables
Given I use "AMAGI_REPORTS_DB" database and query "SCH_MATRIX_BREAKS,SCH_MATRIX_LOCAL_ADS,SCHEDULES,WINDOWS" table
When I add JSON file "./data/schedule_test.json" for "CUCUMBER_CHANNEL" for "current" for "import_schedule" API
Then the status should be "1" and result should be "not found"
