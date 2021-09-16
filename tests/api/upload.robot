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
    ${response}=  Upload file by url API  https://drive.google.com/uc?export=download&confirm=no_antivirus&id=1w-anUjSI4jkqwYIqOzTAHZOEk1CNG3O9
    ${id}=  Get Variable Value  ${response['id']}
    Wait until keyword succeeds
    ...      1 min
    ...      15 sec
    ...      Check validation status by url
    ...      ${id}
    ...      True