*** Settings ***
Resource   tests/resources.robot
Resource   tests/general.robot

Suite Setup  run keyword  Set Selenium Speed  0.3
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
    Click on "Split arrays into separate tables"
    Sleep  1
    ${split_tables}=  Get WebElements  //div[@class='app-table']
    ${count_tables}=  Get Length  ${split_tables}
    Should Be Equal  '${count_tables}'  '3'


*** Keywords ***
Verify that file validated
    Wait until keyword succeeds
    ...      5 min
    ...      15 sec
    ...      Page Should Contain  Select fields manually


Click on "Continue to select tables" button
    ${button}=  Set Variable  //span[contains(text(), 'Continue to select tables')]/parent::node()
    Wait Until Page Contains Element  ${button}
    Scroll Element Into View  ${button}
    Click Element  ${button}

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
    Click Element  //label[contains(text(), 'Split arrays into separate tables')]