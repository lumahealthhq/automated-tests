Description: Story performs verification of testcase "2.2 Reply = No Late Cancellation Notice" (TestCaseId=27)
Meta:
    @epic Sanity
    @feature Reminder
    @testCaseId 27


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
When I use magic button `patientReminderCancellationNoShow` for the current patient
When I switch to window with title that CONTAINS `Luma Health`
When I wait until element located `xpath(//*[contains(text(),'Thanks for canceling')])` appears
When I change context to element located `xpath(//*[contains(text(),'Thanks for canceling')])`
When I save text of context element to SCENARIO variable `cancellationMessage`
When I reset context
When I save access token from application storage to STORY variable 'accessToken'
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
When I save JSON element from context by JSON path `$[0].text` to SCENARIO variable `cancellationMessageSMS`
Then `${cancellationMessageSMS}` matches `"Thanks for canceling. Since this is so close to your appointment, you may be subject to a late cancellation fee. If you have questions please call \+\d\ \d{3}-\d{3}-\d{4}\."`
Then `${cancellationMessage}` matches `Thanks for canceling. Since this is so close to your appointment, you may be subject to a late cancellation fee. If you have questions please call \+\d\ \d{3}-\d{3}-\d{4}\.`
