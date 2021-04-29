*** Settings ***
Resource   tests/resources.robot
Resource   tests/general.robot

*** Test Cases ***
Celery task completed successfully after upload file
    [Setup]    run keyword    Connect to DB
    [Teardown]  run keyword    PostgreSQLDB.Close All Postgresql Connections
    [Tags]  skip
    ${response}=  Upload file  data.json
    ${task_id}=  Get Variable Value  ${response['validation']['task_id']}
    Wait until keyword succeeds
    ...      5 min
    ...      15 sec
    ...      Check task status
    ...      ${task_id}
    ...      SUCCESS


Celery tasks completed successfully after upload few files
    [Setup]    run keyword    Connect to DB
    [Teardown]  run keyword    PostgreSQLDB.Close All Postgresql Connections
    [Tags]  skip
    ${response1}=  Upload file  data.json
    ${response2}=  Upload file  data.json
    ${response3}=  Upload file  data.json
    ${task1_id}=  Get Variable Value  ${response1['validation']['task_id']}
    ${task2_id}=  Get Variable Value  ${response2['validation']['task_id']}
    ${task3_id}=  Get Variable Value  ${response3['validation']['task_id']}
    Wait until keyword succeeds
    ...      5 min
    ...      15 sec
    ...      Check task status
    ...      ${task1_id}
    ...      SUCCESS
    Wait until keyword succeeds
    ...      5 min
    ...      15 sec
    ...      Check task status
    ...      ${task2_id}
    ...      SUCCESS
    Wait until keyword succeeds
    ...      5 min
    ...      15 sec
    ...      Check task status
    ...      ${task3_id}
    ...      SUCCESS