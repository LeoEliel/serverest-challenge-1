*** Settings ***
Library    FakerLibrary
Library    Collections

*** Variables ***
# Static test data for consistent testing
${ADMIN_EMAIL}         admin@teste.com
${ADMIN_PASSWORD}      admin123
${ADMIN_NAME}          Admin Teste
${USER_EMAIL}          user@teste.com
${USER_PASSWORD}       user123
${USER_NAME}           Usuario Teste

*** Keywords ***
Gerar Dados Usuario
    [Arguments]    ${admin}=false
    ${nome}=    FakerLibrary.Name
    ${email}=   FakerLibrary.Email
    ${password}=    FakerLibrary.Password    length=8
    ${administrador}=    Set Variable If    ${admin}    true    false
    
    ${usuario_data}=    Create Dictionary
    ...    nome=${nome}
    ...    email=${email}
    ...    password=${password}
    ...    administrador=${administrador}
    
    RETURN    ${usuario_data}

Gerar Dados Usuario Admin
    ${admin_data}=    Gerar Dados Usuario    admin=true
    RETURN    ${admin_data}

Gerar Dados Usuario Comum
    ${user_data}=    Gerar Dados Usuario    admin=false
    RETURN    ${user_data}

Gerar Dados Produto
    ${nome}=    FakerLibrary.Word
    ${preco}=   FakerLibrary.Random Int    min=10    max=5000
    ${descricao}=   FakerLibrary.Sentence    nb_words=3
    ${quantidade}=  FakerLibrary.Random Int    min=1    max=1000
    
    ${produto_data}=    Create Dictionary
    ...    nome=${nome}
    ...    preco=${preco}
    ...    descricao=${descricao}
    ...    quantidade=${quantidade}
    
    RETURN    ${produto_data}

Gerar Dados Carrinho
    [Arguments]    ${produto_id}    ${max_quantidade}=10
    ${quantidade}=  FakerLibrary.Random Int    min=1    max=${max_quantidade}
    
    ${produto_carrinho}=    Create Dictionary
    ...    idProduto=${produto_id}
    ...    quantidade=${quantidade}
    
    ${produtos_list}=   Create List    ${produto_carrinho}
    
    ${carrinho_data}=   Create Dictionary
    ...    produtos=${produtos_list}
    
    RETURN    ${carrinho_data}

Gerar Dados Carrinho Multiplos Produtos
    [Arguments]    @{produtos_info}
    ${produtos_list}=   Create List
    
    FOR    ${produto_info}    IN    @{produtos_info}
        ${produto_id}=      Get From Dictionary    ${produto_info}    id
        ${max_qty}=         Get From Dictionary    ${produto_info}    max_quantidade    10
        ${quantidade}=      FakerLibrary.Random Int    min=1    max=${max_qty}
        
        ${produto_carrinho}=    Create Dictionary
        ...    idProduto=${produto_id}
        ...    quantidade=${quantidade}
        
        Append To List    ${produtos_list}    ${produto_carrinho}
    END
    
    ${carrinho_data}=   Create Dictionary
    ...    produtos=${produtos_list}
    
    RETURN    ${carrinho_data}

Gerar Email Unico
    ${timestamp}=   FakerLibrary.Unix Time
    ${email_prefix}=    FakerLibrary.User Name
    ${email}=   Set Variable    ${email_prefix}${timestamp}@teste.com
    RETURN    ${email}

Gerar Nome Produto Unico
    ${timestamp}=   FakerLibrary.Unix Time
    ${produto_nome}=    FakerLibrary.Word
    ${nome_unico}=  Set Variable    ${produto_nome}_${timestamp}
    RETURN    ${nome_unico}

Obter Dados Usuario Admin Estatico
    ${admin_data}=    Create Dictionary
    ...    nome=${ADMIN_NAME}
    ...    email=${ADMIN_EMAIL}
    ...    password=${ADMIN_PASSWORD}
    ...    administrador=true
    
    RETURN    ${admin_data}

Obter Dados Usuario Comum Estatico
    ${user_data}=    Create Dictionary
    ...    nome=${USER_NAME}
    ...    email=${USER_EMAIL}
    ...    password=${USER_PASSWORD}
    ...    administrador=false
    
    RETURN    ${user_data}

Obter Credenciais Login Admin
    ${login_data}=    Create Dictionary
    ...    email=${ADMIN_EMAIL}
    ...    password=${ADMIN_PASSWORD}
    
    RETURN    ${login_data}

Obter Credenciais Login Usuario
    ${login_data}=    Create Dictionary
    ...    email=${USER_EMAIL}
    ...    password=${USER_PASSWORD}
    
    RETURN    ${login_data}