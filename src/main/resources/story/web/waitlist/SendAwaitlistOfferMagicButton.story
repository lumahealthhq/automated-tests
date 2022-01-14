Description: Story performs verification of testcase "3.0 Send a Waitlist Offer Magic Button" (TestCaseId=28)
Meta:
    @epic Sanity
    @feature Waitlist
    @testCaseId 28


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
When I initialize the STORY variable `phoneNumber` with value `#{${dummyPhoneNumbersVariety2}}`
When I initialize the STORY variable `practiceName` with value `#{generate(regexify '[A-Z0-9]{10}')}`
Given I log into application with firstName '${firstName}' lastName '${lastName}' practiceName '${practiceName}' phoneNumber '${phoneNumber}' and parameters '#{loadResource(/templates/minimumInitialDataConfiguration.json)}'


Scenario: Run magic button and verify the patient receives the messages via Textnow (Step 3)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Hub')])`
When I wait until element located `xpath(//*[@name='messageInput'])` appears
When I click on element located `xpath(//*[@role='button']//*[contains(text(),'${lastName}')])`
When I initialize the STORY variable `patientId` with value `#{replaceAllByRegExp((.*patient=)(.*), $2, ${current-page-url})}`
Given I am on a page with the URL '${baseApplicationUrl}/patients/${patientId}/chat'
When I open URL `${baseApiUrl}/demoUsers/${oppidVariable}/messages/patientApptOffer` in new window
When I wait until the page has the title 'Luma Health Magic Buttons'
When I change context to element located `xpath(//h4)`
When I save text of context element to SCENARIO variable `magicButtonMessage`
When I reset context
Then `${magicButtonMessage}` matches `Thanks you! Your magic request to send patientApptOffer .* has been processed.`
When I close the current window
When I switch to window with title that CONTAINS `Luma Health`
When I wait until element located `xpath(//*[contains(text(),'This confirms')])` appears
When I change context to element located `xpath(//*[contains(text(),'This confirms')])`
When I save text of context element to SCENARIO variable `waitlistOfferMessage1`
When I reset context
When I refresh the page
When I wait until element located `xpath(//*[contains(text(),'Reply YES to book')])` appears
When I change context to element located `xpath(//*[contains(text(),'Reply YES to book')])`
When I save text of context element to SCENARIO variable `waitlistOfferMessage2`
When I reset context
When I save access token from application storage to STORY variable 'accessToken'
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
Then JSON element by JSON path `$..text` is equal to `["${waitlistOfferMessage1}", "${waitlistOfferMessage2}"]`IGNORING_ARRAY_ORDER,IGNORING_EXTRA_ARRAY_ITEMS


Scenario: Reply 'YES' as patient via Textnow (Step 4)
Meta:
    @severity 1
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
When I save JSON element from context by JSON path `$[0].from` to SCENARIO variable `fromPhoneNumber`
When I initialize the SCENARIO variable `fromPhoneNumber` with value `#{replaceAllByRegExp((\s*\-*), """""", #{removeWrappingDoubleQuotes(${fromPhoneNumber})})}`
When I save JSON element from context by JSON path `$[0].externalId.value` to SCENARIO variable `messageId`
When I initialize the SCENARIO variable `messageId` with value `#{removeWrappingDoubleQuotes(${messageId})}`
Given I reply on message with id '${messageId}' with text 'yes' as patient with phoneNumber '${phoneNumber}' to recipient with phoneNumber '${fromPhoneNumber}'
When I wait until element located `xpath(//*[contains(text(),'Thanks.')])` appears
When I change context to element located `xpath(//*[contains(text(),'Thanks.')])`
When I save text of context element to SCENARIO variable `offerMessage`
When I reset context
Then `${offerMessage}` matches `Thanks. We're checking with the front office and will send you another message when confirmed.`
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
Then JSON element by JSON path `$..text` is equal to `["${offerMessage}"]`IGNORING_ARRAY_ORDER,IGNORING_EXTRA_ARRAY_ITEMS


Scenario: Click 'Waitlist' from the left navigation menu (Step 5)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Waitlists')])`
When I wait until element located `xpath(//*[contains(text(),'Send offers')])` appears
Then the text 'WAITLISTS' exists


Scenario: Verify patient's confirming status in the 'Barton DemoClinton' (Step 6)
Meta:
    @severity 1
When I click on element located `xpath(//*[.='Barton DemoClinton' and @role='button'])`
When I wait until element located `xpath(//*[contains(text(),'${lastName}, ${firstName}')])` appears
Then the text 'Confirming' exists


Scenario: Click Activity Feed and verify notification (Step 7)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Activity Feed')])`
When I wait until element located `xpath(//*[contains(text(),'Activity for Today')])` appears
When I change context to element located `xpath(//*[contains(text(),'Waiting')]/..)`
When I save text of context element to SCENARIO variable `notificationMessage`
Then `${notificationMessage}` matches `Patient ${firstName} ${lastName} accepted the open slot with Barton DemoClinton on .*`
When I reset context


Scenario: Click the 'Accept' button and verify the patient receives the messages (Step 8)
Meta:
    @severity 1
When I click on element located `xpath(//*[contains(text(),'Accept')])`
Given I request messages for patient with id '${patientId}' and access token '${accessToken}'
When I save JSON element from context by JSON path `$[0].text` to SCENARIO variable `messageSMS`
When I execute steps with delay `PT1S` at most 10 times while variable `messageSMS` is  not equal to `"Thanks. You're all set and your appointment on .* has been booked."`:
|step                                                                                            |
|Given I request messages for patient with id '${patientId}' and access token '${accessToken}'   |
|When I save JSON element from context by JSON path `$[0].text` to SCENARIO variable `messageSMS`|
Then `${messageSMS}` matches `"Thanks. You're all set and your appointment on .* has been booked."`


Scenario: Verify removing the patient from the Waitlist (Step 9)
Meta:
    @severity 1
Given I am on a page with the URL '${baseApplicationUrl}/waitlists'
When I wait until element located `xpath(//*[contains(text(),'Send offers')])` appears
When I click on element located `xpath(//*[contains(text(),'Barton DemoClinton')])`
When I wait until element located `xpath(//*[contains(text(),'waiting for Barton DemoClinton')])` appears
Then the text '${firstName},${lastName}' does not exist
