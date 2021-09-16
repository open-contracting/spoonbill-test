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
    ${response}=  Upload file by url API  https://cdn-130.bayfiles.com/z6t2L7H0u9/5a01e51c-1631786582/2021-03-03.json
    ${id}=  Get Variable Value  ${response['id']}
    Wait until keyword succeeds
    ...      1 min
    ...      15 sec
    ...      Check validation status by url
    ...      ${id}
    ...      True