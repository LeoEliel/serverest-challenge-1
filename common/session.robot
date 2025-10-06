*** Settings ***
Library    RequestsLibrary
Library          Collections
Library          String
Library          JSONLibrary

*** Variables ***
${BASE_URL}             http://3.83.23.41:3000

*** Keywords ***
Criar Sessão
    # Cria uma nova sessão HTTP para a URL base da ServeRest.
    Create Session    serveRest    ${BASE_URL}

Fechar Sessões
    # Encerra todas as conexões HTTP abertas após a execução da suite/teste.
    Delete All Sessions
