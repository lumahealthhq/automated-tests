Description: Story performs verification of testcase "2.1 Reply = Yes Insurance Card Upload" (TestCaseId=26)
Meta:
    @epic Sanity
    @feature Reminder
    @testCaseId 26


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
When I open URL `${insuranceCardUploadMagicButtonUrl}` in new window
When I wait until the page has the title 'Luma Health Magic Buttons'
When I change context to element located `xpath(//h4)`
When I save text of context element to SCENARIO variable `magicButtonMessage`
When I reset context
Then `${magicButtonMessage}` matches `Thanks you! Your magic request to send patientReminderConfirmationThanks to demo patient .* has been processed.`
When I close the current window
When I switch to window with title that CONTAINS `Luma Health`
When I wait until element located `xpath(//*[contains(text(),'Thank you for confirming')])` appears
When I change context to element located `xpath(//*[contains(text(),'Thank you for confirming')])`
When I save text of context element to SCENARIO variable `insuranceUploadMessage`
When I initialize the STORY variable `insuranceUrl` with value `#{replaceAllByRegExp((.*)(https://.*), $2, ${insuranceUploadMessage})}`
When I reset context
When I save access token from application storage to STORY variable 'accessToken'
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
When I save JSON element from context by JSON path `$[0].text` to SCENARIO variable `insuranceUploadMessageSMS`
Then `${insuranceUploadMessageSMS}` matches `"Thank you for confirming your appointment. To ensure a quick check-in, please upload your insurance card here: https://.*"`
Then `${insuranceUploadMessage}` matches `Thank you for confirming your appointment. To ensure a quick check-in, please upload your insurance card here: https://.*`


Scenario: Search patient > Click 'Appointment' tab (Step 4)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(), 'Find patients by name')]/following-sibling::input)`
When I enter `${firstName}` in field located `xpath(//*[contains(text(), 'Find patients by name')]/following-sibling::input)`
When I wait until element located `xpath(//*[text()='${firstName}'])` appears
When I click on element located `xpath(//span[text()='${firstName}'])`
When I wait until element located `xpath(//*[@role='tablist'])` appears
When I click on element located `xpath(//*[text()='appointments']/ancestor::button)`
When I wait until element located `xpath(//*[text()='Schedule appointment'])` appears
Then field located `xpath(//*[contains(text(), 'Upcoming Appointments')]/parent::div/following-sibling::div/descendant::*[contains(text(), 'Confirmed')])` exists


Scenario: Open link from Patient's sms (Step 5)
Meta:
    @severity 1
Given I am on a page with the URL '${insuranceUrl}'
Then the page with the URL containing 'patient.lumahealthdemo' is loaded
Then field located `xpath(//*[contains(text(), 'Patient First Name')])` exists
