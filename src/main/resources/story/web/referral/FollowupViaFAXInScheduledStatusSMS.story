Description: Story performs verification of testcase "Referral | Follow up via FAX in Scheduled Status | SMS" (TestCaseId=38)
Meta:
    @epic Sanity
    @feature Referral
    @testCaseId 38


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

Scenario: Select 'Mission Control' option. Select 'Feature Settings' > 'Inbound Referral' (Step 3-4)
Meta:
    @severity 1
Given I am on a page with the URL '${baseApplicationUrl}/v2/settings/home'
When I go to the relative URL '/v2/settings/features/inbound-referral'


Scenario: Enable toggle buttons to send fax with referral's status and when referral is scheduled (Step 5)
Meta:
    @severity 1
When I wait until element located `By.xpath(//h1[text()='Inbound Referral Settings'])` appears
When I click on element located `By.xpath(//*[@for='referral.sendReferralFax'])`
When I click on element located `By.xpath(//*[@for='referral.sendReferralFaxStatus.scheduled'])`
When I click on element located `By.xpath(//button[contains(., 'Save')])`
When I wait until element located `By.xpath(//*[@class='notifications-wrapper'][contains(., 'Settings saved successfully!')])` appears
Then number of elements found by `By.xpath(//*[@class='notifications-wrapper'][contains(., 'Settings saved successfully!')])` is equal to `1`


Scenario: Go to 'Add patient' page (Step 6-7)
Given I am on a page with the URL '${baseApplicationUrl}/patients/add'
When I wait until element located `By.xpath(//*[@id='PatientEditForm'])` appears


Scenario: Fill in First Name, Last Name, Date of Birth, Add Voice with your TextNow number and click �Save� button (Step 8)
Meta:
    @severity 1
When I initialize the STORY variable `patientFirstName` with value `#{generate(name.firstName)}atcreated`
When I initialize the STORY variable `patientLastName` with value `#{generate(name.lastName)}atcreated`
When I initialize the SCENARIO variable `patientDOB` with value `#{generateDate(-P30Y, MM/dd/yyyy)}`
When I initialize the SCENARIO variable `patinetPhone` with value `#{${dummyPhoneNumbersVariety2}}`
When I initialize the SCENARIO variable `patientPhoneType` with value `Voice`
When I add new patient with firstname `${patientFirstName}` lastname `${patientLastName}` DOB `${patientDOB}` phoneNumber '${patinetPhone}' and phoneType '${patientPhoneType}'
When I wait until element located `By.xpath(//*[@class='notifications-wrapper'][contains(., 'Patient saved successfully!')])` appears
Then number of elements found by `By.xpath(//*[@class='notifications-wrapper'][contains(., 'Patient saved successfully!')])` is equal to `1`


Scenario: Search for created patient via Search field and click on the name (Step 9)
Meta:
    @severity 1
When I enter `${patientFirstName} ${patientLastName}` in field located `By.xpath(//*[contains(text(), 'Find patients by name')]/following-sibling::input)`
When I wait until element located `By.xpath(//span[contains(., '${patientFirstName} ${patientLastName}')][@role='menuitem'])` appears
When I click on element located `By.xpath(//span[contains(., '${patientFirstName} ${patientLastName}')][@role='menuitem'])`
When I wait until element located `By.xpath(//span[contains(., '${patientFirstName}')][contains(., '${patientLastName}')][@data-lh-id='patient-name-text'])` appears
Then the page with the URL containing 'chat' is loaded


Scenario: Click on 3 dots image on the upper-right side and click 'Edit patient information' (Step 10)
Meta:
    @severity 1
When I click on element located `By.xpath(//*[@aria-label='More'])`
When I wait until element located `By.xpath(//*[contains(text(),'Edit patient information')])` appears
When I click on element located `By.xpath(//*[contains(text(),'Edit patient information')])`
When I wait until element located `By.xpath(//*[contains(text(),'Profile for ${patientFirstName} ${patientLastName}')])` appears
Then the text 'Profile for ${patientFirstName} ${patientLastName}' exists


Scenario: Select 'SMS' contact method and click 'Save' (Step 11)
Meta:
    @severity 1
When I initialize the SCENARIO variable `newPhoneType` with value `SMS`
When I resave phoneType `${newPhoneType}` for the patient


Scenario: Click 'Referrals' in left-hand side navigation menu. Click 'Add Referral' button in upper-right corner. (Step 12,13)
Meta:
    @severity 1
When I click on element located `By.xpath(//span[text()='Inbound Referrals'])`
When I wait until element located `By.xpath(//*[text()='INBOUND Referrals'])` appears
When I click on element located `By.xpath(//button[contains(., 'Add Referral')])`
When I wait until element located `By.xpath(//input[@placeholder='First Name Last Name'])` appears
Then the text 'Add Inbound Referral' exists


Scenario: Enter patient name with SMS contact method into 'Patient Name' field (Step 14)
Meta:
    @severity 1
When I enter `${patientFirstName} ${patientLastName}` in field located `By.xpath(//input[@placeholder='First Name Last Name'])`


Scenario: Select your Patient from the drop-down menu (Step 15)
Meta:
    @severity 1
When I wait until element located `By.xpath(//ul[contains(., '${patientLastName}')]/descendant::div)` appears
When I click on element located `By.xpath(//ul[contains(., '${patientLastName}')]/descendant::div)`
Then number of elements found by `By.xpath(//input[@placeholder='mm/dd/yyyy' and @disabled])` is equal to `1`
Then number of elements found by `By.xpath(//input[@type='tel' and @disabled])` is equal to `1`


Scenario: Click 'Save' button in the lower-right corner (Step 16)
Meta:
    @severity 1
When I click on element located `By.xpath(//button[contains(., 'Save')])`
Then number of elements found by `By.xpath(//label[contains(., 'Facility')]/following-sibling::*[contains(text(), 'Required')])` is equal to `1`
Then number of elements found by `By.xpath(//label[contains(., 'Referring Provider')]/following-sibling::*[contains(text(), 'Required')])` is equal to `1`


Scenario: Click 'Facility' dropdown menu. Select �Fremont Outpatient Clinic� from dropdown list. (Step 17)
Meta:
    @severity 1
When I click on element located `By.xpath(//label[contains(., 'Facility')]/following-sibling::div[contains(., 'Select')])`
When I click on element located `By.xpath(//div[contains(text(), 'Fremont Outpatient Clinic')][@role='menuitem'])`
Then number of elements found by `By.xpath(//div[contains(text(), 'Fremont Outpatient Clinic')][@class='Select-value'])` is equal to `1`


Scenario: Click 'Referring Provider' dropdown menu. Select 'Add New Referring Provider' from dropdown list (Step 18)
Meta:
    @severity 1
When I click on element located `By.xpath(//label[contains(., 'Referring Provider')]/following-sibling::div[contains(., 'Select')])`
When I wait until element located `By.xpath(//div[@role='menuitem'][contains(., 'Add New Referring Provider')])` appears
When I click on element located `By.xpath(//div[@role='menuitem'][contains(., 'Add New Referring Provider')])`
When I wait until element located `By.xpath(//h6[text()='Add New Referring Provider'])` appears


Scenario: Action: Enter �Bob� into search for provider field (Step 19)
Meta:
    @severity 1
When I enter `Bob` in field located `By.xpath(//div[contains(text(), 'Search for provider')]/following::input[1])`
When I wait until element located `By.xpath(//*[contains(., 'smith, bob')][@role='menuitem'])` appears


Scenario: Select 'Bob Smith' from the dropdown list. Add '4155200481' for the fax number. Add phone with your TextNow number. Click 'Save' button. (Step 20)
Meta:
    @severity 1
When I click on element located `By.xpath(//*[contains(., 'smith, bob')][@role='menuitem'])`
When I wait until element located `By.xpath(//input[@name='fax'])` appears
When I enter `4155200481` in field located `By.xpath(//input[@name='fax'])`
When I click on element located `By.xpath(//div[contains(., 'Add New Referring Provider')]/following::button[contains(., 'Save')])`
When I wait until element located `By.xpath(//input[@name='fax'])` disappears
Then number of elements found by `By.xpath(//div[text()='Bob Smith'][@class='Select-value'])` is equal to `1`


Scenario: Select this provider in the dropdown and click 'Save' button (Step 21)
Meta:
    @severity 1
When I execute sequence of actions:
|type      |argument|
|PRESS_KEYS|ENTER   |
When I click on element located `By.xpath(//button[contains(., 'Save')])`
When I wait until element located `By.xpath(//li[contains(., '${patientFirstName}')][contains(., 'Fremont Outpatient Clinic')][contains(., 'Active')][contains(., '0 completed attempts / 10 remaining')])` appears


Scenario: Make a call with the phone number specified in the message to the patient (via TextNow) (Step 22)
Meta:
    @severity 1
When I go to the relative URL '/referrals'
!-- TODO:When I wait until element located `By.xpath(//li[contains(., '${patientFirstName}')][contains(., 'Fremont Outpatient Clinic')][contains(., 'Called')][contains(., '1 completed attempt / 9 remaining')])` appears
!-- TODO: Add Voice steps


Scenario: Click 3 dots to the right of created referral. Select 'Details' option (Step 23)
Meta:
    @severity 1
When I wait until element located `By.xpath(//li[contains(., '${patientFirstName}')][contains(., 'Fremont Outpatient Clinic')])` appears
When I click on element located `By.xpath((//div[contains(., '${patientFirstName}')]/following::button)[1])`
When I click on element located `By.xpath(//li[contains(., 'Details')])`
When I wait until element located `By.xpath(//p[text()='Referral for ${patientFirstName} ${patientLastName}'])` appears


Scenario: Click 'Cancel' button in the lower-right corner (Step 24)
Meta:
    @severity 1
When I click on element located `By.xpath(//button[contains(., 'Cancel')])`
Then the page with the URL containing 'referrals' is loaded


Scenario: Click 3 dots to the right of created referral. Select 'Jump to Patient' option (Step 25)
Meta:
    @severity 1
When I wait until element located `By.xpath((//div[contains(., '${patientFirstName}')]/following::button)[1])` appears
When I click on element located `By.xpath((//div[contains(., '${patientFirstName}')]/following::button)[1])`
When I click on element located `By.xpath(//li[contains(., 'Jump to Patient')])`
When I wait until element located `By.xpath(//button[contains(., 'chat')])` appears
Then the page with the URL containing 'chat' is loaded


Scenario: Back to the 'REFERRALS' page. Click 3 dots to the right of created referral. Select 'Schedule' option (Step 26)
Meta:
    @severity 1
When I go to the relative URL '/referrals'
When I wait until element located `By.xpath((//div[contains(., '${patientFirstName}')]/following::button)[1])` appears
When I click on element located `By.xpath((//div[contains(., '${patientFirstName}')]/following::button)[1])`
When I click on element located `By.xpath(//li[contains(., 'Schedule')])`
Then the text 'Schedule Referral' exists
Then the text 'Are you sure you wish to schedule this referral?' exists


Scenario: Click 'YES, SCHEDULE' button. (Step 27)
Meta:
    @severity 1
When I click on element located `By.xpath(//button[contains(., 'Yes, schedule')])`
When I wait until element located `By.xpath(//div[contains(., '${patientFirstName}')][contains(., 'Fremont Outpatient Clinic')][contains(., 'Scheduled')])` appears
Then number of elements found by `By.xpath(//div[contains(., '${patientFirstName}')][contains(., 'Fremont Outpatient Clinic')][contains(., 'Scheduled')][contains(., 'attempt')][contains(., 'remaining')])` is equal to `0`
