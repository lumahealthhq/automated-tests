Description: Story performs verification of testcase "4.2 Send Waiting Room Text Magic Button" (TestCaseId=37)
Meta:
    @epic Sanity
    @feature CustomActions
    @testCaseId 37


Scenario: Open main application page (Step 1)
Meta:
    @severity 1
Given I am on the main application page


Scenario: Log into application (Step 2)
Meta:
    @severity 1
When I initialize the STORY variable `firstName` with value `#{generate(name.firstName)}ATCreated`
When I initialize the STORY variable `lastName` with value `#{generate(name.lastName)}ATCreated`
When I initialize the STORY variable `phoneNumber` with value `#{${dummyPhoneNumbersVariety2}}`
When I initialize the STORY variable `practiceName` with value `#{generate(regexify '[A-Z0-9]{10}')}`
Given I log into application with firstName '${firstName}' lastName '${lastName}' practiceName '${practiceName}' phoneNumber '${phoneNumber}' and parameters '#{loadResource(/templates/minimumInitialDataConfiguration.json)}'


Scenario: Run magic button and verify the patient receives the message (Step 3)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Hub')])`
When I wait until element located `xpath(//*[@name='messageInput'])` appears
When I click on element located `xpath(//*[@role='button']//*[contains(text(),'${lastName}')])`
When I initialize the STORY variable `patientId` with value `#{replaceAllByRegExp((.*patient=)(.*), $2, ${current-page-url})}`
Given I am on a page with the URL '${baseApplicationUrl}/patients/${patientId}/chat'
When I use magic button `customActionJoinToWaitingRoom` for the current patient
When I switch to window with title that CONTAINS `Luma Health`
When I wait until element located `xpath(//*[contains(text(),'For your safety')])` appears
When I change context to element located `xpath(//*[contains(text(),'For your safety')])`
When I save text of context element to SCENARIO variable `safetyMessage`
When I reset context
When I save access token from application storage to STORY variable 'accessToken'
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
When I save JSON element from context by JSON path `$[0].text` to SCENARIO variable `safetyMessageSMS`
Then `${safetyMessageSMS}` matches `"Hello ${firstName}, For your safety, please reply ARRIVED when you have arrived and remain in your vehicle for further instructions. Thank you."`
Then `${safetyMessage}` matches `Hello ${firstName}, For your safety, please reply ARRIVED when you have arrived and remain in your vehicle for further instructions. Thank you.`


Scenario: Click 'Schedule' in the Left Navigation menu (Step 4)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Schedule')])`
When I wait until element located `xpath(//*[contains(text(),'Waiting Room')])` appears
Then the text 'Schedule for Today' exists


Scenario: Click 'Waiting Room' tab (Step 5)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Waiting Room')])`
When I wait until element located `xpath(//*[contains(text(),'Waiting room for Today')])` appears
Then the text 'Waiting room for Today' exists
When I wait until element located `xpath(//*[contains(text(),'0 Patients have checked in')])` appears
Then field located `xpath(//*[contains(text(),'${firstName} ${lastName}')])` does not exist


Scenario: Reply 'arrived' as patient (Step 6)
Meta:
    @severity 1
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
When I save JSON element from context by JSON path `$[0].from` to SCENARIO variable `fromPhoneNumber`
When I initialize the SCENARIO variable `fromPhoneNumber` with value `#{replaceAllByRegExp((\s*\-*), """""", #{removeWrappingDoubleQuotes(${fromPhoneNumber})})}`
When I save JSON element from context by JSON path `$[0].externalId.value` to SCENARIO variable `messageId`
When I initialize the SCENARIO variable `messageId` with value `#{removeWrappingDoubleQuotes(${messageId})}`
Given I reply on message with id '${messageId}' with text 'arrived' as patient with phoneNumber '${phoneNumber}' to recipient with phoneNumber '${fromPhoneNumber}'
Given I am on a page with the URL '${baseApplicationUrl}/patients/${patientId}/chat'
When I wait until element located `xpath(//*[contains(text(),'Thanks for letting us know')])` appears
Then the text 'Thanks for letting us know, we'll begin the check-in process shortly.' exists
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
Then the response body contains 'Thanks for letting us know, we'll begin the check-in process shortly.'


Scenario: Return to 'Waiting Room' tab (Step 7)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Schedule')])`
When I wait until element located `xpath(//*[contains(text(),'Waiting Room')])` appears
When I click on element located `xpath(//*[contains(text(),'Waiting Room')])`
When I wait until element located `xpath(//*[contains(text(),'Waiting room for Today')])` appears
When I refresh the page
When I wait until element located `xpath(//*[contains(text(),'Waiting room for Today')])` appears
When I wait until element located `xpath(//*[contains(text(),'0 Patients have arrived')])` disappears
Then field located `xpath(//*[contains(text(),'${firstName} ${lastName}')])` exists


Scenario: Move the appointment card from 'Arrived' to 'Checked in' column (Step 8)
Meta:
    @severity 1
When I simulate drag of element located `xpath(//*[@data-drag-target-status='arrived']/descendant::div[contains(text(),'${firstName}')])` and drop at element located `xpath(//div[@data-drag-target-status='waiting'])`
When I wait until element located `xpath(//*[contains(text(), 'Checked In:')]/following-sibling::div[contains(text(), '...')])` disappears
Then field located `xpath(//*[@data-drag-target-status='waiting']/descendant::div[contains(text(),'${firstName}')])` exists
Given I am on a page with the URL '${baseApplicationUrl}/patients/${patientId}/chat'
When I wait until element located `xpath(//*[contains(text(),'Please make your way')])` appears
Then the text 'You're all checked in and your provider is ready to see you. Please make your way to the clinic.' exists
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
Then the response body contains 'You're all checked in and your provider is ready to see you. Please make your way to the clinic.'
