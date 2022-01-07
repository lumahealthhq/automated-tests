Description: Story performs verification of testcase "4.1 Send Recall Followup" (TestCaseId=32)
Meta:
    @epic Sanity
    @feature CustomActions
    @testCaseId 32


Scenario: Open main application page (Step 1)
Meta:
    @severity 1
Given I am on the main application page


Scenario: Log into application (Step 2)
Meta:
    @severity 1
When I initialize the STORY variable `firstName` with value `#{generate(name.firstName)}ATCreated`
When I initialize the STORY variable `lastName` with value `#{generate(name.lastName)}ATCreated`
When I initialize the STORY variable `phoneNumber` with value `#{${dummyPhoneNumbersVariety1}}`
When I initialize the STORY variable `practiceName` with value `#{generate(regexify '[a-zA-Z0-9]{10}')}`
Given I log into application with firstName '${firstName}' lastName '${lastName}' practiceName '${practiceName}' phoneNumber '${phoneNumber}' and parameters '#{loadResource(/templates/minimumInitialDataConfiguration.json)}'


Scenario: Run magic button and verify the patient receives the message (Step 3-4)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Hub')])`
When I wait until element located `xpath(//*[@name='messageInput'])` appears
When I click on element located `xpath(//*[@role='button']//*[contains(text(),'${lastName}')])`
When I initialize the STORY variable `patientId` with value `#{replaceAllByRegExp((.*patient=)(.*), $2, ${current-page-url})}`
Given I am on a page with the URL '${baseApplicationUrl}/patients/${patientId}/chat'
When I use magic button `customActionRecall` for the current patient
When I switch to window with title that CONTAINS `Luma Health`
When I wait until element located `xpath(//*[contains(text(),'this is a reminder')])` appears
When I change context to element located `xpath(//*[contains(text(),'this is a reminder')])`
When I save text of context element to SCENARIO variable `recallMessage`
When I reset context
When I save access token from application storage to STORY variable 'accessToken'
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
When I save JSON element from context by JSON path `$[0].text` to SCENARIO variable `recallMessageSMS`
Then `${recallMessageSMS}` matches `"Hello ${firstName}, this is a reminder from.*. You're due for an appointment with us. Please call us at \+\d\ \d{3}-\d{3}-\d{4}\ to schedule your appointment."`
Then `${recallMessage}` matches `Hello ${firstName}, this is a reminder from.*. You're due for an appointment with us. Please call us at \+\d\ \d{3}-\d{3}-\d{4}\ to schedule your appointment.`
