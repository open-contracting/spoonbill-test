*** Settings ***
Resource   tests/resources.robot
Resource   tests/general.robot

*** Test Cases ***
Upload json file
    ${response}=  Upload file  data.json
    ${id}=  Get Variable Value  ${response['id']}
    Wait until keyword succeeds
    ...      5 min
    ...      15 sec
    ...      Check validation status
    ...      ${id}
    ...      True


Upload json by url
    ${response}=  Upload file by url API  https://standard.open-contracting.org/media/95124a7c-aea9-42bc-b208-d60d9d1ae495/ocds-213czf-000-00001-02-tender.json
    ${id}=  Get Variable Value  ${response['id']}
    Wait until keyword succeeds
    ...      5 min
    ...      15 sec
    ...      Check validation status by url
    ...      ${id}
    ...      True