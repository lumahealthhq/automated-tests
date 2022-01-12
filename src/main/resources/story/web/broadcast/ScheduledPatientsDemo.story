Description: Story performs verification of testcase "Scheduled Patients (Demo)" (TestCaseId=36)
Meta:
    @epic Sanity
    @feature Broadcast
    @testCaseId 36


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


Scenario: Click the 'Broadcast' button in the left navigation (Step 3)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Broadcasts')])`
When I wait until element located `xpath(//*[@data-lh-id='button-send-broadcast']/span[contains(text(), 'Send a broadcast')])` appears
Then field located `xpath(//h6[contains(text(),'Broadcasts')])` exists


Scenario: Click the 'Send a broadcast' button then click the "Scheduled patients" button and then click the "Continue" button (Step 4-5)
Meta:
    @severity 1
When I click on element located `xpath(//*[@data-lh-id='button-send-broadcast']/span[contains(text(), 'Send a broadcast')])`
When I wait until element located `xpath(//*[contains(text(), 'Scheduled patients')]/ancestor::button)` appears
Then the text 'Who do you want to message?' exists
When I click on element located `xpath(//*[contains(text(), 'Scheduled patients')]/ancestor::button)`
When I click on element located `xpath(//*[contains(text(), 'Continue')])`
When I wait until element located `xpath(//*[contains(text(), 'Select all')])` appears
Then field located `xpath(//*[contains(text(),'Select Patients')])` exists


Scenario: Click the check box for the first and last name that you used in step 2 (Step 6)
Meta:
    @severity 1
When I check checkbox located by `xpath(//*[contains(text(),'${firstName} ${lastName}')]/preceding-sibling::td)`
Then the text '1 patient will be messaged' exists


Scenario: Click the "Next" button at the bottom right of the screen (Step 7)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Next')])`
When I wait until element located `xpath(//*[@name='title'])` appears
Then the text 'Broadcast Title' exists


Scenario: Click the Title field and enter any title for your broadcast (Step 8)
Meta:
    @severity 1
When I click on element located `xpath(//*[@name='title' and @aria-invalid='true'])`
When I initialize the STORY variable `broadcastTitle` with value `#{generate(regexify '[A-Z0-9]{10}')}`
When I enter `${broadcastTitle}` in field located `xpath(//*[@name='title'])`
Then field located `xpath(//*[@value='${broadcastTitle}' and @aria-invalid='false'])` exists


Scenario: For the Message field select the Message Library button (Step 9)
Meta:
    @severity 1
When I click on element located `xpath(//*[@aria-label='message-library'])`
When I wait until element located `xpath(//*[contains(text(), 'COVID-19 Office Closure')])` appears
Then the text 'Select message from library' exists


Scenario: Select the button for "COVID-19 Office Closure" then click the "Select" button (Step 10)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(), 'COVID-19 Office Closure')]/ancestor::span/preceding-sibling::span/descendant::input/parent::span)`
When I click on element located `xpath(//*[@type='submit']/span[contains(text(), 'Select')])`
Then the text 'Hello {{patient.firstname}}, this is {{user.name}}. You and your family's safety is very important to us. We regret to inform you that we are temporarily closing {{user.name}} in order to minimize the risk of patient exposure to COVID-19. If you have questions or need to reschedule please call {{facility.phone}} or visit the Centers for Disease Control for more information: https://www.cdc.gov/coronavirus/2019-nCoV/' exists


Scenario: Click the "Send now" button at the bottom right of the screen (Step 11)
Meta:
    @severity 1
When I click on element located `xpath(//button/*[contains(text(), 'Send now')])`
When I wait until element located `xpath(//*[contains(text(), 'Confirm Broadcast')])` appears
When I change context to element located `xpath(//*[contains(text(), 'Confirm Broadcast')]/parent::div/parent::div)`
Then the text 'Hello {{patient.firstname}}, this is {{user.name}}. You and your family's safety is very important to us. We regret to inform you that we are temporarily closing {{user.name}} in order to minimize the risk of patient exposure to COVID-19. If you have questions or need to reschedule please call {{facility.phone}} or visit the Centers for Disease Control for more information: https://www.cdc.gov/coronavirus/2019-nCoV/' exists
When I reset context


Scenario: Click the "Process the broadcast" button (Step 12)
Meta:
    @severity 1
When I click on element located `xpath(//button/*[contains(text(), 'Process the broadcast')])`
When I wait until element located `xpath(//*[contains(text(), '${broadcastTitle}')])` appears
Then the text 'Sending Message' exists
When I click on element located `xpath(//*[contains(text(),'Hub')])`
When I wait until element located `xpath(//*[@name='messageInput'])` appears
When I click on element located `xpath(//*[@role='button']//*[contains(text(),'${lastName}')])`
When I initialize the STORY variable `patientId` with value `#{replaceAllByRegExp((.*patient=)(.*), $2, ${current-page-url})}`
Given I am on a page with the URL '${baseApplicationUrl}/patients/${patientId}/chat'
When I wait until element located `xpath(//*[contains(text(),'exposure to COVID-19')])` appears
When I change context to element located `xpath(//*[contains(text(),'exposure to COVID-19')])`
When I save text of context element to SCENARIO variable `covidMessage`
When I reset context
When I save access token from application storage to STORY variable 'accessToken'
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
When I save JSON element from context by JSON path `$[0].text` to SCENARIO variable `covidMessageSMS`
Then `${covidMessageSMS}` matches `"Hello ${firstName}, this is ${practiceName}. You and your family's safety is very important to us. We regret to inform you that we are temporarily closing ${practiceName} in order to minimize the risk of patient exposure to COVID-19. If you have questions or need to reschedule please call \+\d\ \d{3}-\d{3}-\d{4}\ or visit the Centers for Disease Control for more information: https://www.cdc.gov/coronavirus/2019-nCoV/"`
Then `${covidMessage}` matches `Hello ${firstName}, this is ${practiceName}. You and your family's safety is very important to us. We regret to inform you that we are temporarily closing ${practiceName} in order to minimize the risk of patient exposure to COVID-19. If you have questions or need to reschedule please call \+\d\ \d{3}-\d{3}-\d{4}\ or visit the Centers for Disease Control for more information: https://www.cdc.gov/coronavirus/2019-nCoV/`
