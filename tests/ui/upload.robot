*** Settings ***
Resource   tests/resources.robot
Resource   tests/general.robot


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
    Upload file by url  https://standard.open-contracting.org/media/edf9c19b-a156-4f9c-a579-f83ecc472dcb/ocds-213czf-000-00001-02-tender.json
    Verify that file validated


*** Keywords ***
Verify that "Upload JSON file" button sellected by default
    Element Attribute Value Should Be  //div[contains(text(), 'Upload JSON file')]  class  option option--selected

Verify that file validated
    Wait until keyword succeeds
    ...      5 min
    ...      15 sec
    ...      Page Should Contain  Analysis has been completed