#!/usr/bin/env python
*** Settings ***
Resource   tests/resources.robot
Resource   tests/general.robot


*** Test Cases ***
CLI simple test
    [Setup]  Run Keyword  Remove Files
    ...      resources/parties.csv
    ...      resources/tenders.csv
    ...      resources/data.json.state
    ...      resources/result.xlsx
    ${result}=  Run Process  spoonbill --selection tenders,parties ../../resources/data.json --csv ../../resources/ --xlsx ../../resources/test.xlsx
    ...      alias=myproc
    ...      shell=True
    ...      cwd=${CURDIR}
    ${r}=  Get Process Result  myproc
    Log  ${r.stdout}
    File should exists  resources/parties.csv
    File should exists  resources/tenders.csv
    File should exists  resources/data.json.state
    File should exists  resources/test.xlsx
    Open Excel Document  resources/test.xlsx  doc_id=result
    ${xlsx_sheets}=  Get List Sheet Names
    List Should Contain Value	${xlsx_sheets}  parties
    List Should Contain Value	${xlsx_sheets}  tenders


*** Keywords ***
File should exists
  [Arguments]    ${file_path}
  File Should Exist  ${file_path}
  Log    File was successfully created ${file_path}