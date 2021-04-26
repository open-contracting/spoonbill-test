*** Settings ***
Resource   tests/resources.robot
Library    RequestsLibrary
Library    PostgreSQLDB
Library    DebugLibrary
Library    SeleniumLibrary
Library    Collections
Library    String

*** Keywords ***
Upload file
    [Arguments]  ${file_name}
    Create Session    httpbin    ${DOMAIN_URL}
    ${file_data}=    Get File For Streaming Upload    resources/data.json
    &{files}=    Create Dictionary    file=${file_data}
    ${resp}=    POST On Session    httpbin    uploads/    files=${files}
#    ${result}=    To Json    ${resp.json()}
    [Return]  ${resp.json()}

Upload file by url API
    [Arguments]  ${url}
    Create Session    httpbin    ${DOMAIN_URL}
    &{data}=    Create Dictionary    url=${url}
    ${resp}=    POST On Session    httpbin    urls/    ${data}
#    ${result}=    To Json    ${resp.json()}
    [Return]  ${resp.json()}


Get Uploads information
    [Arguments]  ${id}
    Create Session    httpbin    ${DOMAIN_URL}
    ${resp}=    GET On Session    httpbin    uploads/${id}
    [Return]  ${resp.json()}

Connect to DB
    PostgreSQLDB.Connect To Postgresql  dbname=${POSTGRES_DB}  dbusername=${POSTGRES_USER}  dbpassword=${POSTGRES_PASSWORD}  dbhost=127.0.0.1

Get data form DB
    [Arguments]  ${query}
    @{query}=  Execute Sql String  ${query}
    [Return]  @{query}

Check task status
    [Arguments]  ${task_id}  ${exp_status}
    ${task_status}=  Get data form DB  SELECT status FROM celery_taskmeta WHERE task_id = '${task_id}'
    Log  ${task_status}
    Should Contain  ${task_status[0]}  ${exp_status}

Check validation status
    [Arguments]  ${id}  ${expected}
    Create Session    httpbin    ${DOMAIN_URL}
    ${resp}=    GET On Session    httpbin    uploads/${id}
    Log  ${id}
    Should Be Equal  '${resp.json()['validation']['is_valid']}'  '${expected}'

Check validation status by url
    [Arguments]  ${id}  ${expected}
    Create Session    httpbin    ${DOMAIN_URL}
    ${resp}=    GET On Session    httpbin    urls/${id}
    Log  ${id}
    Should Be Equal  '${resp.json()['validation']['is_valid']}'  '${expected}'

Open new browser
    [Arguments]    ${Browser}=Chrome    ${alias}=${None}
    ${chrome_options} =     Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}   add_argument    headless
    Call Method    ${chrome_options}   add_argument    disable-gpu
    ${options}=     Call Method     ${chrome_options}    to_capabilities
    Open Browser    data:,    ${Browser}    alias=${alias}  desired_capabilities=${options}
    Set Window Size    1600     1081

Upload file by button
    [Arguments]  ${file_path}=None
    ${file_element}=  Set Variable  //input[@type='file']
    Choose File  ${file_element}  ${EXECDIR}/${file_path}

Upload file by url
    [Arguments]  ${url}=None
    Input text  //textarea  ${url}
    Click Element  //span[contains(text(), 'Submit')]/parent::node()


Select language
    [Arguments]  ${language}
    Click Element  //div[@class='lang-selector']
    Click Element  //div[@class="lang" and contains(text(), '${language}')]

Select tables by name API
    [Arguments]  ${names}  ${id}
    Create Session    httpbin    ${DOMAIN_URL}  disable_warnings=1
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
    Create Session    httpbin    ${DOMAIN_URL}  disable_warnings=1
    @{result}=  Create List
    &{data}=    Create Dictionary    include=${False}
    ${resp}=    PATCH On Session    httpbin    uploads/${file_id}/selections/${selection_id}/tables/${table_id}/    json=${data}
    [Return]  ${resp.json()}


Include by id API
    [Arguments]  ${file_id}  ${selection_id}  ${table_id}
    Create Session    httpbin    ${DOMAIN_URL}  disable_warnings=1
    @{result}=  Create List
    &{data}=    Create Dictionary    include=${True}
    ${resp}=    PATCH On Session    httpbin    uploads/${file_id}/selections/${selection_id}/tables/${table_id}/    json=${data}
    [Return]  ${resp.json()}


Get active status
    ${status}=  Get Text  //div[contains(@class, 'step--active')]/div
    [Return]  ${status}