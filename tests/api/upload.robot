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
    ${response}=  Upload file by url API  https://standard.open-contracting.org/media/edf9c19b-a156-4f9c-a579-f83ecc472dcb/ocds-213czf-000-00001-02-tender.json
    ${id}=  Get Variable Value  ${response['id']}
    Wait until keyword succeeds
    ...      5 min
    ...      15 sec
    ...      Check validation status by url
    ...      ${id}
    ...      True