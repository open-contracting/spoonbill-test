*** Settings ***
Resource   tests/resources.robot
Resource   tests/general.robot

Suite Setup  run keyword  Set Selenium Speed  0.3
Test Setup    run keyword    Open new browser
Test Teardown  run keyword  Close all browsers

*** Test Cases ***
Default selected button is "Upload JSON file"
    Go to  ${MAIN_URL}
    Verify that "Upload JSON file" button sellected by default

Upload json file by button
    Go to  ${MAIN_URL}
    Upload file by button  resources/data.json
    Verify that file validated

Upload json file by url
    Go to  ${MAIN_URL}
    Click Element  //div[contains(text(), 'Supply a URL for JSON')]
    Upload file by url  https://standard.open-contracting.org/media/95124a7c-aea9-42bc-b208-d60d9d1ae495/ocds-213czf-000-00001-02-tender.json
    Verify that file validated


Upload img file by button
    Go to  ${MAIN_URL}
    Upload file by button  resources/test_img.jpg
    Run Keyword And Expect Error  *  Verify that file validated


Upload wrong json file by button
    Go to  ${MAIN_URL}
    Upload file by button  resources/wrong_data.json
    Run Keyword And Expect Error  *  Verify that file validated


*** Keywords ***
Verify that "Upload JSON file" button sellected by default
    Element Attribute Value Should Be  //div[contains(text(), 'Upload JSON file')]  class  option option--selected

Verify that file validated
    Wait until keyword succeeds
    ...      30 sec
    ...      10 sec
    ...      Page Should Contain  Select fields manually