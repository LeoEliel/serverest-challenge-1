*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource   ../data/data_generation.robot
Resource   ../data/variables.robot
Resource   ../data/setup_helper.robot

*** Variables ***
${RESPONSE}    ${EMPTY}

*** Keywords ***
# Setup Keywords
Dado que existe um Usuário Admin pré-cadastrado
    Configurar Dados Iniciais Para Testes
    ${admin_data}=    Obter Dados Usuario Admin
    POST    /usuarios    json=${admin_data}
    ${admin_id}=    Get From Dictionary    ${RESPONSE.json()}    _id
    Armazenar ID Usuario Admin    ${admin_id}

Dado que eu possuo dados únicos para um novo usuário
    ${user_data}=    Obter Dados Para Novo Usuario    admin
    Set Test Variable    ${USER_DATA}    ${user_data}

Dado que um usuário foi cadastrado com sucesso e seu _id foi salvo
    ${user_id}=    Obter ID Usuario Admin
    Should Not Be Empty    ${user_id}

Dado que o _id de um usuário sem carrinho foi salvo
    ${user_id}=    Obter ID Usuario Admin
    Should Not Be Empty    ${user_id}

Dado que o Token Admin é válido
    ${login_data}=    Obter Dados Para Login    admin
    ${response}=    POST    /login    json=${login_data}
    ${token}=    Get From Dictionary    ${response.json()}    authorization
    Armazenar Token Admin    ${token}
    Set Test Variable    ${AUTH_HEADERS}    {"Authorization": "${token}"}

Dado que o Token do usuário é válido
    ${login_data}=    Obter Dados Para Login    usuario
    ${response}=    POST    /login    json=${login_data}
    ${token}=    Get From Dictionary    ${response.json()}    authorization
    Armazenar Token Usuario    ${token}
    Set Test Variable    ${AUTH_HEADERS}    {"Authorization": "${token}"}

Dado que o idProduto existe com quantidade em estoque suficiente
    ${produto_id}=    Obter ID Produto
    Should Not Be Empty    ${produto_id}

Dado que o usuário possui um carrinho ativo
    ${carrinho_id}=    Obter ID Carrinho
    Should Not Be Empty    ${carrinho_id}

Dado que o usuário possui um carrinho ativo com produtos
    ${carrinho_id}=    Obter ID Carrinho
    Should Not Be Empty    ${carrinho_id}
    ${produto_id}=    Obter ID Produto
    ${response}=    GET    /produtos/${produto_id}
    ${quantidade_inicial}=    Get From Dictionary    ${response.json()}    quantidade
    Set Test Variable    ${QUANTIDADE_INICIAL}    ${quantidade_inicial}

Dado que a Quantidade Inicial de Estoque (X) foi salva
    ${produto_id}=    Obter ID Produto
    ${response}=    GET    /produtos/${produto_id}
    ${quantidade_inicial}=    Get From Dictionary    ${response.json()}    quantidade
    Set Test Variable    ${QUANTIDADE_INICIAL}    ${quantidade_inicial}

# Action Keywords
Quando eu envio POST para a rota /login com credenciais válidas
    ${login_data}=    Obter Dados Para Login    admin
    ${RESPONSE}=    POST    /login    json=${login_data}
    Set Test Variable    ${RESPONSE}

Quando eu envio POST para /usuarios com "administrador": "true"
    ${RESPONSE}=    POST    /usuarios    json=${USER_DATA}
    Set Test Variable    ${RESPONSE}
    ${user_id}=    Get From Dictionary    ${RESPONSE.json()}    _id
    Armazenar ID Usuario Admin    ${user_id}

Quando eu envio GET para a rota /usuarios/{_id} com o _id salvo
    ${user_id}=    Obter ID Usuario Admin
    ${RESPONSE}=    GET    /usuarios/${user_id}
    Set Test Variable    ${RESPONSE}

Quando eu envio DELETE para /usuarios/{_id} com Token
    ${user_id}=    Obter ID Usuario Admin
    ${token}=    Obter Token Admin
    ${headers}=    Create Dictionary    Authorization=${token}
    ${RESPONSE}=    DELETE    /usuarios/${user_id}    headers=${headers}
    Set Test Variable    ${RESPONSE}

Quando eu envio POST para /produtos com Token e dados de produto únicos
    ${produto_data}=    Obter Dados Para Novo Produto
    ${token}=    Obter Token Admin
    ${headers}=    Create Dictionary    Authorization=${token}
    ${RESPONSE}=    POST    /produtos    json=${produto_data}    headers=${headers}
    Set Test Variable    ${RESPONSE}
    ${produto_id}=    Get From Dictionary    ${RESPONSE.json()}    _id
    Armazenar ID Produto    ${produto_id}

Quando eu envio POST para /carrinhos com Token e dados válidos
    ${produto_id}=    Obter ID Produto
    ${carrinho_data}=    Gerar Dados Carrinho    ${produto_id}    5
    ${token}=    Obter Token Usuario
    ${headers}=    Create Dictionary    Authorization=${token}
    ${RESPONSE}=    POST    /carrinhos    json=${carrinho_data}    headers=${headers}
    Set Test Variable    ${RESPONSE}
    ${carrinho_id}=    Get From Dictionary    ${RESPONSE.json()}    _id
    Armazenar ID Carrinho    ${carrinho_id}

Quando eu envio DELETE para /carrinhos/concluir-compra com Token
    ${token}=    Obter Token Usuario
    ${headers}=    Create Dictionary    Authorization=${token}
    ${RESPONSE}=    DELETE    /carrinhos/concluir-compra    headers=${headers}
    Set Test Variable    ${RESPONSE}

Quando eu envio DELETE para /carrinhos/cancelar-compra com Token
    ${token}=    Obter Token Usuario
    ${headers}=    Create Dictionary    Authorization=${token}
    ${RESPONSE}=    DELETE    /carrinhos/cancelar-compra    headers=${headers}
    Set Test Variable    ${RESPONSE}

# Validation Keywords
Então o status code é 200
    Should Be Equal As Numbers    ${RESPONSE.status_code}    200

Então o status code é 201
    Should Be Equal As Numbers    ${RESPONSE.status_code}    201

E a mensagem é "Login realizado com sucesso"
    ${message}=    Get From Dictionary    ${RESPONSE.json()}    message
    Should Be Equal    ${message}    Login realizado com sucesso

E a mensagem é "Cadastro realizado com sucesso"
    ${message}=    Get From Dictionary    ${RESPONSE.json()}    message
    Should Be Equal    ${message}    Cadastro realizado com sucesso

E a mensagem é "Registro excluído com sucesso"
    ${message}=    Get From Dictionary    ${RESPONSE.json()}    message
    Should Be Equal    ${message}    Registro excluído com sucesso

E a resposta contém o campo authorization
    Dictionary Should Contain Key    ${RESPONSE.json()}    authorization

E a resposta contém o campo _id
    Dictionary Should Contain Key    ${RESPONSE.json()}    _id

E o corpo da resposta contém o _id e dados do usuário
    ${response_json}=    Set Variable    ${RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    _id
    Dictionary Should Contain Key    ${response_json}    nome
    Dictionary Should Contain Key    ${response_json}    email

E o estoque dos produtos é restaurado para X
    ${produto_id}=    Obter ID Produto
    ${response}=    GET    /produtos/${produto_id}
    ${quantidade_atual}=    Get From Dictionary    ${response.json()}    quantidade
    Should Be Equal As Numbers    ${quantidade_atual}    ${QUANTIDADE_INICIAL}