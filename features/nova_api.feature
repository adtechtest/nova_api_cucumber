Feature: This spec includes tests for NOVA API.

Scenario: Querying and checking display of channels API

Given: Using "MSO_DB" 
And query database "channels" table
And setting "valid_till" as null
Then the response for GET "http://localhost:3000/api/v1/channels.json" should have status "200"
And the JSON response should match database response

