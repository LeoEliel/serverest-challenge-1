*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections
Resource   ../data/variables.robot

*** Keywords ***
# Common Validation Keywords (used across multiple KANs)
Então o status code é
    [Arguments]    ${status_code}
    [Tags]    KAN-1    KAN-4    KAN-6    KAN-15    KAN-18    KAN-29    KAN-37    KAN-40
    ${response}=    Obter Response
    Status Should Be    ${status_code}

E a mensagem é
    [Arguments]    ${expected_message}
    [Tags]    KAN-1    KAN-4    KAN-15    KAN-18    KAN-29    KAN-37    KAN-40
    ${response}=    Obter Response
    ${json_response}=    Convert String To Json    ${response.text}
    ${message}=    Get Value From Json    ${json_response}    $.message
    Should Be Equal    ${message[0]}    ${expected_message}

# KAN-1 & KAN-4 & KAN-29 Validation Keywords
E a resposta contém o campo
    [Arguments]    ${nome_campo}
    [Tags]    KAN-1    KAN-4    KAN-29
    ${response}=    Obter Response
    ${json_response}=    Convert String To Json    ${response.text}
    ${campo}=    Get Value From Json    ${json_response}    $.${nome_campo}
    Should Not Be Empty    ${campo}

# KAN-6 Validation Keywords
E o corpo da resposta contém o _id e dados do usuário
    [Tags]    KAN-6
    ${response}=    Obter Response
    ${json_response}=    Convert String To Json    ${response.text}
    ${id}=    Get Value From Json    ${json_response}    $._id
    ${nome}=    Get Value From Json    ${json_response}    $.nome
    ${email}=    Get Value From Json    ${json_response}    $.email
    Should Not Be Empty    ${id}
    Should Not Be Empty    ${nome}
    Should Not Be Empty    ${email}

# KAN-15 & KAN-18 Validation Keywords
E o Token Admin é válido
    [Tags]    KAN-15    KAN-18
    ${token}=    Obter Token Admin
    Should Not Be Empty    ${token}

# KAN-29 Validation Keywords
E o idProduto existe com quantidade em estoque suficiente
    [Tags]    KAN-29
    ${produto_id}=    Obter ID Produto
    Should Not Be Empty    ${produto_id}

# KAN-37 Validation Keywords
E o usuário possui um carrinho ativo
    [Tags]    KAN-37
    ${carrinho_id}=    Obter ID Carrinho
    Should Not Be Empty    ${carrinho_id}

# KAN-40 Validation Keywords
E o usuário possui um carrinho ativo com produtos
    [Tags]    KAN-40
    ${carrinho_id}=    Obter ID Carrinho
    Should Not Be Empty    ${carrinho_id}
    ${produto_id}=    Obter ID Produto
    ${response}=    GET    /produtos/${produto_id}    expected_status=200    msg=Falha ao buscar produto para verificar carrinho
    ${json_response}=    Convert String To Json    ${response.text}
    ${quantidade_inicial}=    Get Value From Json    ${json_response}    $.quantidade
    Set Test Variable    ${QUANTIDADE_INICIAL}    ${quantidade_inicial[0]}

E a Quantidade Inicial de Estoque X foi salva
    [Tags]    KAN-40
    ${produto_id}=    Obter ID Produto
    ${response}=    GET    /produtos/${produto_id}    expected_status=200    msg=Falha ao buscar produto para salvar quantidade inicial
    ${json_response}=    Convert String To Json    ${response.text}
    ${quantidade_inicial}=    Get Value From Json    ${json_response}    $.quantidade
    Set Test Variable    ${QUANTIDADE_INICIAL}    ${quantidade_inicial[0]}

E o estoque dos produtos é restaurado para X
    [Tags]    KAN-40
    ${produto_id}=    Obter ID Produto
    ${response}=    GET    /produtos/${produto_id}    expected_status=200    msg=Falha ao buscar produto para verificar restauração do estoque
    ${json_response}=    Convert String To Json    ${response.text}
    ${quantidade_atual}=    Get Value From Json    ${json_response}    $.quantidade
    Should Be Equal As Numbers    ${quantidade_atual[0]}    ${QUANTIDADE_INICIAL}