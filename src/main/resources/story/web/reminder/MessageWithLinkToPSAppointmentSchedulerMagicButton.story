Description: Story performs verification of testcase "1.3 Message with Link to PS+ Appointment Scheduler Magic Button" (TestCaseId=24)
Meta:
    @epic Sanity
    @feature Reminder
    @testCaseId 24


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
Given I log into application with firstName '${firstName}' lastName '${lastName}' practiceName '${practiceName}' phoneNumber '${phoneNumber}' and parameters '#{loadResource(/templates/initialDataConfigurationWithTenPatients.json)}'


Scenario: Run magic button and verify the patient receives the message (Step 3-4)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Hub')])`
When I wait until element located `xpath(//*[@name='messageInput'])` appears
When I click on element located `xpath(//*[@role='button']//*[contains(text(),'${lastName}')])`
When I initialize the STORY variable `patientId` with value `#{replaceAllByRegExp((.*patient=)(.*), $2, ${current-page-url})}`
Given I am on a page with the URL '${baseApplicationUrl}/patients/${patientId}/chat'
When I use magic button `patientDemoLinkToScheduleAppointment` for the current patient
When I switch to window with title that CONTAINS `Luma Health`
When I wait until element located `xpath(//*[contains(text(),'Please click here')])` appears
When I change context to element located `xpath(//*[contains(text(),'Please click here')])`
When I save text of context element to SCENARIO variable `schedulerMessage`
When I initialize the STORY variable `schedulerUrl` with value `#{replaceAllByRegExp((.*)(https://.*), $2, ${schedulerMessage})}`
When I reset context
When I save access token from application storage to STORY variable 'accessToken'
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
When I save JSON element from context by JSON path `$[0].text` to SCENARIO variable `schedulerMessageSMS`
Then `${schedulerMessageSMS}` matches `"Please click here to schedule your appointment: https://.*"`
Then `${schedulerMessage}` matches `Please click here to schedule your appointment: https://.*`


Scenario: Open link from the patient's sms message (Step 5)
Meta:
    @severity 1
When I open URL `${schedulerUrl}` in new window
When I wait until element located `xpath(//*[contains(text(), 'get started')])` appears
Then the text 'We're looking forward to taking care of you! Please take a moment to answer a few questions to schedule your appointment.' exists


Scenario: Select "Myself" button for Question 1. Are you scheduling an appointment for yourself or for someone else? (Step 6)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(), 'get started')])`
When I wait until element located `xpath(//*[contains(text(), 'appointment for yourself')])` appears
Then the text 'Are you scheduling an appointment for yourself or for someone else?' exists
When I click on element located `xpath(//*[contains(text(), 'Myself')])`
When I wait until element located `xpath(//*[contains(text(), 'returning patient')])` appears
Then the text 'Are you a returning patient?' exists


Scenario: Select "Yes" button for Question 2. Are you a returning patient? (Step 7)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(), 'Yes')])`
When I wait until element located `xpath(//*[contains(text(), 'How old')])` appears
Then the text 'How old are you?' exists


Scenario: Select "0-16 years old" button for Question 3. How old are you? (Step 8)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(), '0-16 years old')])`
When I wait until element located `xpath(//*[contains(text(), 'surgery before')])` appears
Then the text 'Have you had surgery before?' exists


Scenario: Select "Yes" button for Question 4. Have you had surgery before? (Step 9)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(), 'Yes')])`
When I wait until element located `xpath(//*[contains(text(), 'reason')])` appears
Then the text 'What is the reason for your visit?' exists


Scenario: Select "Headaches/migraines" button for Question 5. What is the reason for your visit? (Step 10)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(), 'Headaches')])`
When I wait until element located `xpath(//*[contains(text(), 'insurance carrier')])` appears
Then the text 'Who is your insurance carrier?' exists


Scenario: Select "Medicaid/Medicare" button for Question 6. Who is your insurance carrier? (Step 11)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(), 'Medicaid')])`
When I wait until element located `xpath(//*[contains(text(), 'Embarcadero Wellness')]/ancestor::ul/parent::div/parent::div)` appears
Then the text 'Please select a time. You'll request your appointment on the next page.' exists


Scenario: Select an appointment opening time slot button for Barton DemoClinton (Step 12)
Meta:
    @severity 1
When I change context to element located `xpath((//ul/descendant::*[contains(text(), 'Barton DemoClinton')]/parent::div/following-sibling::div/button)[1])`
When I save text of context element to STORY variable `newTime`
When I reset context
When I initialize the STORY variable `timeConfirmation` with value `#{replaceAllByRegExp((\d+:\d+).*, $1, ${newTime})}`
When I initialize the STORY variable `dayTimeConfirmation` with value `#{replaceAllByRegExp(\d+:\d+(\w+), $1, ${newTime})}`
When I click on element located `xpath((//ul/descendant::*[contains(text(), 'Barton DemoClinton')]/parent::div/following-sibling::div/button)[1])`
When I wait until element located `xpath(//*[contains(text(), 'Review and book')]/parent::div/div/descendant::*[contains(text(), 'SEND APPOINTMENT REQUEST')])` appears
Then field located `xpath(//*[contains(text(),'${timeConfirmation} ${dayTimeConfirmation}')])` exists
Then field located `xpath(//*[contains(text(), 'Facility')]/following-sibling::p[contains(text(), '${facilityNameVariable1}')])` exists
Then field located `xpath(//*[contains(text(), 'Provider')]/following-sibling::p[contains(text(), 'Barton DemoClinton')])` exists


Scenario: Click the "Send appointment request" button and verify the patient receives the message (Step 13)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(), 'Review and book')]/parent::div/div/descendant::*[contains(text(), 'SEND APPOINTMENT REQUEST')])`
When I wait until element located `xpath(//*[contains(text(), 'Your appointment time is reserved')])` appears
Then the text 'Your appointment time is reserved' exists
Then the text 'but not confirmed' exists
When I close the current window
When I switch to window with title that CONTAINS `Luma Health`
When I wait until element located `xpath(//*[contains(text(),'hecking with the front')])` appears
When I change context to element located `xpath(//*[contains(text(),'hecking with the front')])`
When I save text of context element to SCENARIO variable `informationMessage`
When I reset context
When I save access token from application storage to STORY variable 'accessToken'
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
Then `${informationMessage}` matches `Thanks. We're checking with the front office and will send you another message when confirmed.`
Then the response body contains 'Thanks. We're checking with the front office and will send you another message when confirmed.'


Scenario: Slect the "Activity Feed" link in the left navigation (Step 14)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Activity Feed')])`
When I wait until element located `xpath(//*[contains(text(),'Activity for Today')])` appears
When I change context to element located `xpath(//*[contains(text(),'Waiting')]/preceding-sibling::p)`
When I save text of context element to SCENARIO variable `acceptanceMessage`
When I reset context
Then `${acceptanceMessage}` matches `Patient ${firstName} ${lastName} accepted the open slot with Barton DemoClinton on.* ${timeConfirmation} ${dayTimeConfirmation}`


Scenario: Click the "accept" icon to accept the new open slot with Barton DemoClinton (Step 15)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Accept')])`
When I wait until element located `xpath(//*[contains(text(), 'approved the booked availability')])` appears
When I change context to element located `xpath(//*[contains(text(), 'approved the booked availability')])`
When I save text of context element to SCENARIO variable `acceptedStatusMessage`
When I reset context
Then `${acceptedStatusMessage}` matches `${practiceName} approved the booked availability for patient ${firstName} ${lastName} on.* ${timeConfirmation} ${dayTimeConfirmation} for Barton DemoClinton at Embarcadero Wellness`
Given I am on a page with the URL '${baseApplicationUrl}/patients/${patientId}/chat'
When I wait until element located `xpath(//*[contains(text(),'has been booked')])` appears
When I change context to element located `xpath(//*[contains(text(),'has been booked')])`
When I save text of context element to SCENARIO variable `confirmationMessage`
When I reset context
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
When I save JSON element from context by JSON path `$[0].text` to SCENARIO variable `confirmationMessageSMS`
Then `${confirmationMessageSMS}` matches `"Thanks. You're all set and your appointment on.*has been booked."`
Then `${confirmationMessage}` matches `Thanks. You're all set and your appointment on.*has been booked.`
