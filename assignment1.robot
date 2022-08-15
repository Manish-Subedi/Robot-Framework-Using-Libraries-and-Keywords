
*** Settings *** 
Library    OperatingSystem
Library    Collections
Library    String
Library    Dialogs
Library    FakerLibrary    locale=fi_FI

*** Variables ***
@{random_names}    ${EMPTY}
${file_name}

*** Test cases ***
Remove an existing File
  ${delete_file}     Get Value From User    Name of the file to be deleted?  
  ${status}    Run Keyword And Return Status    FILE SHOULD EXIST     ${delete_file}
  #log    ${status}
  Run Keyword if    ${status}==True    Remove Existing Address File    ${delete_file}    

Create a new address File
  Get Random Names     5   
  ${chosen_name}    Get Selection From User    Select a name    @{random_names}     
  ${forenam}        Fetch From Left    ${chosen_name}    ${SPACE}    
  ${file_name}      Catenate    ${forenam}.txt   
  ${address}        FakerLibrary.Address   
  Append to File    ${file_name}    ${chosen_name}\n${address}   

Check for lines in a File
  Check for lines   ${file_name}   
 

*** Keywords **** 
Get Random Names 
  [Arguments]     ${arg}  
    FOR   ${0}    IN RANGE    ${arg}    
      ${each_name}    FakerLibrary.Name
      APPEND TO LIST    ${random_names}    ${each_name}
    END
  [Return]        @{random_names}   

Remove Existing Address File
  [Arguments]               ${arg}                
  ${contents}               Get File    ${arg}    
  ${first}                  Get Line    ${contents}    0    
  Log                       ${first}   
  Remove File               ${arg}   


Check for lines
  [Arguments]       ${arg}    
  ${contents}       Get File     ${arg}    
  ${line_count}     Get Line Count    ${contents}    
  ${status}         Evaluate    ${line_count}==3    