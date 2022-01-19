Description: Story performs verification of testcase "Waitlist Offer with Reschedule Link Magic Button" (TestCaseId=30)
Meta:
    @epic Sanity
    @feature Waitlist
    @testCaseId 30


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
When I use magic button `patientApptOfferWithReschedule` for the current patient
When I switch to window with title that CONTAINS `Luma Health`
When I wait until element located `xpath(//*[contains(text(),'https')])` appears
When I change context to element located `xpath(//*[contains(text(),'https')])`
When I save text of context element to SCENARIO variable `apptOfferWithRescheduleMessage`
When I initialize the STORY variable `rescheduleUrl` with value `#{replaceAllByRegExp((.*)(https://.*), $2, ${apptOfferWithRescheduleMessage})}`
When I reset context
When I save access token from application storage to STORY variable 'accessToken'
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
When I save JSON element from context by JSON path `$[0].text` to SCENARIO variable `apptOfferWithRescheduleMessageSMS`
Then `${apptOfferWithRescheduleMessageSMS}` matches `".*https://.*"`
Then `${apptOfferWithRescheduleMessage}` matches `.*https://.*`


Scenario: Open link from message (Step 4)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Activity Feed')])`
When I wait until element located `xpath(//*[contains(text(), 'open slot')])` appears
When I click on element located `xpath(//*[contains(text(), 'CANCEL')])`
When I wait until element located `xpath(//*[contains(text(), 'CANCEL')])` disappears
When I open URL `${rescheduleUrl}` in new window
When I wait until element located `xpath((//ul/descendant::button)[1])` appears
Then the text 'Please select a time. You'll request your appointment on the next page.' exists


Scenario: Select any time slot (Step 5)
Meta:
    @severity 1
When I change context to element located `xpath((//ul/descendant::button)[1])`
When I save text of context element to STORY variable `newTime`
When I reset context
When I initialize the STORY variable `timeConfirmation` with value `#{replaceAllByRegExp((\d+:\d+).*, $1, ${newTime})}`
When I initialize the STORY variable `dayTimeConfirmation` with value `#{replaceAllByRegExp(\d+:\d+(\w+), $1, ${newTime})}`
When I click on element located `xpath((//ul/descendant::button)[1])`
When I wait until element located `xpath(//*[contains(text(), 'SEND APPOINTMENT REQUEST')])` appears
Then field located `xpath(//*[contains(text(),'${timeConfirmation} ${dayTimeConfirmation}')])` exists


Scenario: Click 'Send Appointment Request' button (Step 6)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(), 'Review and book')]/parent::div/div/descendant::*[contains(text(), 'SEND APPOINTMENT REQUEST')])`
When I wait until element located `xpath(//*[contains(text(), 'Your appointment time is reserved')])` appears
Then the text 'Your appointment time is reserved' exists
Then the text 'but not confirmed' exists
When I close the current window


Scenario: Return to Activity Feed page and refresh (Step 7)
Meta:
    @severity 1
When I switch to window with title that CONTAINS `Luma Health`
When I refresh the page
When I wait until element located `xpath(//*[contains(text(),'Activity for Today')])` appears
When I change context to element located `xpath(//*[contains(text(),'Waiting')]/preceding-sibling::p)`
When I save text of context element to SCENARIO variable `acceptanceMessage`
When I reset context
Then `${acceptanceMessage}` matches `Patient ${firstName} ${lastName} accepted the open slot with.* on.* ${timeConfirmation} ${dayTimeConfirmation}`


Scenario: Click 'Accept' button and verify the patient receives the message (Step 8)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Accept')])`
When I wait until element located `xpath(//*[contains(text(),'Accept')])` disappears
Given I am on a page with the URL '${baseApplicationUrl}/patients/${patientId}/chat'
When I wait until element located `xpath(//*[contains(text(),'has been booked')])` appears
When I change context to element located `xpath(//*[contains(text(),'has been booked')])`
When I save text of context element to SCENARIO variable `confirmationMessage`
When I reset context
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
When I save JSON element from context by JSON path `$[0].text` to SCENARIO variable `confirmationMessageSMS`
Then `${confirmationMessageSMS}` matches `"Thanks. You're all set and your appointment on.*has been booked."`
Then `${confirmationMessage}` matches `Thanks. You're all set and your appointment on.*has been booked.`
