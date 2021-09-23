*** Settings ***
Resource   tests/resources.robot
Resource   tests/general.robot
Library    tests.methods  WITH NAME    METHODS

Suite Setup  run keyword  Set Selenium Speed  0.4
Test Setup    run keyword    Open new browser
Test Teardown  run keyword  Close all browsers

*** Test Cases ***
Translate stepper header
    [Tags]  noncritical
    Go to  ${MAIN_URL}
    ${stepper_items}=  Get WebElements  //div[@class="v-stepper__label"]/span
    ${upload_file}=  Get Text  ${stepper_items[0]}
    ${upload_file_translate}=  METHODS.get_translate_by_text_from_file  ${WEB_TRANSLATE_FILE}  ${upload_file}
    ${select_data}=  Get Text  ${stepper_items[1]}
    ${select_data_translate}=  METHODS.get_translate_by_text_from_file  ${WEB_TRANSLATE_FILE}  ${select_data}
    ${customize_tables}=  Get Text  ${stepper_items[2]}
    ${customize_tables_translate}=  METHODS.get_translate_by_text_from_file  ${WEB_TRANSLATE_FILE}  ${customize_tables}
    ${edit_headings}=  Get Text  ${stepper_items[3]}
    ${edit_headings_translate}=  METHODS.get_translate_by_text_from_file  ${WEB_TRANSLATE_FILE}  ${edit_headings}
    ${download}=  Get Text  ${stepper_items[4]}
    ${download_translate}=  METHODS.get_translate_by_text_from_file  ${WEB_TRANSLATE_FILE}  ${download}

    Select language  Española
    Sleep  1
    ${stepper_items_spanish}=  Get WebElements  //div[@class="v-stepper__label"]/span
    ${upload_file_spanish}=  Get Text  ${stepper_items_spanish[0]}
    ${select_data_spanish}=  Get Text  ${stepper_items_spanish[1]}
    ${customize_tables_spanish}=  Get Text  ${stepper_items_spanish[2]}
    ${edit_headings_spanish}=  Get Text  ${stepper_items_spanish[3]}
    ${download_spanish}=  Get Text  ${stepper_items_spanish[4]}
    Run Keyword If  '${upload_file_translate}' != '${Empty}'   Should Be Equal  ${upload_file_translate}  ${upload_file_spanish}
    Run Keyword If  '${select_data_translate}' != '${Empty}'  Should Be Equal  ${select_data_translate}  ${select_data_spanish}
    Run Keyword If  '${customize_tables_translate}' != '${Empty}'  Should Be Equal  ${customize_tables_translate}  ${customize_tables_spanish}
    Run Keyword If  '${edit_headings_translate}' != '${Empty}'  Should Be Equal  ${edit_headings_translate}  ${edit_headings_spanish}
    Run Keyword If  '${download_translate}' != '${Empty}'  Should Be Equal  ${download_translate}  ${download_spanish}


Translate Upload Json File button
    [Tags]  noncritical
    Go to  ${MAIN_URL}
    ${upload_json_file_element}=  Get WebElement  //div[contains(text(), 'Upload JSON file')]
    ${upload_json_file}=  Get Text  ${upload_json_file_element}
    ${upload_json_file_translate}=  METHODS.get_translate_by_text_from_file  ${WEB_TRANSLATE_FILE}  ${upload_json_file}

    Assign Id To Element  ${upload_json_file_element}  upload-json
    Select language  Española

    ${upload_json_file_es}=  Get WebElement  //div[@id='upload-json']
    ${upload_json_file_es}=  Get Text  ${upload_json_file_es}

    Should Be Equal  ${upload_json_file_translate}  ${upload_json_file_es}


Translate Supply a URL for JSON button
    [Tags]  noncritical
    Go to  ${MAIN_URL}
    ${upload_json_url_element}=  Get WebElement  //div[contains(text(), 'Supply a URL for JSON')]
    ${upload_json_url}=  Get Text  ${upload_json_url_element}
    ${upload_json_url_translate}=  METHODS.get_translate_by_text_from_file  ${WEB_TRANSLATE_FILE}  ${upload_json_url}

    Assign Id To Element  ${upload_json_url_element}  upload-url-json
    Select language  Española

    ${upload_json_url_es}=  Get WebElement  //div[@id='upload-url-json']
    ${upload_json_url_es}=  Get Text  ${upload_json_url_es}

    Should Be Equal  ${upload_json_url_translate}  ${upload_json_url_es}


Translate Browse files button
    [Tags]  noncritical
    Go to  ${MAIN_URL}
    ${browse_files_element}=  Get WebElement  //span[contains(text(), 'Browse files')]
    ${browse_files}=  Get Text  ${browse_files_element}
    ${browse_files_translate}=  METHODS.get_translate_by_text_from_file  ${WEB_TRANSLATE_FILE}  ${browse_files}

    Assign Id To Element  ${browse_files_element}  browse-files
    Select language  Española

    ${browse_files_es}=  Get WebElement  //span[@id='browse-files']
    ${browse_files_es}=  Get Text  ${browse_files_es}

    Should Be Equal  ${browse_files_translate}  ${browse_files_es}


Translate "Continue to select tables" button
    [Tags]  noncritical
    Go to  ${MAIN_URL}
    Upload file by button  resources/data.json
    Verify that file validated
    Sleep  1
    ${continue_element}=  Get WebElement  //span[contains(text(), 'Continue to select tables')]
    ${continue}=  Get Text  ${continue_element}
    ${continue_translate}=  METHODS.get_translate_by_text_from_file  ${WEB_TRANSLATE_FILE}  ${continue}

    Assign Id To Element  ${continue_element}  continue-select-tables
    Select language  Española
    ${continue_es}=  Get WebElement  //span[@id='continue-select-tables']
    ${continue_es}=  Get Text  ${continue_es}

    Should Be Equal  ${continue_translate}  ${continue_es}


Translate on Select Data page
    [Tags]  noncritical
    Go to  ${MAIN_URL}
    Upload file by button  resources/data.json
    Verify that file validated
    Click on "Continue to select tables" button

    ${Available tables element}=  Get WebElement  //p[contains(text(), 'Available tables')]
    ${Selected tables element}=  Get WebElement  //p[contains(text(), 'Selected tables')]
    ${Add element}=  Get WebElement  //span[contains(text(), 'Add')]
    ${Remove element}=  Get WebElement  //span[contains(text(), 'Remove')]
    ${Select data to flatten to Excel/CSV element}=  Get WebElement  //h2[contains(@class, 'page-title')]
    ${Continue element}=  Get WebElement  //span[contains(text(), 'Continue')]

    ${Available tables}=  Get Text  ${Available tables element}
    ${Selected tables}=  Get Text  ${Selected tables element}
    ${Add}=  Get Text  ${Add element}
    ${Remove}=  Get Text  ${Remove element}
    ${Select data to flatten to Excel/CSV}=  Get Text  ${Select data to flatten to Excel/CSV element}
    ${Continue}=  Get Text  ${Continue element}

    ${Available tables_translate}=  METHODS.get_translate_by_text_from_file  ${WEB_TRANSLATE_FILE}  ${Available tables}
    ${Selected tables_translate}=  METHODS.get_translate_by_text_from_file  ${WEB_TRANSLATE_FILE}  ${Selected tables}
    ${Add_translate}=  METHODS.get_translate_by_text_from_file  ${WEB_TRANSLATE_FILE}  ${Add}
    ${Remove_translate}=  METHODS.get_translate_by_text_from_file  ${WEB_TRANSLATE_FILE}  ${Remove}
    ${Select data to flatten to Excel/CSV_translate}=  METHODS.get_translate_by_text_from_file  ${WEB_TRANSLATE_FILE}  ${Select data to flatten to Excel/CSV}
    ${Continue_translate}=  METHODS.get_translate_by_text_from_file  ${WEB_TRANSLATE_FILE}  ${Continue}

    Assign Id To Element  ${Available tables element}  available-tables-element
    Assign Id To Element  ${Selected tables element}  selected-tables-element
    Assign Id To Element  ${Add element}  add-element
    Assign Id To Element  ${Remove element}  remove-element
    Assign Id To Element  ${Select data to flatten to Excel/CSV element}  select-data-to-flatten
    Assign Id To Element  ${Continue element}  continue-element

    Select language  Española

    ${Available tables element}=  Get WebElement  //p[@id="available-tables-element"]
    ${Selected tables element}=  Get WebElement  //p[@id="selected-tables-element"]
    ${Add element}=  Get WebElement  //span[@id="add-element"]
    ${Remove element}=  Get WebElement  //span[@id="remove-element"]
    ${Select data to flatten to Excel/CSV element}=  Get WebElement  //h2[@id="select-data-to-flatten"]
    ${Continue element}=  Get WebElement  //span[@id="continue-element"]

    ${Available tables translated}=  Get Text  ${Available tables element}
    ${Selected tables translated}=  Get Text  ${Selected tables element}
    ${Add translated}=  Get Text  ${Add element}
    ${Remove translated}=  Get Text  ${Remove element}
    ${Select data to flatten to Excel/CSV translated}=  Get Text  ${Select data to flatten to Excel/CSV element}
    ${Continue translated}=  Get Text  ${Continue element}

    Should Be Equal  ${Available tables_translate}  ${Available tables translated}
    Should Be Equal  ${Selected tables_translate}  ${Selected tables translated}
    Should Be Equal  ${Add_translate}  ${Add translated}
    Should Be Equal  ${Remove_translate}  ${Remove translated}
    Should Be Equal  ${Select data to flatten to Excel/CSV_translate}  ${Select data to flatten to Excel/CSV translated}
    Should Be Equal  ${Continue_translate}  ${Continue translated}


Translate on Customize table page
    [Tags]  noncritical
    Go to  ${MAIN_URL}
    Upload file by button  resources/data.json
    Verify that file validated
    Click on "Continue to select tables" button
    Select element from "Available tables" list  parties
    Click on "Add" button
    Click on "Continue" button

    ${Customize Tables element}=  Get WebElement  //h2[contains(@class, 'page-title')]
    ${Available data element}=  Get WebElement  //p[contains(text(), 'Available data')]
    ${Remove table element}=  Get WebElement  //span[contains(text(), 'Remove table')]
    ${Save and Continue element}=  Get WebElement  //span[contains(text(), 'Save and Continue')]

    ${Customize Tables EN}=  Get Text  ${Customize Tables element}
    ${Available data EN}=  Get Text  ${Available data element}
    ${Remove table EN}=  Get Text  ${Remove table element}
    ${Save and Continue EN}=  Get Text  ${Save and Continue element}

    ${Customize Tables_translate}=  METHODS.get_translate_by_text_from_file  ${WEB_TRANSLATE_FILE}  ${Customize Tables EN}
    ${Available data_translate}=  METHODS.get_translate_by_text_from_file  ${WEB_TRANSLATE_FILE}  ${Available data EN}
    ${Remove table_translate}=  METHODS.get_translate_by_text_from_file  ${WEB_TRANSLATE_FILE}  ${Remove table EN}
    ${Save and Continue_translate}=  METHODS.get_translate_by_text_from_file  ${WEB_TRANSLATE_FILE}  ${Save and Continue EN}

    Assign Id To Element  ${Customize Tables element}  customize-tables-element
    Assign Id To Element  ${Available data element}  available-data-element
    Assign Id To Element  ${Remove table element}  remove-table-element
    Assign Id To Element  ${Save and Continue element}  save-and-continue-element

    Select language  Española

    ${Customize Tables element}=  Get WebElement  //h2[@id="customize-tables-element"]
    ${Available data element}=  Get WebElement  //p[@id="available-data-element"]
    ${Remove table element}=  Get WebElement  //span[@id="remove-table-element"]
    ${Save and Continue element}=  Get WebElement  //span[@id="save-and-continue-element"]

    ${Customize Tables translated}=  Get Text  ${Customize Tables element}
    ${Available tables translated}=  Get Text  ${Available data element}
    ${Remove table translated}=  Get Text  ${Remove table element}
    ${Save and Continue translated}=  Get Text  ${Save and Continue element}

    Should Be Equal  ${Customize Tables_translate}  ${Customize Tables translated}
    Should Be Equal  ${Available data_translate}  ${Available tables translated}
    Should Be Equal  ${Remove table_translate}  ${Remove table translated}
    Should Be Equal  ${Save and Continue_translate}  ${Save and Continue translated}


*** Keywords ***
Verify that "Upload JSON file" button sellected by default
    Element Attribute Value Should Be  //div[contains(text(), 'Upload JSON file')]  class  option option--selected

Verify that file validated
    Wait until keyword succeeds
    ...      5 min
    ...      15 sec
    ...      Page Should Contain  Your file has been checked and is ready to use.


Click on "Save and Continue" button
    Click Element  //span[contains(text(), 'Save and Continue')]/parent::node()

Select element from "Available tables" list
    [Arguments]  ${element}
    ${element}=  Convert To Lower Case  ${element}
    Click Element  //p[contains(text(), 'Available tables')]/following-sibling::div//span[contains(text(), '${element}')]

Click on "Add" button
    Click Element  //span[contains(text(), 'Add')]/parent::node()

Click on "Continue" button
    Click Element  //span[contains(text(), 'Continue')]/parent::node()