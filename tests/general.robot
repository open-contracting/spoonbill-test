*** Settings ***
Resource   tests/resources.robot
Library    RequestsLibrary
Library    PostgreSQLDB
Library    DebugLibrary

*** Keywords ***
Upload file
    [Arguments]  ${file_name}
    Create Session    httpbin    ${DOMAIN_URL}
    ${file_data}=    Get File For Streaming Upload    resources/data.json
    &{files}=    Create Dictionary    file=${file_data}
    ${resp}=    POST On Session    httpbin    uploads/    files=${files}
#    ${result}=    To Json    ${resp.json()}
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
