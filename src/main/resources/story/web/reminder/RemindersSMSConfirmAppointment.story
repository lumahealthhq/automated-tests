Description: Story performs verification of testcase "Reminders SMS Confirm Appointment" (TestCaseId=13)
Meta:
    @epic Sanity
    @feature Reminder
    @testCaseId 13


Scenario: Open main application page (Step 1)
Meta:
    @severity 1
When I initialize the STORY variable `oppidVariable` with value `#{${randomOppid}}`
Given I am on a page with the URL '${mainPageUrl}${oppidVariable}'
When I refresh the page


Scenario: Log into application (Step 2)
Meta:
    @severity 1
When I initialize the STORY variable `firstName` with value `#{generate(name.firstName)}ATCreated`
When I initialize the STORY variable `lastName` with value `#{generate(name.lastName)}ATCreated`
When I initialize the STORY variable `phoneNumber` with value `#{${dummyPhoneNumbersVariety1}}`
When I initialize the STORY variable `practiceName` with value `#{generate(regexify '[a-zA-Z0-9]{10}')}`
Given I log into application with firstName '${firstName}' lastName '${lastName}' practiceName '${practiceName}' phoneNumber '${phoneNumber}' and parameters '#{loadResource(/templates/minimumInitialDataConfiguration.json)}'


Scenario: Click 'Select multiple patients' and load 'Patients' page (Step 3)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(), 'Find patients by name')]/following-sibling::input)`
When I wait until element located `xpath(//*[text()='Select multiple patients'])` appears
When I click on element located `xpath(//*[text()='Select multiple patients'])`
When I wait until element located `xpath(//*[contains(text(),'Add patient')])` appears
Then the page with the URL containing '/patients' is loaded


Scenario: Open 'Profile' page (Step 4)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Add patient')])`
When I wait until element located `xpath(//*[contains(text(),'Profile')])` appears
Then the page with the URL containing 'patients/add' is loaded


Scenario: Fill in First Name, Last Name, Date of Birth (Step 5)
Meta:
    @severity 1
When I initialize the STORY variable `patientFirstName` with value `#{generate(name.firstName)}ATCreated`
When I initialize the STORY variable `patientLastName` with value `#{generate(name.lastName)}ATCreated`
When I enter `${patientFirstName}` in field located `xpath(//*[@name='firstname'])`
When I enter `${patientLastName}` in field located `xpath(//*[@name='lastname'])`
When I enter `#{generateDate(-P30Y, MM/dd/yyyy)}` in field located `xpath(//*[@placeholder='mm/dd/yyyy'])`
When I initialize the SCENARIO variable `patinetPhone` with value `#{${dummyPhoneNumbersVariety2}}`
When I enter `#{replaceFirstByRegExp((..)(.*), $2, ${patinetPhone})}` in field located `xpath(//*[@type='tel'])`
When I click on element located `xpath(//*[text()='Save'])`
When I wait until element located `xpath(//*[text()='Patients'])` appears
Then the page with the URL containing '/patients' is loaded


Scenario: Search for created patient and open Patient's profile (Step 6)
Meta:
    @severity 1
When I enter `${patientFirstName}` in field located `xpath(//*[contains(text(), 'Find patients by name')]/following-sibling::input)`
When I wait until element located `xpath(//*[contains(text(),'${patientLastName}')])` appears
When I click on element located `xpath(//*[contains(text(),'${patientLastName}')])`
When I wait until element located `xpath(//*[text()='${patientLastName}'])` appears
Then the text '${patientLastName}, ${patientFirstName}' exists


Scenario: Select 'Edit patient information' of 3 dots image and open profile for the patient (Step 7)
Meta:
    @severity 1
When I click on element located `xpath(//*[@aria-label='More'])`
When I wait until element located `xpath(//*[text()='Edit patient information'])` appears
When I click on element located `xpath(//*[contains(text(),'Edit patient information')])`
When I wait until element located `xpath(//*[contains(text(),'Profile for ${patientFirstName} ${patientLastName}')])` appears
Then the text 'Profile for ${patientFirstName} ${patientLastName}' exists


Scenario: Select 'SMS' contact method and click 'Save' (Step 8)
Meta:
    @severity 1
When I enter `${patientFirstName}` in field located `xpath(//*[@name='firstname'])`
When I click on element located `xpath(//*[@class='Select-control']/ancestor::div[5]/following-sibling::div[2]//*[@class='Select-control'])`
When I click on element located `xpath(//*[@class='Select-menu-outer']//*[contains(text(),'SMS')])`
When I click on element located `xpath(//*[text()='Save'])`
When I wait until element located `xpath(//*[text()='${patientLastName}'])` appears


Scenario: Open 'APPOINTMENTS' tab (Step 9)
Meta:
    @severity 1
When I click on element located `xpath(//*[text()='appointments'])`
When I wait until element located `xpath(//*[contains(text(),'Schedule appointment')]/..)` appears


Scenario: Click 'Schedule appointment' tab and open 'SELECT AN APPOINTMENT FOR *PATIENT*' page (Step 10)
Meta:
    @severity 1
When I click on element located `xpath(//*[text()='Schedule appointment'])`
When I wait until element located `xpath(//h6[contains(text(),'Select an appointment for')])` appears
When I wait until element located `xpath(//*[contains(text(),'${patientFirstName} ${patientLastName}')])` appears


Scenario: Complete scheduling appointment and open 'APPOINTMENTS' tab  (Step 11)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Hub')])`
When I wait until element located `xpath(//*[@name='messageInput'])` appears
When I click on element located `xpath(//*[@role='button']//*[contains(text(),'${lastName}')])`
When I initialize the STORY variable `patientId` with value `#{replaceAllByRegExp((.*patient=)(.*), $2, ${current-page-url})}`
When I open URL `${addNewAppointmentUrl}` in new window
When I enter `${patientFirstName} ${patientLastName}` in field located `xpath(//*[@id='id_patient'])`
When I wait until element located `xpath(//*[contains(text(),'${patientFirstName} ${patientLastName}')])` appears
When I click on element located `xpath(//*[contains(text(),'${patientFirstName} ${patientLastName}')])`
When I click on element located `xpath(//*[@id='id_provider'])`
When I wait until element located `xpath(//*[text()='Barton DemoClinton'])` appears
When I click on element located `xpath(//*[text()='Barton DemoClinton'])`
When I click on element located `xpath(//*[@id='id_dateAndTime'])`
When I wait until element located `xpath(//*[contains(text(),'Mo')])` appears
When I click on element located `xpath(//*[text()='PM'])`
When I click on element located `xpath(//*[@id='id_type'])`
When I wait until element located `xpath(//*[contains(text(),'Checkup')])` appears
When I click on element located `xpath(//*[contains(text(),'Checkup')])`
When I click on element located `xpath(//*[@id='id_status'])`
When I click on element located `xpath(//*[@id='id_status'])`
When I click on element located `xpath(//*[text()='Save'])`
When I wait until element located `xpath(//a[@class='appointment-add-btn btn btn-success inline-block btn-add'])` appears
When I close the current window
Given I am on a page with the URL '${baseApplicationUrl}/patients/${patientId}/appointments'
When I refresh the page
When I wait until element located `xpath(//*[text()='Upcoming Appointments'])` appears
When I wait until element located `xpath(//*[contains(text(), "Unconfirmed")])` appears


Scenario: Select 'Mission Control' and open 'Home' page  (Step 12)
Meta:
    @severity 1
When I click on element located `xpath(//*[@type='button']//*[contains(text(),'#{capitalizeFirstWord(${practiceName})}')])`
When I wait until element located `xpath(//*[contains(text(),'Mission Control')])` appears
When I click on element located `xpath(//*[text()='Mission Control'])`
When I wait until element located `xpath(//*[contains(text(),'My Account')])` appears
Then the page with the URL containing '/home' is loaded


Scenario: Select 'Feature Settings' > 'General' and open 'GENERAL SETTINGS' page (Step 13)
Meta:
    @severity 1
When I click on element located `xpath(//*[@role='button']//*[contains(text(),'Feature Settings')])`
When I wait until element located `xpath(//*[contains(text(),'General')])` appears
When I click on element located `xpath(//*[text()='General'])`
When I wait until element located `xpath(//h1[contains(text(),'General Settings')])` appears
Then the page with the URL containing '/settings/features/general' is loaded


Scenario: Select time zone from 'What timezone should be applied to your account?' field (Step 14)
Meta:
    @severity 1
When I change context to element located `xpath(//*[contains(text(),'Select the timezone to apply to your account.')]/../..)`
When I click on element located `xpath(//div[@id='react-select-2--value'])`
When I wait until element located `xpath(//*[contains(text(),'Europe/Minsk')])` appears
When I click on element located `xpath(//*[contains(text(),'Europe/Minsk')])`
When I reset context


Scenario: Click 'Save' button and 'Settings saved successfully' message is appeared (Step 15)
Meta:
    @severity 1
When I click on element located `xpath(//p[contains(text(),'Save')])`
When I wait until element located `xpath(//*[@class='notification-title']/[text()='Settings saved successfully.'])` appears
Then element located `xpath(//*[contains(text(),'Notification'])` exists for `PT1S` duration
When I reset context


Scenario: Select 'Messaging Activity' and load 'Messaging Activity' (Step 16)
Meta:
    @severity 1
When I initialize the SCENARIO variable `practiceNameVariable` with value `#{eval(stringUtils:substring('${practiceName}', 0, 1))}`
When I initialize the SCENARIO variable `practiceNameVariable` with value `#{capitalizeFirstWord(${practiceNameVariable})}`
When I click on element located `xpath(//*[@type='button']//*[text()='${practiceNameVariable}'])`
When I wait until element located `xpath(//*[contains(text(),'Messaging Activity')])` appears
When I click on element located `xpath(//*[text()='Messaging Activity'])`
When I wait until element located `xpath(//*[contains(text(),'Messaging Activity')])` appears
Then the page with the URL containing 'messaging-activity/summary' is loaded


Scenario: Open 'Next Reminders' (Step 17)
Meta:
    @severity 1
When I change context to element located `xpath(//h6[contains(text(),'Messaging Activity')]/..)`
When I click on element located `xpath(//div[@role='tablist']//*[text()='Next Reminders'])`
When I reset context
When I wait until element located `xpath(//p[text()='Next Reminders'])` appears


Scenario: Find the patient in the list (Step 18)
Meta:
    @severity 1
When I wait until element located `xpath(//td[text()='${firstName} ${lastName}'])` appears
Then the text '${firstName} ${lastName}' exists


Scenario: Click on 3 dots and 'Send Now' button is displayed (Step 19)
Meta:
    @severity 1
When I change context to element located `xpath(//*[text()='${firstName} ${lastName}']/following-sibling::td[5])`
When I click on element located `xpath(//*[text()='${firstName} ${lastName}']/following-sibling::td[5])`
When I wait until element located `xpath(//*[contains(text(),'Send now')])` appears


Scenario: Click 'Send now' and pop-up appears (Step 20)
Meta:
    @severity 1
When I click on element located `xpath(//*[text()='Send now'])`
When I reset context
When I wait until element located `xpath(//div[@role='dialog'])` appears
When I change context to element located `xpath(//*[@role='document'])`
Then the text 'Send reminder now?' exists
When I save text of context element to SCENARIO variable `messageText`
Then `${messageText}` matches `Send reminder now? This reminder is scheduled to be sent at.*. Would you like to send it now instead? Do nothing Yes, send now`


Scenario: Click 'Yes, send now' and the Patient receives reminder via SMS (Step 21)
Meta:
    @severity 1
When I click on element located `xpath(//*[text()='Yes, send now'])`
Given I am on a page with the URL '${baseApplicationUrl}/patients/${patientId}/chat'
When I wait until element located `xpath(//*[contains(text(),'Thanks for coming')])` appears
When I change context to element located `xpath(//*[contains(text(),'Thanks for coming')])`
When I save text of context element to SCENARIO variable `reminderMessage`
When I save access token from application storage to STORY variable 'accessToken'
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
Then JSON element by JSON path `$[0].text` is equal to `"${reminderMessage}"`TREATING_NULL_AS_ABSENT


Scenario: Patient accepts appointment and Next appointment status changes on confirmed (Step 22)
Meta:
    @severity 1
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
When I save JSON element from context by JSON path `$[0].from` to SCENARIO variable `fromPhoneNumber`
When I initialize the SCENARIO variable `fromPhoneNumber` with value `#{replaceAllByRegExp((\s*\-*), """""", #{removeWrappingDoubleQuotes(${fromPhoneNumber})})}`
When I save JSON element from context by JSON path `$[0].externalId.value` to SCENARIO variable `messageId`
When I initialize the SCENARIO variable `messageId` with value `#{removeWrappingDoubleQuotes(${messageId})}`
Given I reply on message with id '${messageId}' with text 'yes' as patient with phoneNumber '${phoneNumber}' to recipient with phoneNumber '${fromPhoneNumber}'
Given I am on a page with the URL '${baseApplicationUrl}/patients/${patientId}/appointments'
When I wait until element located `xpath(//*[text()='Upcoming Appointments'])` appears
When I wait until element located `xpath(//*[contains(text(), "Confirmed")]/ancestor::td)` appears
