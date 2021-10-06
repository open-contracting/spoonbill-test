*** Settings ***
Resource   tests/resources.robot
Resource   tests/general.robot

Suite Setup  run keyword  Set Selenium Speed  0.4
Test Setup    run keyword    Open new browser
Test Teardown  run keyword  Close all browsers

*** Test Cases ***
Customize table
    Go to  ${MAIN_URL}
    Upload file by button  resources/data1.json
    Verify that file validated
    Click on "Continue to select tables" button
    Multi select from "Available tables" list  tenders
    Multi select from "Available tables" list  awards
    Multi select from "Available tables" list  contracts
    Multi select from "Available tables" list  planning
    Multi select from "Available tables" list  parties
    Click on "Add" button
    Click on "Continue" button
    @{list}=  Create List  tenders  awards  contracts  planning  parties
    Check that selection table displays on page  ${list}
    Click on "Save and Continue" button
    Check that selection table displays on page  ${list}
    Click on "Save and Continue" button
    Check that selection table displays on page  ${list}
    Click on "Save and Continue" button
    Check that selection table displays on page  ${list}
    Click on "Save and Continue" button
    Check that selection table displays on page  ${list}
    Click on "Save and Continue" button
    ${current_status}=  Get active status
    Should Be Equal  ${current_status}  Edit headings

Customize table (Remove table)
    Go to  ${MAIN_URL}
    Upload file by button  resources/data1.json
    Verify that file validated
    Click on "Continue to select tables" button
    Multi select from "Available tables" list  tenders
    Multi select from "Available tables" list  awards
    Multi select from "Available tables" list  contracts
    Multi select from "Available tables" list  planning
    Multi select from "Available tables" list  parties
    Click on "Add" button
    Click on "Continue" button
    @{list}=  Create List  tenders  awards  contracts  planning  parties
    Check that selection table displays on page  ${list}
    Click on "Remove table" button
    Click on "Confirm Remove table" button
    Check that selection table displays on page  ${list}
    Click on "Save and Continue" button
    Check that selection table displays on page  ${list}
    Click on "Save and Continue" button
    Check that selection table displays on page  ${list}
    Click on "Save and Continue" button
    Check that selection table displays on page  ${list}
    Click on "Save and Continue" button
    ${current_status}=  Get active status
    Should Be Equal  ${current_status}  Preview tables

Customize table (Selection only one)
    Go to  ${MAIN_URL}
    Upload file by button  resources/data1.json
    Verify that file validated
    Click on "Continue to select tables" button
    Multi select from "Available tables" list  tenders
    Click on "Add" button
    Click on "Continue" button
    @{list}=  Create List  tenders
    Check that selection table displays on page  ${list}
    Click on "Save and Continue" button
    ${current_status}=  Get active status
    Should Be Equal  ${current_status}  Edit headings


Customize table (splitting)
    [Tags]  noncritical
    Go to  ${MAIN_URL}
    Upload file by button  resources/2021-03-03.json
    Verify that file validated
    Click on "Continue to select tables" button
    Multi select from "Available tables" list  awards
    Click on "Add" button
    Click on "Continue" button
    Page Should Contain  Keep arrays in main table

    Sleep  10
    ${split_tables}=  Get WebElements  //div[@class='app-table']
    ${count_tables}=  Get Length  ${split_tables}
    Should Be Equal  '${count_tables}'  '3'
    Click on "Keep arrays in main table"
    Sleep  10
    ${unsplit_tables}=  Get WebElements  //div[@class='app-table']
    ${count_tables}=  Get Length  ${unsplit_tables}
    Should Be Equal  '${count_tables}'  '1'

    Click on "Split arrays into separate tables"
    Sleep  10
    ${split_tables}=  Get WebElements  //div[@class='app-table']
    ${count_tables}=  Get Length  ${split_tables}
    Should Be Equal  '${count_tables}'  '2'


Customize table - sppliting through url
    [Tags]  noncritical  issue-205
    Go to  ${MAIN_URL}
    Click Element  //div[contains(text(), 'Supply a URL for JSON')]
    Upload file by url  https://www.dropbox.com/s/m0rb09erevdm5o6/2021-03-03.json?dl=1
    Verify that file validated
    Click on "Continue to select tables" button
    Multi select from "Available tables" list  awards
    Click on "Add" button
    Click on "Continue" button
    Page Should Contain  Keep arrays in main table

    Sleep  10
    ${split_tables}=  Get WebElements  //div[@class='app-table']
    ${count_tables}=  Get Length  ${split_tables}
    Should Be Equal  '${count_tables}'  '3'

    Click on "Keep arrays in main table"
    Sleep  10

    ${unsplit_tables}=  Get WebElements  //div[@class='app-table']
    ${count_tables}=  Get Length  ${unsplit_tables}
    Should Be Equal  '${count_tables}'  '1'

    Click on "Split arrays into separate tables"
    Sleep  10
    ${split_tables}=  Get WebElements  //div[@class='app-table']
    ${count_tables}=  Get Length  ${split_tables}
    Should Be Equal  '${count_tables}'  '2'


Customize table (ordering)
    [Tags]  noncritical  issue-253
    Go to  ${MAIN_URL}
    Upload file by button  resources/data1.json
    Verify that file validated
    Click on "Continue to select tables" button
    Select all from available tables
    Click on "Add" button
    Sleep  0.5
    ${expected_orders}=  Get list from selected tables
    Click on "Continue" button
    Sleep  1
    ${current_order}=  Get tables from preview page
    Lists Should Be Equal  ${expected_orders}  ${current_order}


*** Keywords ***
Verify that file validated
    Wait until keyword succeeds
    ...      5 min
    ...      15 sec
    ...      Page Should Contain  Select fields manually


Check that element avaliable in the Available tables
    [Arguments]  ${element}
    @{result}=  Create List
    ${available_items}=  Get WebElements  //p[contains(text(), 'Available tables')]/following-sibling::div//span[@class='table-info__name']
    FOR  ${item}  IN  @{available_items}
        ${item_name}=  Get Text  ${item}
        Append to List  ${result}  ${item_name}
    END
    List Should Contain Value  ${result}  ${element}

Check that selection table displays on page
    [Arguments]  ${list}
    Wait Until Element Is Visible  //div[@role='tab']
    ${current_selection}=  Get WebElements  //div[@role='tab']
    ${current_selection}=  Get Length  ${current_selection}
    ${expected}=  Get Length  ${list}
    Should Be Equal  ${current_selection}  ${expected}


Check that element avaliable in the Selected tables
    [Arguments]  ${element}
    @{result}=  Create List
    ${available_items}=  Get WebElements  //p[contains(text(), 'Selected tables')]/following-sibling::div//span[@class='table-info__name']
    FOR  ${item}  IN  @{available_items}
        ${item_name}=  Get Text  ${item}
        Append to List  ${result}  ${item_name}
    END
    List Should Contain Value  ${result}  ${element}


Select element from "Available tables" list
    [Arguments]  ${element}
    ${element}=  Convert To Lower Case  ${element}
    Wait Until Element Is Enabled  //p[contains(text(), 'Available tables')]/following-sibling::div//span[contains(text(), '${element}')]
    Sleep  1
    Click Element  //p[contains(text(), 'Available tables')]/following-sibling::div//span[contains(text(), '${element}')]


Multi select from "Selected tables" list
    [Arguments]  ${element}
    ${element}=  Convert To Lower Case  ${element}
    Click Element  //p[contains(text(), 'Selected tables')]/following-sibling::div//span[contains(text(), '${element}')]  modifier=CTRL

Click on "Add" button
    Click Element  //span[contains(text(), 'Add')]/parent::node()

Click on "Save and Continue" button
    Click Element  //span[contains(text(), 'Save and Continue')]/parent::node()

Click on "Continue" button
    Click Element  //span[contains(text(), 'Continue')]/parent::node()

Click on "Remove" button
    Click Element  //span[contains(text(), 'Remove')]/parent::node()

Click on "Remove table" button
    Click Element  //span[contains(text(), 'Remove table')]/parent::node()

Click on "Confirm Remove table" button
    Click Element  //span[contains(text(), 'Yes, remove table and continue')]/parent::node()

Click on "Split arrays into separate tables"
    Sleep  1
    Click Element  //label[contains(text(), 'Split arrays into separate tables')]

Click on "Keep arrays in main table"
    Scroll Element Into View  //label[contains(text(), 'Keep arrays in main table')]
    Click Element  //label[contains(text(), 'Keep arrays in main table')]
    Wait Until Page Contains  Remove Array table
    Click Element  //label[contains(.,'Remove Array table')]
    Sleep  2
    Click Element  //div[contains(@class, 'dialog-content')]//button[contains(.,'Continue')]