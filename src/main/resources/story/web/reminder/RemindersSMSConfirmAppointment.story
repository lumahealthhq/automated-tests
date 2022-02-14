Description: Story performs verification of testcase "Reminders SMS Confirm Appointment" (TestCaseId=13)
Meta:
    @epic Sanity
    @feature Reminder
    @testCaseId 13


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


Scenario: Open 'Patient' page by clicking on 'Select multiple patients' button (Step 3)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(), 'Find patients by name')]/following-sibling::input)`
When I wait until element located `xpath(//*[contains(text(),'Select multiple patients')])` appears
When I click on element located `xpath(//*[contains(text(),'Select multiple patients')])`
When I wait until element located `xpath(//*[text()='Patients'])` appears
Then the text 'Patients' exists


Scenario: Click on 'Add patient' button (Step 4)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Add patient')])`
When I wait until element located `xpath(//*[@id='PatientEditForm'])` appears


Scenario: Fill in First Name, Last Name, Date of Birth (Step 5)
Meta:
    @severity 1
When I initialize the STORY variable `patientFirstName` with value `#{generate(name.firstName)}ATCreated`
When I initialize the STORY variable `patientLastName` with value `#{generate(name.lastName)}ATCreated`
When I add new patient with firstname `${patientFirstName}` lastname `${patientLastName}` DOB `#{generateDate(-P30Y, MM/dd/yyyy)}` phoneNumber '${phoneNumber}' and phoneType 'SMS'


Scenario: Search for created patient via Search field and click on the name (Step 6)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(), 'Find patients by name')]/following-sibling::input)`
When I enter `${patientFirstName}` in field located `xpath(//*[contains(text(), 'Find patients by name')]/following-sibling::input)`
When I wait until element located `xpath(//*[contains(text(),'${patientLastName}')])` appears
When I click on element located `xpath(//*[contains(text(),'${patientLastName}')])`
When I wait until element located `xpath(//*[@role='tablist'])` appears
Then the text '${patientLastName}' exists


Scenario: Click on 3 dots image on the upper-right side and click 'Edit patient information' (Step 7)
Meta:
    @severity 1
When I click on element located `xpath(//*[@aria-label='More'])`
When I wait until element located `xpath(//*[contains(text(),'Edit patient information')])` appears
When I click on element located `xpath(//*[contains(text(),'Edit patient information')])`
When I wait until element located `xpath(//*[contains(text(),'Profile for ${patientFirstName} ${patientLastName}')])` appears
Then the text 'Profile for ${patientFirstName} ${patientLastName}' exists


Scenario: Select ‘SMS’ if not selected as contact method and click ‘Save’ (Step 8)
Meta:
    @severity 1
When I resave phoneType `SMS` for the patient


Scenario: Schedule appoinment for the patient (Step 9-11)
Meta:
    @severity 1
When I save access token from application storage to STORY variable 'accessToken'
Given I request created patient id with last name '${patientLastName}' and access token '${accessToken}'
When I save JSON element from context by JSON path `$[0]._id` to STORY variable `patientId`
Given I request provider with name 'Barton DemoClinton' and access token '${accessToken}'
When I save JSON element from context by JSON path `$.response[0]._id` to STORY variable `providerId`
Given I request facility with name 'Embarcadero Wellness' and access token '${accessToken}'
When I save JSON element from context by JSON path `$.response[0]._id` to STORY variable `facilityId`
When I save user id to SCENARIO variable 'userId'
Given I create appointment with facility '#{removeWrappingDoubleQuotes(${facilityId})}' and provider '#{removeWrappingDoubleQuotes(${providerId})}' for patient '#{removeWrappingDoubleQuotes(${patientId})}' and user '${userId}' and access token '${accessToken}'
Given I am on a page with the URL '${baseApplicationUrl}/patients/#{removeWrappingDoubleQuotes(${patientId})}/chat'
When I wait until element located `xpath(//*[@role='tablist'])` appears
When I click on element located `xpath(//*[contains(text(),'appointments')]/ancestor::button)`
When I wait until element located `xpath(//*[contains(text(), 'Embarcadero Wellness')]/ancestor::tr)` appears
Then field located `xpath(//tr/descendant::*[contains(text(), 'Embarcadero Wellness')])` exists
Then field located `xpath(//tr/descendant::*[contains(text(), 'Barton DemoClinton')])` exists
Then field located `xpath(//tr/descendant::*[contains(text(), 'Unconfirmed')])` exists


Scenario: Go to ‘Messaging Activity’ (Step 16)
Meta:
    @severity 1
When I go to the relative URL '/messaging-activity/summary'
When I wait until element located `xpath(//*[@role='tablist'])` appears
Then the text 'Next Reminders' exists


Scenario: Click ‘Next Reminders’ and find your patient in the list (Step 17-18)
Meta:
    @severity 1
When I click on element located `xpath(//span[contains(text(),'Next Reminders')]/parent::span)`
When I wait until element located `xpath(//div/*[contains(text(),'Next Reminders')])` appears
When I click on element located `xpath(//*[contains(text(), 'Filters')])`
When I wait until element located `xpath(//h1[contains(text(), 'Filters')])` appears
When I click on element located `xpath(//*[contains(text(), 'Date Range')])`
When I wait until element located `xpath(//*[contains(text(), 'Next 7 days')])` appears
When I click on element located `xpath((//*[contains(text(), 'Next 7 days')]/preceding-sibling::span/span)[1])`
When I click on element located `xpath(//*[contains(text(), 'Apply Filters')])`
When I enter `${patientLastName}` in field located `xpath(//*[contains(@placeholder,'Search for patient')])`
When I wait until element located `xpath(//*[contains(text(),'${patientFirstName}')])` appears
Then the text '${patientFirstName} ${patientLastName}' exists


Scenario: Click on 3 dots to the right of the selected patient’s name and click ‘Send now‘ (Step 19-20)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(), 'Appointment')]/ancestor::tr/td[contains(text(), '${patientFirstName} ${patientLastName}')]/following-sibling::td/button[@aria-label='More'])`
When I wait until element located `xpath(//*[contains(text(), 'Send now')])` appears
When I click on element located `xpath(//*[contains(text(), 'Send now')])`
Then field located `xpath(//*[contains(text(), 'Send reminder now?')])` exists


Scenario: Click ‘Yes, send now‘ (Step 21)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(), 'Yes, send now')])`
When I wait until element located `xpath(//*[contains(text(), 'Send reminder now?')])` disappears
Then field located `xpath(//*[contains(text(), 'Reminder has been successfully queued for immediate delivery')])` exists
Given I am on a page with the URL '${baseApplicationUrl}/patients/#{removeWrappingDoubleQuotes(${patientId})}/chat'
When I wait until element located `xpath(//*[contains(text(),'Reply YES to confirm or NO to cancel')])` appears
When I change context to element located `xpath(//*[contains(text(),'Reply YES to confirm')])`
When I save text of context element to SCENARIO variable `confirmationMessageText`
When I reset context
Given I request messages for patient with id '#{removeWrappingDoubleQuotes(${patientId})}' and access token '${accessToken}'
When I save JSON element from context by JSON path `$[0].text` to SCENARIO variable `confirmationMessageTextSmsText`
Then `${confirmationMessageTextSmsText}` matches `".*Barton DemoClinton.*. Reply YES to confirm or NO to cancel"`
Then `${confirmationMessageText}` matches `.*Barton DemoClinton.*. Reply YES to confirm or NO to cancel`


Scenario: Patient accepts appointment by replying "Yes" (Step 22)
Meta:
    @severity 1
Given I request messages for patient with id '#{removeWrappingDoubleQuotes(${patientId})}' and access token '${accessToken}'
When I save JSON element from context by JSON path `$[0].from` to SCENARIO variable `fromPhoneNumber`
When I initialize the SCENARIO variable `fromPhoneNumber` with value `#{replaceAllByRegExp((\s*\-*), """""", #{removeWrappingDoubleQuotes(${fromPhoneNumber})})}`
When I save JSON element from context by JSON path `$[0].externalId.value` to SCENARIO variable `messageId`
When I initialize the SCENARIO variable `messageId` with value `#{removeWrappingDoubleQuotes(${messageId})}`
Given I reply on message with id '${messageId}' with text 'yes' as patient with phoneNumber '${phoneNumber}' to recipient with phoneNumber '${fromPhoneNumber}'
When I wait until element located `xpath(//*[contains(text(),'Thank you for confirming your appointment')])` appears
Then the text 'Thank you for confirming your appointment' exists
Given I request messages for patient with id '#{removeWrappingDoubleQuotes(${patientId})}' and access token '${accessToken}'
Then the response body contains 'Thank you for confirming your appointment'
When I click on element located `xpath(//*[contains(text(),'appointments')]/ancestor::button)`
When I wait until element located `xpath(//*[contains(text(), 'Embarcadero Wellness')]/ancestor::tr)` appears
Then field located `xpath(//tr/descendant::*[contains(text(), 'Confirmed')])` exists
