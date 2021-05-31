*** Settings ***
Resource   tests/resources.robot
Resource   tests/general.robot

Suite Setup  run keyword  Set Selenium Speed  0.3
Test Setup    run keyword    Open new browser
Test Teardown  run keyword  Close all browsers

*** Test Cases ***
Select tables from Available tables
    Go to  ${MAIN_URL}
    Upload file by button  resources/data.json
    Verify that file validated
    Click on "Continue to select tables" button
    Check that element avaliable in the Available tables  Parties
    Check that element avaliable in the Available tables  Tenders
    Check that element avaliable in the Available tables  Documents
    Select element from "Available tables" list  parties
    Click on "Add" button
    Run Keyword And Expect Error  *  Check that element avaliable in the Available tables  Parties
    Multi select from "Available tables" list  tenders
    Multi select from "Available tables" list  documents
    Click on "Add" button
    Run Keyword And Expect Error  *  Check that element avaliable in the Available tables  Tenders
    Run Keyword And Expect Error  *  Check that element avaliable in the Available tables  Documents
    Check that element avaliable in the Selected tables  Parties
    Check that element avaliable in the Selected tables  Tenders
    Check that element avaliable in the Selected tables  Documents
    Multi select from "Selected tables" list  parties
    Multi select from "Selected tables" list  documents
    Click on "Remove" button
    Run Keyword And Expect Error  *  Check that element avaliable in the Selected tables  Parties
    Run Keyword And Expect Error  *  Check that element avaliable in the Selected tables  Documents
    Check that element avaliable in the Available tables  Parties
    Check that element avaliable in the Available tables  Documents


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
    Sleep  1
    ${available_items}=  Get WebElements  //p[contains(text(), 'Available tables')]/following-sibling::div//span[@class='table-info__name']
    FOR  ${item}  IN  @{available_items}
        ${item_name}=  Get Text  ${item}
        Append to List  ${result}  ${item_name}
    END
    List Should Contain Value  ${result}  ${element}


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


Multi select from "Available tables" list
    [Arguments]  ${element}
    ${element}=  Convert To Lower Case  ${element}
    Click Element  //p[contains(text(), 'Available tables')]/following-sibling::div//span[contains(text(), '${element}')]  modifier=CTRL


Multi select from "Selected tables" list
    [Arguments]  ${element}
    ${element}=  Convert To Lower Case  ${element}
    Click Element  //p[contains(text(), 'Selected tables')]/following-sibling::div//span[contains(text(), '${element}')]  modifier=CTRL


Click on "Add" button
    Click Element  //span[contains(text(), 'Add')]/parent::node()


Click on "Remove" button
    Click Element  //span[contains(text(), 'Remove')]/parent::node()