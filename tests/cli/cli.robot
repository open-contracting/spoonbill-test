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


CLI test --human option
    [Setup]  Run Keyword  Remove Files
    ...      resources/parties.csv
    ...      resources/tenders.csv
    ...      resources/data.json.state
    ...      resources/result.xlsx
    ${result}=  Run Process  spoonbill --selection tenders,parties ../../resources/data.json --csv ../../resources/ --xlsx ../../resources/test.xlsx --human
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
    ${xlsx_tenders_row}=  Read Excel Row  0  sheet_name=tenders
    ${xlsx_parties_row}=  Read Excel Row  0  sheet_name=parties
    Check list does not contain symbol  ${xlsx_tenders_row}  /
    Check list does not contain symbol  ${xlsx_tenders_row}  _
    Check list does not contain symbol  ${xlsx_parties_row}  /
    Check list does not contain symbol  ${xlsx_parties_row}  _


*** Keywords ***
File should exists
  [Arguments]    ${file_path}
  File Should Exist  ${file_path}
  Log    File was successfully created ${file_path}


Check list does not contain symbol
    [Arguments]  ${list}  ${symbol}
    FOR  ${string}  IN  @{list}
        Should Not Contain  ${string}  ${symbol}
    END