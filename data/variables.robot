*** Variables ***
# Global test data storage for maintaining consistency across test suite

# User IDs
${GLOBAL_ADMIN_ID}         ${EMPTY}
${GLOBAL_USER_ID}          ${EMPTY}

# Product IDs
${GLOBAL_PRODUTO_ID}       ${EMPTY}
${GLOBAL_PRODUTO_ID_2}     ${EMPTY}

# Cart IDs
${GLOBAL_CARRINHO_ID}      ${EMPTY}

# Authentication Tokens
${GLOBAL_ADMIN_TOKEN}      ${EMPTY}
${GLOBAL_USER_TOKEN}       ${EMPTY}

# Generated User Data
${GLOBAL_ADMIN_DATA}       ${EMPTY}
${GLOBAL_USER_DATA}        ${EMPTY}

# Generated Product Data
${GLOBAL_PRODUTO_DATA}     ${EMPTY}
${GLOBAL_PRODUTO_DATA_2}   ${EMPTY}

# Test Execution Control
${SETUP_COMPLETED}         ${FALSE}

# API Response Storage
${GLOBAL_RESPONSE}         ${EMPTY}

*** Keywords ***
Armazenar ID Usuario Admin
    [Arguments]    ${user_id}
    Set Global Variable    ${GLOBAL_ADMIN_ID}    ${user_id}
    Log To Console    GLOBAL_ADMIN_ID definido como: ${user_id}

Armazenar ID Usuario Comum
    [Arguments]    ${user_id}
    Set Global Variable    ${GLOBAL_USER_ID}    ${user_id}
    Log To Console    GLOBAL_USER_ID definido como: ${user_id}

Armazenar ID Produto
    [Arguments]    ${produto_id}
    Set Global Variable    ${GLOBAL_PRODUTO_ID}    ${produto_id}
    Log To Console    GLOBAL_PRODUTO_ID definido como: ${produto_id}

Armazenar ID Produto Secundario
    [Arguments]    ${produto_id}
    Set Global Variable    ${GLOBAL_PRODUTO_ID_2}    ${produto_id}
    Log To Console    GLOBAL_PRODUTO_ID_2 definido como: ${produto_id}

Armazenar ID Carrinho
    [Arguments]    ${carrinho_id}
    Set Global Variable    ${GLOBAL_CARRINHO_ID}    ${carrinho_id}
    Log To Console    GLOBAL_CARRINHO_ID definido como: ${carrinho_id}

Armazenar Token Admin
    [Arguments]    ${token}
    Set Global Variable    ${GLOBAL_ADMIN_TOKEN}    ${token}
    Log To Console    GLOBAL_ADMIN_TOKEN definido como: ${token}

Armazenar Token Usuario
    [Arguments]    ${token}
    Set Global Variable    ${GLOBAL_USER_TOKEN}    ${token}
    Log To Console    GLOBAL_USER_TOKEN definido como: ${token}

Armazenar Dados Usuario Admin
    [Arguments]    ${user_data}
    Set Global Variable    ${GLOBAL_ADMIN_DATA}    ${user_data}
    Log To Console    GLOBAL_ADMIN_DATA definido como: ${user_data}

Armazenar Dados Usuario Comum
    [Arguments]    ${user_data}
    Set Global Variable    ${GLOBAL_USER_DATA}    ${user_data}
    Log To Console    GLOBAL_USER_DATA definido como: ${user_data}

Armazenar Dados Produto
    [Arguments]    ${produto_data}
    Set Global Variable    ${GLOBAL_PRODUTO_DATA}    ${produto_data}
    Log To Console    GLOBAL_PRODUTO_DATA definido como: ${produto_data}

Armazenar Dados Produto Secundario
    [Arguments]    ${produto_data}
    Set Global Variable    ${GLOBAL_PRODUTO_DATA_2}    ${produto_data}
    Log To Console    GLOBAL_PRODUTO_DATA_2 definido como: ${produto_data}

Marcar Setup Como Concluido
    Set Global Variable    ${SETUP_COMPLETED}    ${TRUE}
    Log To Console    SETUP_COMPLETED definido como: ${TRUE}

Armazenar Response
    [Arguments]    ${response}
    Set Global Variable    ${GLOBAL_RESPONSE}    ${response}
    Log To Console    GLOBAL_RESPONSE definido como: ${response}

Obter ID Usuario Admin
    RETURN    ${GLOBAL_ADMIN_ID}

Obter ID Usuario Comum
    RETURN    ${GLOBAL_USER_ID}

Obter ID Produto
    RETURN    ${GLOBAL_PRODUTO_ID}

Obter ID Produto Secundario
    RETURN    ${GLOBAL_PRODUTO_ID_2}

Obter ID Carrinho
    RETURN    ${GLOBAL_CARRINHO_ID}

Obter Token Admin
    RETURN    ${GLOBAL_ADMIN_TOKEN}

Obter Token Usuario
    RETURN    ${GLOBAL_USER_TOKEN}

Obter Dados Usuario Admin
    RETURN    ${GLOBAL_ADMIN_DATA}

Obter Dados Usuario Comum
    RETURN    ${GLOBAL_USER_DATA}

Obter Dados Produto
    RETURN    ${GLOBAL_PRODUTO_DATA}

Obter Dados Produto Secundario
    RETURN    ${GLOBAL_PRODUTO_DATA_2}

Verificar Se Setup Foi Concluido
    RETURN    ${SETUP_COMPLETED}

Obter Response
    RETURN    ${GLOBAL_RESPONSE}