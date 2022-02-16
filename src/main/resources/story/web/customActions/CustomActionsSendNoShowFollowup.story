Description: Story performs verification of testcase "Custom Actions Send No-Show Followup" (TestCaseId=31)
Meta:
    @epic Sanity
    @feature CustomActions
    @testCaseId 31


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
When I initialize the STORY variable `practiceName` with value `#{generate(regexify '[a-zA-Z0-9]{10}')}`
When I initialize the STORY variable `oppid` with value `#{replaceAllByRegExp((.*oppid=)(.*), $2, ${current-page-url})}`
Given I log into application with firstName '${firstName}' lastName '${lastName}' practiceName '${practiceName}' phoneNumber '${phoneNumber}' and parameters '#{loadResource(/templates/minimumInitialDataConfiguration.json)}'


Scenario: Paste the endpoint url into a new browser tab or window with your salesforceID (Step 3)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Hub')])`
When I wait until element located `xpath(//*[@name='messageInput'])` appears
When I click on element located `xpath(//*[@role='button']//*[contains(text(),'${lastName}')])`
When I initialize the STORY variable `patientId` with value `#{replaceAllByRegExp((.*patient=)(.*), $2, ${current-page-url})}`
Given I am on a page with the URL '${baseApplicationUrl}/patients/${patientId}/chat'
When I open URL `${baseApiUrl}/demoUsers/${oppid}/messages/customActionNoShowFollowup` in new window
When I close the current window
When I switch to window with title that CONTAINS `Luma Health`
When I initialize the SCENARIO variable `dateVariable` with value `#{generateDate(P, MMM dd'th,' h:mm)} am`
When I wait until element located `xpath(//*[contains(text(),'Hi ${firstName}, this is')])` appears
When I click on element located `By.xpath(//*[contains(., 'Activity Feed')][contains(@id, 'menu-option')])`
When I wait until element located `By.xpath(//*[contains(text(), 'Welcome to Luma Health')])` appears
When I click on element located `xpath(//*[contains(text(),'Hub')])`
When I wait until element located `xpath(//*[@name='messageInput'])` appears
When I refresh the page
When I wait until element located `xpath(//*[@name='messageInput'])` appears
When I click on element located `xpath(//*[@role='button']//*[contains(text(),'${lastName}')])`
When I wait until element located `xpath(//*[contains(text(),'Hi ${firstName}, this is')])` appears
When I wait until element located `xpath(//*[contains(text(),'Hi ${firstName}, this is')])` contains text 'Hi ${firstName}, this is ${facilityNameVariable1}. We're sorry you were unable to make your appointment yesterday'
When I wait until element located `xpath(//*[contains(text(),'Hi ${firstName}, this is')])` contains text 'If you haven't already, please call ${facilityPhoneVariable1} to reschedule'
When I save access token from application storage to STORY variable 'accessToken'
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
Then JSON element by JSON path `$[0].text` is equal to `"Hi ${firstName}, this is ${facilityNameVariable1}. We're sorry you were unable to make your appointment yesterday on ${dateVariable}. If you haven't already, please call ${facilityPhoneVariable1} to reschedule"`TREATING_NULL_AS_ABSENT
