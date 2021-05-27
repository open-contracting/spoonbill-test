*** Settings ***
Resource   tests/resources.robot
Resource   tests/general.robot

*** Test Cases ***
Available tables
    ${id}=  Upload json file
    ...      data.json
    ${data}=  Get Uploads information  ${id}
    Check that element exists in Avaliable tables  parties  ${data}
    Check that element exists in Avaliable tables  tenders  ${data}
    Check that element exists in Avaliable tables  documents  ${data}
    Run Keyword And Expect Error  *  Check that element exists in Avaliable tables  contracts  ${data}
    Run Keyword And Expect Error  *  Check that element exists in Avaliable tables  planning  ${data}



*** Keywords ***
Upload json file
    [Arguments]  ${file_name}
    ${response}=  Upload file  ${file_name}
    ${id}=  Get Variable Value  ${response['id']}
    Wait until keyword succeeds
    ...      5 min
    ...      15 sec
    ...      Check validation status
    ...      ${id}
    ...      True
    [Return]  ${id}


Check that element exists in Avaliable tables
    [Arguments]  ${element}  ${data}
    @{result}=  Create List
    FOR  ${item}  IN  @{data['available_tables']}
        ${item_name}=  Get Variable Value  ${item['name']}
        Append to List  ${result}  ${item_name}
    END
    List Should Contain Value  ${result}  ${element}