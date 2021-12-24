Description: Story performs verification of testcase "Collaboration Secure Chat" (TestCaseId=2)
Meta:
    @epic Sanity
    @feature SecureChat
    @testCaseId 2


Scenario: Open main application page (Step 1)
Meta:
    @severity 1
Given I am on the main application page


Scenario: Log into application (Step 2)
Meta:
    @severity 1
When I initialize the STORY variable `phoneNumber` with value `#{${dummyPhoneNumbersVariety1}}`
Given I log into application with firstName '#{generate(name.firstName)}' lastName '#{generate(name.lastName)}' practiceName '#{generate(regexify '[a-zA-Z0-9]{5}')}' phoneNumber '${phoneNumber}' and parameters '#{loadResource(/templates/minimumInitialDataConfiguration.json)}'


Scenario: Click 'Hub' button on the left-hand side navigation menu (Step 3)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Hub')])`
When I wait until element located `xpath(//*[@name='messageInput'])` appears


Scenario: Click on search field under 'Collaboration Hub' and try to search for a not existed patient in the search bar (Step 4)
Meta:
    @severity 1
When I enter `#{generate(regexify '[a-zA-Z]{10}')}` in field located `xpath(//*[@placeholder='Search for patient'])`
When I wait until element located `xpath(//*[contains(text(),'0 patients have been found.')])` appears


Scenario: Click on the message 'Can't find the patient you're looking for?' (Step 5)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'looking for?')])`
Then the text 'Create new patient' exists


Scenario: Fill in First Name, Last Name, Date of Birth (Step 6)
Meta:
    @severity 1
When I initialize the STORY variable `patientFirstName` with value `#{generate(name.firstName)}ATCreated`
When I initialize the STORY variable `patientLastName` with value `#{generate(name.lastName)}ATCreated`
When I enter `${patientFirstName}` in field located `xpath(//*[@placeholder='First Name'])`
When I enter `${patientLastName}` in field located `xpath(//*[@placeholder='Last Name'])`
When I enter `#{generateDate(-P30Y, MM/dd/yyyy)}` in field located `xpath(//*[@placeholder='mm/dd/yyyy'])`
When I initialize the SCENARIO variable `patinetPhone` with value `#{${dummyPhoneNumbersVariety2}}`
When I enter `#{replaceFirstByRegExp((..)(.*), $2, ${patinetPhone})}` in field located `xpath(//*[@type='tel'])`
When I click on element located `xpath(//*[@form='formHubAddPatient'])`
When I wait until element located `xpath(//*[@name='messageInput'])` appears
Then the text 'Internal message' exists


Scenario: Click on 3 dots image on the upper-right side and click 'Go to patient profile' (Step 7)
Meta:
    @severity 1
When I click on element located `xpath(//*[@aria-label='More'])`
When I click on element located `xpath(//*[contains(text(),'Go to patient profile')])`
When I close the current window
When I wait until element located `xpath(//*[@name='messageInput'])` appears


Scenario: Click on 3 dots image on the upper-right side and click 'Edit patient information' (Step 8)
Meta:
    @severity 1
When I click on element located `xpath(//*[@aria-label='More'])`
When I wait until element located `xpath(//*[contains(text(),'Edit patient information')])` appears
When I click on element located `xpath(//*[contains(text(),'Edit patient information')])`
When I wait until element located `xpath(//*[contains(text(),'Profile for ${patientFirstName} ${patientLastName}')])` appears
Then the text 'Profile for ${patientFirstName} ${patientLastName}' exists


Scenario: Select 'SMS' contact method if not selected and click 'Save' (Step 9-10)
Meta:
    @severity 1
When I enter `#{generate(name.firstName)}ATCreated` in field located `xpath(//*[@name='firstname'])`
When I click on element located `xpath(//*[@class='Select-control']/ancestor::div[5]/following-sibling::div[2]//*[@class='Select-control'])`
When I click on element located `xpath(//*[@class='Select-menu-outer']//*[contains(text(),'SMS')])`
When I click on element located `xpath(//*[@type='submit'])`


Scenario: Send any message to patient (Step 11-12)
Meta:
    @severity 1
When I initialize the STORY variable `patientId` with value `#{replaceAllByRegExp((${baseApplicationUrl}/patients/)(.*)(/.*), $2, ${current-page-url})}`
When I wait until element located `xpath(//*[contains(text(),'Internal message')])` appears
When I click on element located `xpath(//*[contains(text(),'Internal message')])`
When I click on element located `xpath(//*[@data-lh-id='ChatInput-btn-secure'])`
When I click on element located `xpath(//*[contains(text(),'I acknowledge')])`
Then number of elements found by `xpath(//*[contains(text(),'Warning!')])` is = `0`
When I initialize the SCENARIO variable `firstMessageToCustomer` with value `#{generate(regexify '[a-z]{5}[A-Z]{5}')}`
When I enter `${firstMessageToCustomer}` in field located `xpath(//*[@name='messageInput'])`
When I click on element located `xpath(//*[@data-lh-id='ButtonChatMessageSubmit-btn-submit'])`
Then the text '${firstMessageToCustomer}' exists


Scenario: Patient clicks on the link invited on his SMS (Step 13-14)
Meta:
    @severity 1
When I refresh the page
When I save access token from application storage to SCENARIO variable 'accessToken'
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
When I save JSON element from context by JSON path `$[0].text` to STORY variable `messageVar`
When I initialize the SCENARIO variable `welcomeUrlFromMessage` with value `#{replaceAllByRegExp((.*)(visit our secure portal: )(.*), $3, #{removeWrappingDoubleQuotes(${messageVar})})}`
When I open URL `${welcomeUrlFromMessage}` in new window
When I wait until element located `xpath(//*[contains(text(),'Sign in')])` appears
When I click on element located `xpath(//*[contains(text(),'Sign in')])`
When I wait until element located `xpath(//*[@placeholder='Send a Message'])` appears


Scenario: Send message as Patient via chat - portal (Step 15)
Meta:
    @severity 1
When I initialize the SCENARIO variable `textFromPatientToPracticeText` with value `#{generate(regexify '[a-zA-Z0-9]{10}')}`
When I enter `${textFromPatientToPracticeText}` in field located `xpath(//*[@placeholder='Send a Message'])`
When I click on element located `xpath(//*[@aria-label='Send message'])`
When I switch to window with title that CONTAINS `Luma Health`
When I wait until element located `xpath(//*[contains(text(),'${textFromPatientToPracticeText}')])` appears
Then the text '${textFromPatientToPracticeText}' exists


Scenario: Send message as Practice to the patient (Step 16)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Internal message')])`
When I click on element located `xpath(//*[@data-lh-id='ChatInput-btn-secure'])`
When I click on element located `xpath(//*[contains(text(),'I acknowledge')])`
Then number of elements found by `xpath(//*[contains(text(),'Warning!')])` is = `0`
When I initialize the SCENARIO variable `textFromPatientToPracticeText` with value `#{generate(regexify '[a-zA-Z0-9]{10}')}`
When I enter `${textFromPatientToPracticeText}` in field located `xpath(//*[@name='messageInput'])`
When I click on element located `xpath(//*[@data-lh-id='ButtonChatMessageSubmit-btn-submit'])`
When I wait until element located `xpath(//*[contains(text(),'${textFromPatientToPracticeText}')])` appears
When I switch to window with title that CONTAINS `Patient App`
When I wait until element located `xpath(//*[contains(text(),'${textFromPatientToPracticeText}')])` appears
Then the text '${textFromPatientToPracticeText}' exists
