*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections
Resource   ../data/data_generation.robot
Resource   ../data/variables.robot
Resource   ../data/setup_helper.robot
Resource   validation.robot

*** Variables ***
${RESPONSE}    ${EMPTY}

*** Keywords ***
# KAN-1 Keywords
Dado que existe um Usuário Admin pré-cadastrado
    [Tags]    KAN-1
    ${admin_id}=    Obter ID Usuario Admin
    Run Keyword If    '${admin_id}' == '${EMPTY}'
    ...    Run Keywords
    ...    Dado que eu possuo dados únicos para um novo usuário Administrador    AND
    ...    Quando eu envio POST para /usuarios com "administrador": "true"
    ${admin_id}=    Obter ID Usuario Admin
    Log To Console    ${admin_id}    
    ${response}=    GET On Session    serverest    /usuarios/${admin_id}    expected_status=200
    ${json_response}=    Convert String To Json    ${response.text}
    ${email}=    Get Value From Json    ${json_response}    $.email
    ${password}=    Get Value From Json    ${json_response}    $.password
    Set Global Variable    ${ADMIN_EMAIL}    ${email[0]}
    Set Global Variable    ${ADMIN_PASSWORD}    ${password[0]}
Quando eu envio POST com credenciais válidas para a rota
    [Arguments]  ${endpoint}
    [Tags]    KAN-1
    ${login_data}=    Obter Dados Para Login    admin
    ${response}=    POST On Session    serverest    ${endpoint}    json=${login_data}    expected_status=200    msg=Falha ao realizar login com credenciais válidas
    Armazenar Response    ${response}

# KAN-4 Keywords
Dado que eu possuo dados únicos para um novo usuário Administrador
    [Tags]    KAN-4
    ${user_data}=    Obter Dados Para Novo Usuario  'admin'
    Armazenar Dados Usuario Admin  ${user_data}

Quando eu envio POST para /usuarios com "administrador": "true"
    [Tags]    KAN-4
    ${data}=    Obter Dados Usuario Admin
    ${response}=    POST On Session    serverest    /usuarios    json=${data}    expected_status=201    msg=Falha ao cadastrar usuário administrador
    ${json_response}=    Convert String To Json    ${response.text}
    ${user_id}=    Get Value From Json    ${json_response}    $._id
    Armazenar Response    ${response}
    Armazenar ID Usuario Admin    ${user_id[0]}
    Set Global Variable    ${ADMIN_EMAIL}    ${data.email}    
    Set Global Variable    ${ADMIN_PASSWORD}    ${data.password}

Dado que eu possuo dados únicos para um novo usuário comum
    [Tags]    KAN-29
    ${user_data}=    Obter Dados Para Novo Usuario    'comum'
    Armazenar Dados Usuario Comum    ${user_data}

Quando eu envio POST para /usuarios com "administrador": "false"
    [Tags]    KAN-29
    ${data}=    Obter Dados Usuario Comum
    ${response}=    POST On Session    serverest    /usuarios    json=${data}    expected_status=201    msg=Falha ao cadastrar usuário comum
    ${json_response}=    Convert String To Json    ${response.text}
    ${user_id}=    Get Value From Json    ${json_response}    $._id
    Armazenar Response    ${response}
    Armazenar ID Usuario Comum    ${user_id[0]}
    Set Global Variable    ${USER_EMAIL}    ${data.email}
    Set Global Variable    ${USER_PASSWORD}    ${data.password}

# KAN-6 Keywords
Dado que um usuário foi cadastrado com sucesso e seu _id foi salvo
    [Tags]    KAN-6
    ${user_id}=    Obter ID Usuario Admin
    Run Keyword If    '${user_id}' == '${EMPTY}'
    ...    Run Keywords
    ...    Dado que eu possuo dados únicos para um novo usuário Administrador    AND
    ...    Quando eu envio POST para /usuarios com "administrador": "true"
    ${user_id}=    Obter ID Usuario Admin
    Should Not Be Empty    ${user_id}

Quando eu envio GET para a rota /usuarios/_id com o _id salvo
    [Tags]    KAN-6
    ${user_id}=    Obter ID Usuario Admin
    ${response}=    GET On Session    serverest    /usuarios/${user_id}    expected_status=200    msg=Falha ao buscar usuário pelo ID
    Armazenar Response    ${response}

# KAN-15 Keywords
Dado que o _id de um usuário sem carrinho foi salvo
    [Tags]    KAN-15
    ${user_id}=    Obter ID Usuario Admin
    Run Keyword If    '${user_id}' == '${EMPTY}'
    ...    Run Keywords
    ...    Dado que eu possuo dados únicos para um novo usuário Administrador    AND
    ...    Quando eu envio POST para /usuarios com "administrador": "true"
    ${user_id}=    Obter ID Usuario Admin
    Should Not Be Empty    ${user_id}

Dado que o Token Admin é válido
    [Tags]    KAN-15    KAN-18
    ${admin_id}=    Obter ID Usuario Admin
    Run Keyword If    '${admin_id}' == '${EMPTY}'
    ...    Run Keywords
    ...    Dado que eu possuo dados únicos para um novo usuário Administrador    AND
    ...    Quando eu envio POST para /usuarios com "administrador": "true"
    ${login_data}=    Obter Dados Para Login    admin
    ${response}=    POST On Session    serverest    /login    json=${login_data}    expected_status=200    msg=Falha ao obter token admin
    ${json_response}=    Convert String To Json    ${response.text}
    ${token}=    Get Value From Json    ${json_response}    $.authorization
    Armazenar Token Admin    ${token[0]}
    Set Test Variable    ${AUTH_HEADERS}    {"Authorization": "${token[0]}"}

Quando eu envio DELETE para /usuarios/_id com Token
    [Tags]    KAN-15
    ${user_id}=    Obter ID Usuario Admin
    ${response}=    DELETE On Session    serverest    /usuarios/${user_id}    expected_status=200    msg=Falha ao excluir usuário
    Armazenar Response    ${response}

# KAN-18 Keywords
Quando eu envio POST para /produtos com Token e dados de produto únicos
    [Tags]    KAN-18
    ${produto_data}=    Obter Dados Para Novo Produto
    ${token}=    Obter Token Admin
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    POST On Session    serverest    /produtos    json=${produto_data}    headers=${headers}    expected_status=201    msg=Falha ao cadastrar produto
    Armazenar Response    ${response}
    ${json_response}=    Convert String To Json    ${response.text}
    ${produto_id}=    Get Value From Json    ${json_response}    $._id
    Armazenar ID Produto    ${produto_id[0]}

# KAN-29 Keywords
Dado que o Token do usuário é válido
    [Tags]    KAN-29    KAN-37    KAN-40
    ${user_id}=    Obter ID Usuario Comum
    Run Keyword If    '${user_id}' == '${EMPTY}'
    ...    Run Keywords
    ...    Dado que eu possuo dados únicos para um novo usuário comum    AND
    ...    Quando eu envio POST para /usuarios com "administrador": "false"
    ${login_data}=    Obter Dados Para Login    usuario
    ${response}=    POST On Session    serverest    /login    json=${login_data}    expected_status=200    msg=Falha ao obter token do usuário
    ${json_response}=    Convert String To Json    ${response.text}
    ${token}=    Get Value From Json    ${json_response}    $.authorization
    Armazenar Token Usuario    ${token[0]}
    Set Test Variable    ${AUTH_HEADERS}    {"Authorization": "${token[0]}"}

E o idProduto existe com quantidade em estoque suficiente
    [Tags]    KAN-29
    ${produto_id}=    Obter ID Produto
    Run Keyword If    '${produto_id}' == '${EMPTY}'
    ...    Quando eu envio POST para /produtos com Token e dados de produto únicos
    ${produto_id}=    Obter ID Produto
    Should Not Be Empty    ${produto_id}

E produtos com estoque suficiente foram criados
    [Tags]    KAN-29
    # Criar primeiro produto
    ${produto1_data}=    Obter Dados Para Novo Produto
    ${token_admin}=    Obter Token Admin
    ${headers}=    Create Dictionary    Authorization=${token_admin}
    ${response1}=    POST On Session    serverest    /produtos    json=${produto1_data}    headers=${headers}    expected_status=201
    ${json1}=    Convert String To Json    ${response1.text}
    ${produto1_id}=    Get Value From Json    ${json1}    $._id
    Armazenar ID Produto 1    ${produto1_id[0]}
    
    # Criar segundo produto
    ${produto2_data}=    Obter Dados Para Novo Produto
    ${response2}=    POST On Session    serverest    /produtos    json=${produto2_data}    headers=${headers}    expected_status=201
    ${json2}=    Convert String To Json    ${response2.text}
    ${produto2_id}=    Get Value From Json    ${json2}    $._id
    Armazenar ID Produto 2    ${produto2_id[0]}

E a quantidade inicial dos produtos foi salva
    [Tags]    KAN-29
    ${produto1_id}=    Obter ID Produto 1
    ${produto2_id}=    Obter ID Produto 2
    
    ${response1}=    GET On Session    serverest    /produtos/${produto1_id}    expected_status=200
    ${json1}=    Convert String To Json    ${response1.text}
    ${qtd1}=    Get Value From Json    ${json1}    $.quantidade
    Armazenar Quantidade Inicial Produto 1    ${qtd1[0]}
    
    ${response2}=    GET On Session    serverest    /produtos/${produto2_id}    expected_status=200
    ${json2}=    Convert String To Json    ${response2.text}
    ${qtd2}=    Get Value From Json    ${json2}    $.quantidade
    Armazenar Quantidade Inicial Produto 2    ${qtd2[0]}

Quando eu envio POST para /carrinhos com Token e dados válidos
    [Tags]    KAN-29
    ${produto_id}=    Obter ID Produto
    ${carrinho_data}=    Create Dictionary    produtos=${EMPTY}
    ${produtos_list}=    Create List
    ${produto}=    Create Dictionary    idProduto=${produto_id}    quantidade=${1}
    Append To List    ${produtos_list}    ${produto}
    Set To Dictionary    ${carrinho_data}    produtos=${produtos_list}
    
    ${token}=    Obter Token Admin
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    POST On Session    serverest    /carrinhos    json=${carrinho_data}    headers=${headers}    expected_status=201    msg=Falha ao criar carrinho
    Armazenar Response    ${response}
    ${json}=    Convert String To Json    ${response.text}
    ${carrinho_id}=    Get Value From Json    ${json}    $._id
    Armazenar ID Carrinho    ${carrinho_id}

# KAN-37 Keywords
E o usuário possui um carrinho ativo
    [Tags]    KAN-37
    ${carrinho_id}=    Obter ID Carrinho
    Run Keyword If    '${carrinho_id}' == '${EMPTY}'
    ...    Run Keywords
    ...    E o idProduto existe com quantidade em estoque suficiente    AND
    ...    Quando eu envio POST para /carrinhos com Token e dados válidos
    ${carrinho_id}=    Obter ID Carrinho
    Should Not Be Empty    ${carrinho_id}

Quando eu envio DELETE para /carrinhos/concluir-compra com Token
    [Tags]    KAN-37
    ${token}=    Obter Token Admin
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    DELETE On Session    serverest    /carrinhos/concluir-compra    headers=${headers}    expected_status=200    msg=Falha ao concluir compra
    Armazenar Response    ${response}

# KAN-40 Keywords
E o usuário possui um carrinho ativo com produtos
    [Tags]    KAN-40
    ${carrinho_id}=    Obter ID Carrinho
    Run Keyword If    '${carrinho_id}' == '${EMPTY}'
    ...    Run Keywords
    ...    E o idProduto existe com quantidade em estoque suficiente    AND
    ...    Quando eu envio POST para /carrinhos com Token e dados válidos
    ${carrinho_id}=    Obter ID Carrinho
    Should Not Be Empty    ${carrinho_id}

E a Quantidade Inicial de Estoque X foi salva
    [Tags]    KAN-40
    ${produto_id}=    Obter ID Produto
    ${response}=    GET On Session    serverest    /produtos/${produto_id}    expected_status=200    msg=Falha ao buscar produto para salvar quantidade inicial
    ${json_response}=    Convert String To Json    ${response.text}
    ${quantidade_inicial}=    Get Value From Json    ${json_response}    $.quantidade
    Armazenar Quantidade Inicial    ${quantidade_inicial[0]}

Quando eu envio DELETE para /carrinhos/cancelar-compra com Token
    [Tags]    KAN-40
    ${token}=    Obter Token Admin
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    DELETE On Session    serverest    /carrinhos/cancelar-compra    headers=${headers}    expected_status=200    msg=Falha ao cancelar compra
    Armazenar Response    ${response}

# Teardown Keywords
Excluir Produto Criado
    [Tags]    KAN-18
    ${produto_id}=    Obter ID Produto
    Run Keyword If    '${produto_id}' != '${EMPTY}'
    ...    Excluir Produto Por ID    ${produto_id}

Excluir Carrinho e Produtos Criados
    [Tags]    KAN-29
    # Excluir carrinho se existir
    ${carrinho_id}=    Obter ID Carrinho
    Run Keyword If    '${carrinho_id}' != '${EMPTY}'
    ...    Excluir Carrinho Admin
    
    # Excluir produto criado
    ${produto_id}=    Obter ID Produto
    Run Keyword If    '${produto_id}' != '${EMPTY}'
    ...    Excluir Produto Por ID    ${produto_id}

Excluir Produto Por ID
    [Arguments]    ${produto_id}
    ${token}=    Obter Token Admin
    ${headers}=    Create Dictionary    Authorization=${token}
    DELETE On Session    serverest    /produtos/${produto_id}    headers=${headers}    expected_status=any

Excluir Carrinho Ativo
    ${token_usuario}=    Obter Token Usuario
    ${headers_usuario}=    Create Dictionary    Authorization=${token_usuario}
    DELETE On Session    serverest    /carrinhos/cancelar-compra    headers=${headers_usuario}    expected_status=any

Excluir Carrinho Admin
    ${token_admin}=    Obter Token Admin
    ${headers_admin}=    Create Dictionary    Authorization=${token_admin}
    DELETE On Session    serverest    /carrinhos/cancelar-compra    headers=${headers_admin}    expected_status=any

Excluir Usuario Por ID
    [Arguments]    ${user_id}
    ${token}=    Obter Token Admin
    ${headers}=    Create Dictionary    Authorization=${token}
    DELETE On Session    serverest    /usuarios/${user_id}    headers=${headers}    expected_status=any