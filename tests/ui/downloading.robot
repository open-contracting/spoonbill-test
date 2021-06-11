*** Settings ***
Resource   tests/resources.robot
Resource   tests/general.robot

Suite Setup  run keyword  Set Selenium Speed  0.3
Test Setup    run keywords    Open new browser  AND  Empty Directory  ${OUTPUT DIR}/downloads_result
Test Teardown  run keywords  Close all browsers  AND  Empty Directory  ${OUTPUT DIR}/downloads_result

*** Test Cases ***
Download xls
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
    Click on "Continue" button
    Sleep  1
    Click on "Generate as a multi sheet XLSX" button
    Wait Until Element Is Enabled  //div[contains(@class, 'download-block completed')][1]  timeout=30
    Click on "Download XLS" button
    Wait until keyword succeeds
    ...      2 min
    ...      15 sec
    ...      Download should be done  ${OUTPUT DIR}/downloads_result


Download csv
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
    Click on "Continue" button
    Sleep  1
    Click on "Generate tables as individual CSV files" button
    Wait Until Element Is Enabled  //div[contains(@class, 'download-block completed')][1]  timeout=30
    Click on "Download CSV" button
    ${file}=  Download should be done  ${OUTPUT DIR}/downloads_result
    Archive Should Contain File  ${file}  contracts.csv
    Archive Should Contain File  ${file}  parties.csv
    Archive Should Contain File  ${file}  tenders.csv

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

Click on "Download XLS" button
    Click Element  //div[@class="download-option"][1]//span[contains(text(), 'Download')]

Click on "Download CSV" button
    Click Element  //div[@class="download-option"][2]//span[contains(text(), 'Download')]

Click on "Generate as a multi sheet XLSX" button
    Scroll Element Into View  //h1
    Click Element  //span[contains(text(), 'Generate XLSX')]/parent::node()

Click on "Generate tables as individual CSV files" button
    Scroll Element Into View  //h1
    Click Element  //span[contains(text(), 'Generate CSV')]/parent::node()

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

Download should be done
  [Arguments]    ${directory}
  [Documentation]    Verifies that the directory has only one folder and it is not a temp file.
  ...
  ...    Returns path to the file
  ${files}    List Files In Directory    ${directory}
  Length Should Be    ${files}    1    Should be only one file in the download folder
  Should Not Match Regexp    ${files[0]}    (?i).*\\.tmp    Chrome is still downloading a file
  ${file}    Join Path    ${directory}    ${files[0]}
  Log    File was successfully downloaded to ${file}
  [Return]    ${file}