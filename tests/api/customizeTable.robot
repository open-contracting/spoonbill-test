*** Settings ***
Resource   tests/resources.robot
Resource   tests/general.robot

*** Test Cases ***
Selection tables
    ${id}=  Upload json file  data1.json
    @{list}=  Create List  tenders  awards  contracts  planning  parties
    ${selection_resp}=  Select tables by name API  ${list}  ${id}
    ${tables_lenght}=  Get Length  ${selection_resp['tables']}
    Should Be True  ${tables_lenght} == 5


Exclude table
    ${id}=  Upload json file  data1.json
    @{list}=  Create List  tenders  awards  contracts  planning  parties
    ${selection_resp}=  Select tables by name API  ${list}  ${id}
    ${tables_lenght}=  Get Length  ${selection_resp['tables']}
    Should Be True  ${tables_lenght} == 5
    ${resp}=  Exclude by id API  ${id}  ${selection_resp['id']}  ${selection_resp['tables'][0]['id']}
    Should Be Equal  '${resp['include']}'  'False'


Include table
    ${id}=  Upload json file  data1.json
    @{list}=  Create List  tenders  awards  contracts  planning  parties
    ${selection_resp}=  Select tables by name API  ${list}  ${id}
    ${tables_lenght}=  Get Length  ${selection_resp['tables']}
    Should Be True  ${tables_lenght} == 5
    ${resp}=  Include by id API  ${id}  ${selection_resp['id']}  ${selection_resp['tables'][0]['id']}
    Should Be Equal  '${resp['include']}'  'True'


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



