*** Settings ***
Library    JSONLibrary
Resource    data_generation.robot
Resource    variables.robot
Resource    ../common/session.robot

*** Keywords ***
Configurar Dados Iniciais Para Testes
    [Documentation]    Configura dados iniciais necessários para execução dos testes
    
    # Verifica se setup já foi executado
    ${setup_done}=    Verificar Se Setup Foi Concluido
    Return From Keyword If    ${setup_done}
    
    # Gera e armazena dados do usuário admin
    ${admin_data}=    Obter Dados Usuario Admin Estatico
    Armazenar Dados Usuario Admin    ${admin_data}
    
    # Gera e armazena dados do usuário comum
    ${user_data}=    Obter Dados Usuario Comum Estatico
    Armazenar Dados Usuario Comum    ${user_data}
    
    # Gera e armazena dados de produtos
    ${produto_data}=    Gerar Dados Produto
    Armazenar Dados Produto    ${produto_data}
    
    ${produto_data_2}=    Gerar Dados Produto
    Armazenar Dados Produto Secundario    ${produto_data_2}
    
    # Marca setup como concluído
    Marcar Setup Como Concluido
    
    Log    Dados iniciais configurados com sucesso

Obter Dados Para Novo Usuario
    [Arguments]    ${tipo}=user
    ${user_data}=    Run Keyword If    '${tipo}' == 'admin'
    ...    Gerar Dados Usuario Admin
    ...    ELSE
    ...    Gerar Dados Usuario Comum
    RETURN    ${user_data}

Obter Dados Para Novo Produto
    ${produto_data}=    Gerar Dados Produto
    # Garante nome único
    ${nome_unico}=    Gerar Nome Produto Unico
    Set To Dictionary    ${produto_data}    nome    ${nome_unico}
    RETURN    ${produto_data}

Obter Dados Para Login
    [Arguments]    ${tipo}=admin
    ${login_data}=    Run Keyword If    '${tipo}' == 'admin'
    ...    Obter Credenciais Login Admin
    ...    ELSE
    ...    Obter Credenciais Login Usuario
    RETURN    ${login_data}

Setup Completo Da Suite
    [Documentation]    Executa setup completo para a suite de testes
    Criar Sessão
    Configurar Dados Iniciais Para Testes