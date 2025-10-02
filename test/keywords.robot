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
    Configurar Dados Iniciais Para Testes
    ${admin_data}=    Obter Dados Usuario Admin
    ${json_response}=    Convert String To Json    ${RESPONSE.text}
    ${admin_id}=    Get Value From Json    ${json_response}    $._id
    Armazenar ID Usuario Admin    ${admin_id[0]}

Quando eu envio POST para a rota /login com credenciais válidas
    [Tags]    KAN-1
    ${login_data}=    Obter Dados Para Login    admin
    ${response}=    POST    /login    json=${login_data}    expected_status=200    msg=Falha ao realizar login com credenciais válidas
    Armazenar Response    ${response}

# KAN-4 Keywords
Dado que eu possuo dados únicos para um novo usuário Administrador
    [Tags]    KAN-4
    ${user_data}=    Obter Dados Para Novo Usuario    admin
    Armazenar Dados Usuario Admin ${user_data}

Quando eu envio POST para /usuarios com "administrador": "true"
    [Tags]    KAN-4
    ${data}=    Obter Dados Usuario Admin
    ${response}=    POST    /usuarios    json=${data}    expected_status=201    msg=Falha ao cadastrar usuário administrador
    ${json_response}=    Convert String To Json    ${response.text}
    ${user_id}=    Get Value From Json    ${json_response}    $._id
    Armazenar Response    ${response}
    Armazenar ID Usuario Admin    ${user_id[0]}

# KAN-6 Keywords
Dado que um usuário foi cadastrado com sucesso e seu _id foi salvo
    [Tags]    KAN-6
    ${user_id}=    Obter ID Usuario Admin
    Should Not Be Empty    ${user_id}

Quando eu envio GET para a rota /usuarios/_id com o _id salvo
    [Tags]    KAN-6
    ${user_id}=    Obter ID Usuario Admin
    ${response}=    GET    /usuarios/${user_id}    expected_status=200    msg=Falha ao buscar usuário pelo ID
    Armazenar Response    ${response}

# KAN-15 Keywords
Dado que o _id de um usuário sem carrinho foi salvo
    [Tags]    KAN-15
    ${user_id}=    Obter ID Usuario Admin
    Should Not Be Empty    ${user_id}

Dado que o Token Admin é válido
    [Tags]    KAN-15    KAN-18
    ${login_data}=    Obter Dados Para Login    admin
    ${response}=    POST    /login    json=${login_data}    expected_status=200    msg=Falha ao obter token admin
    ${json_response}=    Convert String To Json    ${response.text}
    ${token}=    Get Value From Json    ${json_response}    $.authorization
    Armazenar Token Admin    ${token[0]}
    Set Test Variable    ${AUTH_HEADERS}    {"Authorization": "${token[0]}"}

Quando eu envio DELETE para /usuarios/_id com Token
    [Tags]    KAN-15
    ${user_id}=    Obter ID Usuario Admin
    ${token}=    Obter Token Admin
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    DELETE    /usuarios/${user_id}    headers=${headers}    expected_status=200    msg=Falha ao excluir usuário
    Armazenar Response    ${response}

# KAN-18 Keywords
Quando eu envio POST para /produtos com Token e dados de produto únicos
    [Tags]    KAN-18
    ${produto_data}=    Obter Dados Para Novo Produto
    ${token}=    Obter Token Admin
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    POST    /produtos    json=${produto_data}    headers=${headers}    expected_status=201    msg=Falha ao cadastrar produto
    Armazenar Response    ${response}
    ${json_response}=    Convert String To Json    ${response.text}
    ${produto_id}=    Get Value From Json    ${json_response}    $._id
    Armazenar ID Produto    ${produto_id[0]}

# KAN-29 Keywords
Dado que o Token do usuário é válido
    [Tags]    KAN-29    KAN-37    KAN-40
    ${login_data}=    Obter Dados Para Login    usuario
    ${response}=    POST    /login    json=${login_data}    expected_status=200    msg=Falha ao obter token do usuário
    ${json_response}=    Convert String To Json    ${response.text}
    ${token}=    Get Value From Json    ${json_response}    $.authorization
    Armazenar Token Usuario    ${token[0]}
    Set Test Variable    ${AUTH_HEADERS}    {"Authorization": "${token[0]}"}

Dado que o idProduto existe com quantidade em estoque suficiente
    [Tags]    KAN-29
    ${produto_id}=    Obter ID Produto
    Should Not Be Empty    ${produto_id}

Quando eu envio POST para /carrinhos com Token e dados válidos
    [Tags]    KAN-29
    ${produto_id}=    Obter ID Produto
    ${carrinho_data}=    Gerar Dados Carrinho    ${produto_id}    5
    ${token}=    Obter Token Usuario
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    POST    /carrinhos    json=${carrinho_data}    headers=${headers}    expected_status=201    msg=Falha ao criar carrinho
    Armazenar Response    ${response}
    ${json_response}=    Convert String To Json    ${response.text}
    ${carrinho_id}=    Get Value From Json    ${json_response}    $._id
    Armazenar ID Carrinho    ${carrinho_id[0]}

# KAN-37 Keywords
Dado que o usuário possui um carrinho ativo
    [Tags]    KAN-37
    ${carrinho_id}=    Obter ID Carrinho
    Should Not Be Empty    ${carrinho_id}

Quando eu envio DELETE para /carrinhos/concluir-compra com Token
    [Tags]    KAN-37
    ${token}=    Obter Token Usuario
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    DELETE    /carrinhos/concluir-compra    headers=${headers}    expected_status=200    msg=Falha ao concluir compra
    Armazenar Response    ${response}

# KAN-40 Keywords
Dado que o usuário possui um carrinho ativo com produtos
    [Tags]    KAN-40
    ${carrinho_id}=    Obter ID Carrinho
    Should Not Be Empty    ${carrinho_id}
    ${produto_id}=    Obter ID Produto
    ${response}=    GET    /produtos/${produto_id}    expected_status=200    msg=Falha ao buscar produto para verificar estoque
    ${json_response}=    Convert String To Json    ${response.text}
    ${quantidade_inicial}=    Get Value From Json    ${json_response}    $.quantidade
    Set Test Variable    ${QUANTIDADE_INICIAL}    ${quantidade_inicial[0]}

Dado que a Quantidade Inicial de Estoque (X) foi salva
    [Tags]    KAN-40
    ${produto_id}=    Obter ID Produto
    ${response}=    GET    /produtos/${produto_id}    expected_status=200    msg=Falha ao buscar produto para salvar quantidade inicial
    ${json_response}=    Convert String To Json    ${response.text}
    ${quantidade_inicial}=    Get Value From Json    ${json_response}    $.quantidade
    Set Test Variable    ${QUANTIDADE_INICIAL}    ${quantidade_inicial[0]}

Quando eu envio DELETE para /carrinhos/cancelar-compra com Token
    [Tags]    KAN-40
    ${token}=    Obter Token Usuario
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    DELETE    /carrinhos/cancelar-compra    headers=${headers}    expected_status=200    msg=Falha ao cancelar compra
    Armazenar Response    ${response}

