*** Settings ***
Resource   tests/resources.robot
Library    RequestsLibrary
Library    DebugLibrary
Library    SeleniumLibrary
Library    Collections
Library    String
Library    OperatingSystem
Library    ArchiveLibrary
Library    Process
Library    ExcelLibrary
Library    CSVLib


*** Keywords ***
Upload file
    [Arguments]  ${file_name}
    Create Session    httpbin    ${API_URL}  verify=true
    ${file_data}=    Get File For Streaming Upload    resources/data.json
    &{files}=    Create Dictionary    files=${file_data}
    ${resp}=    POST On Session    httpbin    uploads/    files=${files}
#    ${result}=    To Json    ${resp.json()}
    [Return]  ${resp.json()}

Upload file by url API
    [Arguments]  ${url}
    Create Session    httpbin    ${API_URL}  verify=true
    &{data}=    Create Dictionary    urls=${url}
    ${resp}=    POST On Session    httpbin    urls/    ${data}
#    ${result}=    To Json    ${resp.json()}
    [Return]  ${resp.json()}


Get Uploads information
    [Arguments]  ${id}
    Create Session    httpbin    ${API_URL}  verify=true
    ${resp}=    GET On Session    httpbin    uploads/${id}/
    [Return]  ${resp.json()}


Check validation status
    [Arguments]  ${id}  ${expected}
    Create Session    httpbin    ${API_URL}  verify=true
    ${resp}=    GET On Session    httpbin    uploads/${id}/
    Log  ${id}
    Should Be Equal  '${resp.json()['validation']['is_valid']}'  '${expected}'

Check validation status by url
    [Arguments]  ${id}  ${expected}
    Create Session    httpbin    ${API_URL}  verify=true
    ${resp}=    GET On Session    httpbin    urls/${id}/
    Log  ${id}
    Should Be Equal  '${resp.json()['validation']['is_valid']}'  '${expected}'

Open new browser
    [Arguments]    ${Browser}=Chrome    ${alias}=${None}
    ${download directory}    Join Path    ${OUTPUT DIR}    downloads_result
    Create Directory    ${download directory}
    ${chrome_options} =     Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}   add_argument    headless
    Call Method    ${chrome_options}   add_argument    disable-gpu
    # WebDriverException: Message: unknown error: Chrome failed to start: exited abnormally.
    # (unknown error: DevToolsActivePort file doesn't exist)
    Call Method    ${chrome_options}   add_argument    no-sandbox
    ${disabled}    Create List    Chrome PDF Viewer
    ${prefs}    Create Dictionary    download.default_directory=${download directory}    plugins.plugins_disabled=${disabled}
    Call Method    ${chrome options}    add_experimental_option    prefs    ${prefs}
    ${options}=     Call Method     ${chrome_options}    to_capabilities
    Open Browser    data:,    ${Browser}    alias=${alias}  desired_capabilities=${options}
    Set Window Size    1600     1081

Upload file by button
    [Arguments]  ${file_path}=None
    ${file_element}=  Set Variable  //input[@type='file']
    Choose File  ${file_element}  ${EXECDIR}/${file_path}

Upload file by url
    [Arguments]  ${url}=None
    Wait Until Element Is Enabled  //textarea  5s
    Input text  //textarea  ${url}
    Click Element  //span[contains(text(), 'Submit')]/parent::node()


Select language
    [Arguments]  ${language}
    Click Element  //div[@class='lang-selector']
    Sleep  1
    Click Element  //div[contains(@class, 'lang') and contains(text(), '${language}')]

Select tables by name API
    [Arguments]  ${names}  ${id}
    Create Session    httpbin    ${API_URL}  disable_warnings=1  verify=true
    @{result}=  Create List
    FOR  ${item}  IN  @{names}
        ${dict}=  Create Dictionary  name=${item}
        Append to List  ${result}  ${dict}
    END
    &{data}=    Create Dictionary    tables=${result}
    ${resp}=    POST On Session    httpbin    uploads/${id}/selections/    json=${data}
    [Return]  ${resp.json()}


Exclude by id API
    [Arguments]  ${file_id}  ${selection_id}  ${table_id}
    Create Session    httpbin    ${API_URL}  disable_warnings=1  verify=true
    @{result}=  Create List
    &{data}=    Create Dictionary    include=${False}
    ${resp}=    PATCH On Session    httpbin    uploads/${file_id}/selections/${selection_id}/tables/${table_id}/    json=${data}
    [Return]  ${resp.json()}


Include by id API
    [Arguments]  ${file_id}  ${selection_id}  ${table_id}
    Create Session    httpbin    ${API_URL}  disable_warnings=1  verify=true
    @{result}=  Create List
    &{data}=    Create Dictionary    include=${True}
    ${resp}=    PATCH On Session    httpbin    uploads/${file_id}/selections/${selection_id}/tables/${table_id}/    json=${data}
    [Return]  ${resp.json()}


Get active status
    ${status}=  Get Text  //div[contains(@class, 'step--active')]/div
    [Return]  ${status}


Multi select from "Available tables" list
    [Arguments]  ${element}
    ${element}=  Convert To Lower Case  ${element}
    Wait Until Element Is Enabled  //p[contains(text(), 'Available tables')]/following-sibling::div//span[contains(text(), '${element}')]
    Sleep  1
    ${system}=    Evaluate    platform.system()    platform
    Run Keyword IF  '${system}' == 'Darwin'
    ...      Click Element  //p[contains(text(), 'Available tables')]/following-sibling::div//span[contains(text(), '${element}')]  modifier=COMMAND
    ...      ELSE   Click Element  //p[contains(text(), 'Available tables')]/following-sibling::div//span[contains(text(), '${element}')]  modifier=CTRL


Select all from available tables
    Wait Until Element Is Enabled  //p[contains(text(), 'Available tables')]
    Sleep  1
    ${system}=    Evaluate    platform.system()    platform
    @{available_tables}=  Get WebElements  //div[@class='tables-list'][1]/div
    FOR  ${table}  IN  @{available_tables}
        Run Keyword IF  '${system}' == 'Darwin'
        ...      Click Element  ${table}  modifier=COMMAND
        ...      ELSE  Click Element  ${table}  modifier=CTRL
    END


Get list from selected tables
    Wait Until Element Is Enabled  //p[contains(text(), 'Selected tables')]
    Sleep  1
    @{selected_tables}=  Get WebElements  (//div[@class='tables-list'])[2]//span[@class='table-info__name']
    @{result}=  Create List
    FOR  ${table}  IN  @{selected_tables}
        ${table_name}=  Get Text  ${table}
        ${table_name}=  Convert To Lower Case  ${table_name}
        ${table_name}=  Strip String  ${table_name}  mode=both
        Append to List  ${result}  ${table_name}
    END
    [Return]  @{result}


Get tables from preview page
    @{tables}=  Get WebElements  //div[@role='tab']
    @{result}=  Create List
    FOR  ${table}  IN  @{tables}
        ${table_name}=  Get Text  ${table}
        ${table_name}=  Convert To Lower Case  ${table_name}
        ${table_name}=  Strip String  ${table_name}  mode=both
        Append to List  ${result}  ${table_name}
    END
    [Return]  @{result}

Multi select from "Selected tables" list
    [Arguments]  ${element}
    ${element}=  Convert To Lower Case  ${element}
    Sleep  1
    ${system}=    Evaluate    platform.system()    platform
    Run Keyword IF  '${system}' == 'Darwin'
    ...      Click Element  //p[contains(text(), 'Selected tables')]/following-sibling::div//span[contains(text(), '${element}')]  modifier=COMMAND
    ...      ELSE  Click Element  //p[contains(text(), 'Selected tables')]/following-sibling::div//span[contains(text(), '${element}')]  modifier=CTRL


Click on "Continue to select tables" button
    ${button}=  Set Variable  //span[contains(text(), 'Continue to select tables')]/parent::node()
    Wait Until Page Contains Element  ${button}
    Scroll Element Into View  ${button}
    Click Element  ${button}
    Sleep  1
