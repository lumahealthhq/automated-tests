Description: Story performs verification of testcase "2.0 Send Appointment Reminder Magic Button" (TestCaseId=25)
Meta:
    @epic Sanity
    @feature Reminder
    @testCaseId 25


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
When I initialize the STORY variable `date` with value `#{generateDate(P2D, LLLL dd, yyyy)}`
Given I log into application with firstName '${firstName}' lastName '${lastName}' practiceName '${practiceName}' phoneNumber '${phoneNumber}' and parameters '#{loadResource(/templates/minimumInitialDataConfiguration.json)}'


Scenario: Run magic button and verify the patient receives the message (Step 3-4)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Hub')])`
When I wait until element located `xpath(//*[@name='messageInput'])` appears
When I click on element located `xpath(//*[@role='button']//*[contains(text(),'${lastName}')])`
When I initialize the STORY variable `patientId` with value `#{replaceAllByRegExp((.*patient=)(.*), $2, ${current-page-url})}`
When I use magic button `patientReminder` for the current patient
When I switch to window with title that CONTAINS `Luma Health`
When I click on element located `xpath(//*[contains(text(), 'Activity Feed')])`
When I enter `${lastName}` in field located `xpath(//*[contains(text(), 'Find patients by name, birthdate or phone numbers...')]/following-sibling::*[@type='text'])`
When I wait until element located `xpath(//*[contains(text(), '${firstName}')])` appears
When I click on element located `xpath(//*[contains(text(), '${firstName}')])`
When I wait until element located `xpath(//*[contains(text(),'Your appt with')])` appears
When I change context to element located `xpath(//*[contains(text(),'Your appt with')])`
When I save text of context element to SCENARIO variable `appointmentMessageText`
When I reset context
When I save access token from application storage to STORY variable 'accessToken'
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
When I save JSON element from context by JSON path `$[0].text` to SCENARIO variable `appointmentMessageSmsText`
Then `${appointmentMessageSmsText}` matches `"Your appt with .*at.*is on.*. Reply YES to confirm or NO to cancel"`
Then `${appointmentMessageText}` matches `Your appt with .*at.*is on.*. Reply YES to confirm or NO to cancel`


Scenario: Reply 'NO' as patient (Step 5)
Meta:
    @severity 1
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
When I save JSON element from context by JSON path `$[0].from` to SCENARIO variable `fromPhoneNumber`
When I initialize the SCENARIO variable `fromPhoneNumber` with value `#{replaceAllByRegExp((\s*\-*), """""", #{removeWrappingDoubleQuotes(${fromPhoneNumber})})}`
When I save JSON element from context by JSON path `$[0].externalId.value` to SCENARIO variable `messageId`
When I initialize the SCENARIO variable `messageId` with value `#{removeWrappingDoubleQuotes(${messageId})}`
Given I reply on message with id '${messageId}' with text 'No' as patient with phoneNumber '${phoneNumber}' to recipient with phoneNumber '${fromPhoneNumber}'
When I wait until element located `xpath(//*[contains(text(),'Embarcadero Wellness: need another')])` appears
Then the text 'Thank you for canceling your appointment.' exists
Then the text 'Embarcadero Wellness: need another or earlier appointment? Reply WAITLIST to get a text when the next available appointment opens up.' exists
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
Then the response body contains 'Thank you for canceling your appointment.'
Then the response body contains 'Embarcadero Wellness: need another or earlier appointment? Reply WAITLIST to get a text when the next available appointment opens up.'


Scenario: Verify Appointment Status (Step 6)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(), 'appointments')])`
When I wait until element located `xpath(//*[contains(text(), "Canceled")]/ancestor::tr)` appears
When I change context to element located `xpath(//*[contains(text(), "Canceled")]/ancestor::tr)`
When I click on element located `xpath(//*[contains(text(), '${date}')])`
When I reset context
Then number of elements found by `xpath(//*[contains(text(), "${firstName} ${lastName}")])` is > `0`
