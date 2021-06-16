#!/usr/bin/env python
*** Settings ***
Resource   tests/resources.robot
Resource   tests/general.robot
Test Setup   run keyword  Close Current Excel Document
Test Teardown  run keyword  Close Current Excel Document

*** Test Cases ***
CLI simple test
    [Setup]  Run Keyword  Remove Files
    ...      resources/parties.csv
    ...      resources/tenders.csv
    ...      resources/data.json.state
    ...      resources/result.xlsx
    File Should Exist  resources/data.json  json is missing
    @{files}  List Directory  resources/
    Log  ${files}
    ${result}=  Run Process  spoonbill --selection tenders,parties resources/data.json --csv resources/ --xlsx resources/result.xlsx
    ...      alias=myproc
    ...      shell=True
    ...      cwd=${EXECDIR}
    @{files}  List Directory  resources/
    Log  ${files}
    ${r}=  Get Process Result  myproc
    Log  ${r.stdout}
    File should exists  ${EXECDIR}/resources/parties.csv
    File should exists  ${EXECDIR}/resources/tenders.csv
    File should exists  ${EXECDIR}/resources/data.json.state
    File should exists  ${EXECDIR}/resources/result.xlsx
    Open Excel Document  ${EXECDIR}/resources/result.xlsx  doc_id=result
    ${xlsx_sheets}=  Get List Sheet Names
    List Should Contain Value	${xlsx_sheets}  parties
    List Should Contain Value	${xlsx_sheets}  tenders


CLI test --human option
    [Setup]  Run Keyword  Remove Files
    ...      resources/parties.csv
    ...      resources/tenders.csv
    ...      resources/data.json.state
    ...      resources/result.xlsx
    ${result}=  Run Process  spoonbill --selection tenders,parties resources/data.json --csv resources/ --xlsx resources/result.xlsx --human
    ...      alias=myproc
    ...      shell=True
    ...      cwd=${EXECDIR}
    ${r}=  Get Process Result  myproc
    Log  ${r.stdout}
    File should exists  resources/parties.csv
    File should exists  resources/tenders.csv
    File should exists  resources/data.json.state
    File should exists  resources/result.xlsx
    Open Excel Document  resources/result.xlsx  doc_id=result

    ${xlsx_tenders_row}=  Read Excel Row  0  sheet_name=tenders
    ${xlsx_parties_row}=  Read Excel Row  0  sheet_name=parties
    Check list does not contain symbol  ${xlsx_tenders_row}  /
    Check list does not contain symbol  ${xlsx_tenders_row}  _
    Check list does not contain symbol  ${xlsx_parties_row}  /
    Check list does not contain symbol  ${xlsx_parties_row}  _

    ${csv_tenders_title}=  read csv as list  resources/tenders.csv
    ${csv_parties_title}=  read csv as list  resources/parties.csv
    Check list does not contain symbol  ${csv_tenders_title[0]}  /
    Check list does not contain symbol  ${csv_tenders_title[0]}  _
    Check list does not contain symbol  ${csv_parties_title[0]}  /
    Check list does not contain symbol  ${csv_parties_title[0]}  _

*** Keywords ***
File should exists
  [Arguments]    ${file_path}
  Wait until keyword succeeds
    ...      1 min
    ...      3 sec
    ...      File Should Exist  ${file_path}
  Log    File was successfully created ${file_path}


Check list does not contain symbol
    [Arguments]  ${list}  ${symbol}
    FOR  ${string}  IN  @{list}
        Should Not Contain  ${string}  ${symbol}
    END