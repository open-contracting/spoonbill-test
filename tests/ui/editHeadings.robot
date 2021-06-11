*** Settings ***
Resource   tests/resources.robot
Resource   tests/general.robot

Suite Setup  run keyword  Set Selenium Speed  0.3
Test Setup    run keyword    Open new browser
Test Teardown  run keyword  Close all browsers

*** Test Cases ***
Check "OCDS headings only"
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
    Click on "Save and Continue" button
    Click on "Save and Continue" button
    Click on "Save and Continue" button
    Click on "Save and Continue" button
    Click on "Save and Continue" button
    Sleep  1
    ${count}=  Get count of thead by index  1
    Should Be Equal  '${count}'  '1'
    ${c_names}=  Get columnns by index  1  1
    Should Be Equal  '/awards/date'  '${c_names[4]}'


Check "English user friendly headings to all tables"
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
    Click on "Save and Continue" button
    Click on "Save and Continue" button
    Click on "Save and Continue" button
    Click on "Save and Continue" button
    Click on "Save and Continue" button
    Sleep  1
    Select radio button by index  2
    Click on "Apply change" button
    Sleep  1
    ${count}=  Get count of thead by index  1
    Should Be Equal  '${count}'  '2'
    ${thead1}=  Get columnns by index  1  1
    ${thead2}=  Get columnns by index  1  2
    Should Be Equal  'Award Date'  '${thead1[4]}'
    Should Be Equal  '/awards/date'  '${thead2[4]}'


Check "English R friendly headings to all tables"
    Go to  ${MAIN_URL}
    Upload file by button  resources/data1.json
    Verify that file validated
    Click on "Continue to select tables" button
    Multi select from "Available tables" list  tenders
    Multi select from "Available tables" list  planning
    Multi select from "Available tables" list  parties
    Click on "Add" button
    Click on "Continue" button
    Click on "Save and Continue" button
    Click on "Save and Continue" button
    Click on "Save and Continue" button
    Sleep  1
    Select radio button by index  3
    Click on "Apply change" button
    Sleep  1
    ${count}=  Get count of thead by index  1
    Should Be Equal  '${count}'  '2'
    ${thead1}=  Get columnns by index  1  1
    ${thead2}=  Get columnns by index  1  2
    Should Be Equal  'organization_entity_id'  '${thead1[4]}'
    Should Be Equal  '/parties/id'  '${thead2[4]}'


Check "Spanish user friendly headings to all tables"
    Go to  ${MAIN_URL}
    Upload file by button  resources/data1.json
    Verify that file validated
    Click on "Continue to select tables" button
    Multi select from "Available tables" list  planning
    Click on "Add" button
    Click on "Continue" button
    Click on "Save and Continue" button
    Sleep  1
    Select radio button by index  4
    Click on "Apply change" button
    Sleep  1
    ${count}=  Get count of thead by index  1
    Should Be Equal  '${count}'  '2'
    ${thead1}=  Get columnns by index  1  1
    ${thead2}=  Get columnns by index  1  2
    Should Be Equal  'Fuente de los Datos'  '${thead1[5]}'
    Should Be Equal  '/planning/budget/description'  '${thead2[5]}'


Check "Spanish R friendly headings to all tables"
    Go to  ${MAIN_URL}
    Upload file by button  resources/data1.json
    Verify that file validated
    Click on "Continue to select tables" button
    Multi select from "Available tables" list  planning
    Click on "Add" button
    Click on "Continue" button
    Click on "Save and Continue" button
    Sleep  1
    Select radio button by index  5
    Click on "Apply change" button
    Sleep  1
    ${count}=  Get count of thead by index  1
    Should Be Equal  '${count}'  '2'
    ${thead1}=  Get columnns by index  1  1
    ${thead2}=  Get columnns by index  1  2
    Should Be Equal  'fuente_de_los_datos'  '${thead1[5]}'
    Should Be Equal  '/planning/budget/description'  '${thead2[5]}'


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
    Click Element  //p[contains(text(), 'Available tables')]/following-sibling::div//span[contains(text(), '${element}')]


Click on "Add" button
    Click Element  //span[contains(text(), 'Add')]/parent::node()

Click on "Save and Continue" button
    Sleep  1
    Click Element  //span[contains(text(), 'Save and Continue')]/parent::node()

Click on "Continue" button
    Click Element  //span[contains(text(), 'Continue')]/parent::node()

Click on "Remove" button
    Click Element  //span[contains(text(), 'Remove')]/parent::node()

Click on "Remove table" button
    Click Element  //span[contains(text(), 'Remove table')]/parent::node()

Click on "Confirm Remove table" button
    Click Element  //span[contains(text(), 'Yes, remove table and continue')]/parent::node()

Click on "Apply change" button
    Click Element  //span[contains(text(), 'Apply change')]/parent::node()

Get tables from the page
    ${tables}=  Get WebElements  //div[@class='app-table']
    [Return]  ${tables}

Select radio button by index
    [Arguments]  ${index}
    Click Element  //div[@role='radiogroup']/div[${index}]

Get count of thead by index
    [Arguments]  ${index}
    ${thead}=  Get WebElements  //div[@class='app-table'][${index}]//thead/tr
    ${count}=  Get Length  ${thead}
    [Return]  ${count}

Get columnns by index
    [Arguments]  ${table_index}  ${thead_index}
    @{result}=  Create List
    ${columns}=  Get WebElements  //div[@class='app-table'][${table_index}]//thead/tr[${thead_index}]//th
    FOR  ${item}  IN  @{columns}
        ${item_name}=  Get Text  ${item}
        Append to List  ${result}  ${item_name}
    END
    [Return]  ${result}