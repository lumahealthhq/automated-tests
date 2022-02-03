Description: Story performs verification of testcase "5.0 Send a Patient Telehealth Session Reminder Magic Button" (TestCaseId=9)
Meta:
    @epic Sanity
    @feature Telehealth
    @testCaseId 9


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
When I use magic button `patientTelehealthSessionReminder` for the current patient
When I switch to window with title that CONTAINS `Luma Health`
When I wait until element located `xpath(//*[contains(text(),'telehealth appt')])` appears
When I change context to element located `xpath(//*[contains(text(),'telehealth appt')])`
When I save text of context element to SCENARIO variable `telehealthSessionMessage`
When I reset context
When I save access token from application storage to STORY variable 'accessToken'
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
When I save JSON element from context by JSON path `$[0].text` to SCENARIO variable `telehealthSessionMessageSMS`
Then `${telehealthSessionMessageSMS}` matches `".*${practiceName}: Hi ${firstName}.* Please log in here to get connected: https://.*"`
Then `${telehealthSessionMessage}` matches `${practiceName}: Hi ${firstName}, your telehealth appt with.*will begin in 30 mins. Please log in here to get connected: https://.*`


Scenario: Click 'Schedule' in the left hand side navigation menu (Step 4)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Schedule')])`
When I wait until element located `xpath(//*[contains(text(), 'Filters')])` appears
Then the text 'SCHEDULE FOR TODAY' exists


Scenario: Select the Filters button (Step 5)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(), 'Filters')])`
When I wait until element located `xpath(//*[@placeholder='Search'])` appears
Then field located `xpath(//h1[contains(text(), 'Filters')])` exists


Scenario: Select 'Appt Type' then uncheck the 'Select All' check box, then select the 'Telehealth' button and the 'Apply Filters' button (Step 6)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(), 'Appt Type')])`
When I wait until element located `xpath(//*[contains(text(), 'Telehealth')])` appears
When I click on element located `xpath(//*[contains(text(), 'Select All')]/preceding-sibling::span)`
When I click on element located `xpath(//*[@role='button']/*[contains(text(), 'Telehealth')])`
When I click on element located `xpath(//*[contains(text(), 'Apply Filters')])`
When I wait until element located `xpath(//*[contains(text(), 'Telehealth Appointment')]/ancestor::ul)` appears
Then the text '${lastName}, ${firstName}' exists


Scenario: Select the 'Scheduled' icon button on the right and copy the provider link and paste in an incognito window (Step 7)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(), '${lastName}, ${firstName}')]/ancestor::li/descendant::*[contains(text(), 'Scheduled')]/parent::div/button/span[1])`
When I wait until element located `xpath(//*[contains(text(), 'Provider link')])` appears
When I save `value` attribute value of element located `xpath(//*[contains(text(), 'Provider link')]/parent::div/descendant::*[contains(@value, 'https')])` to STORY variable `providerLinkUrl`
When I save `value` attribute value of element located `xpath(//*[contains(text(), 'Patient link')]/parent::div/descendant::*[contains(@value, 'https')])` to STORY variable `patientLinkUrl`
Given I am on a page with the URL '${providerLinkUrl}'
When I wait until element located `xpath(//*[contains(text(), '${lastName}, ${firstName}')]/ancestor::li/descendant::*[contains(text(), 'Join Session')])` appears
Then the text 'SCHEDULE FOR TODAY' exists
When I change context to element located `xpath(//*[@data-lh-id='header-user-menu-button']/span[text()])`
When I save text of context element to STORY variable `providerName`
When I reset context


Scenario: Click the 'Join Session' button for your patient's telehealth appointment (Step 8)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(), '${lastName}, ${firstName}')]/ancestor::li/descendant::*[contains(text(), 'Join Session')])`
When I switch to window with title that CONTAINS `Luma Health`
Given I am on a page with the URL '${patientLinkUrl}'
When I switch to window with title that CONTAINS `Luma Health`
When I wait until element located `xpath(//*[contains(text(), '${firstName}')])` appears
Then the text '${firstName} ${lastName}' exists
Then the text 'In order to access the telehealth session, you must allow access to your microphone and camera.' exists


Scenario: Click the 'Allow microphone and camera' button (Step 9)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(), 'Allow microphone and camera')])`
When I wait until element located `xpath(//button/*[contains(text(), 'Join Now')])` appears
Then field located `xpath(//video[@playsinline])` exists


Scenario: Click the 'Join Now' button (Step 10)
Meta:
    @severity 1
When I click on element located `xpath(//button/*[contains(text(), 'Join Now')])`
When I wait until element located `xpath(//*[@data-lh-id='ScreenButton']/parent::div)` appears
Then field located `xpath(//*[@id='telehealth-container'])` exists
Then field located `xpath(//video[@playsinline])` exists


Scenario: Run telehealth session for patient (Step 11)
Meta:
    @severity 1
When I switch to window with title that CONTAINS `Patient App`
Then the text 'Welcome to your Telehealth appointment, ${firstName} ${lastName}!' exists
Then the text '${providerName}' exists
When I click on element located `xpath(//*[contains(text(), 'Allow microphone and camera')])`
Then field located `xpath(//video[@playsinline])` exists
When I wait until element located `xpath(//*[contains(text(), 'Waiting...')])` disappears
When I wait until element located `xpath(//*[@data-lh-id='ScreenButton']/parent::div)` appears
Then field located `xpath(//*[@id='telehealth-container'])` exists
Then number of elements found by `xpath(//video[@playsinline])` is > `1`
