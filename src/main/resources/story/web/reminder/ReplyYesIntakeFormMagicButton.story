Description: Story performs verification of testcase "1.1 Reply = Yes Intake Form Magic Button" (TestCaseId=22)
Meta:
    @epic Sanity
    @feature Reminder
    @testCaseId 22


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
Given I log into application with firstName '${firstName}' lastName '${lastName}' practiceName '${practiceName}' phoneNumber '${phoneNumber}' and parameters '#{loadResource(/templates/initialDataConfigurationWithTenPatients.json)}'


Scenario: Run magic button and message via Textnow (Step 3)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Hub')])`
When I wait until element located `xpath(//*[@name='messageInput'])` appears
When I click on element located `xpath(//*[@role='button']//*[contains(text(),'${lastName}')])`
When I initialize the STORY variable `patientId` with value `#{replaceAllByRegExp((.*patient=)(.*), $2, ${current-page-url})}`
Given I am on a page with the URL '${baseApplicationUrl}/patients/${patientId}/chat'
When I open URL `${baseApiUrl}/demoUsers/${oppid}/messages/patientReminderConfirmationThanks?type=intake` in new window
When I wait until the page has the title 'Luma Health Magic Buttons'
When I change context to element located `xpath(//h4)`
When I save text of context element to SCENARIO variable `magicButtonMessage`
When I reset context
Then `${magicButtonMessage}` matches `Thanks you! Your magic request to send patientReminderConfirmationThanks to demo patient .* has been processed.`
When I close the current window
When I switch to window with title that CONTAINS `Luma Health`
When I wait until element located `xpath(//*[contains(text(),'Thank you for confirming your appointment')])` appears
When I change context to element located `xpath(//*[contains(text(),'Thank you for confirming your appointment')])`
When I save text of context element to SCENARIO variable `uploadMessage`
When I initialize the STORY variable `urlVariable` with value `#{replaceAllByRegExp((.*)(https://.*), $2, ${uploadMessage})}`
When I reset context
When I save access token from application storage to STORY variable 'accessToken'
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
Then JSON element by JSON path `$..text` is equal to `["${uploadMessage}"]`IGNORING_ARRAY_ORDER,IGNORING_EXTRA_ARRAY_ITEMS


Scenario: Verify that message is displayed in the Patient's chat history (Step 4)
Meta:
    @severity 1
Given I am on a page with the URL '${baseApplicationUrl}/patients/${patientId}/chat'
When I wait until element located `xpath(//*[contains(text(),'Thank you for confirming your appointment. Please complete our new patient forms prior to your visit here: https')])` appears
Then number of elements found by `By.xpath(//*[contains(text(),'Thank you for confirming your appointment. Please complete our new patient forms prior to your visit here: https')])` is equal to `1`


Scenario: Verify Appointment confirmation status (Step 5)
Meta:
    @severity 1
Given I am on a page with the URL '${baseApplicationUrl}/patients/${patientId}/appointments'
When I wait until element located `xpath(//*[contains(text(),'Upcoming Appointments')])` appears
Then field located `xpath(//*[contains(text(), 'Upcoming Appointments')]/parent::div/following-sibling::div/descendant::*[contains(text(), 'Confirmed')])` exists
