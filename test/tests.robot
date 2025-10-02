*** Settings ***
Documentation    Suite de Testes de Prioridade Alta para a API ServeRest.
Resource        keywords.robot
Resource        validation.robot
Resource        ../data/setup_helper.robot
Resource        ../common/session.robot
Suite Setup     Setup Completo Da Suite
Suite Teardown  Delete All Sessions

*** Test Cases ***

KAN-1 - Login com Credenciais Válidas (Admin)
    [Tags]    Login    Alta    KAN-1
    Dado que existe um Usuário Admin pré-cadastrado
    Quando eu envio POST para a rota /login com credenciais válidas
    Então o status code é  200
    E a mensagem é  "Login realizado com sucesso"
    E a resposta contém o campo  authorization

KAN-4 - Cadastrar Novo Usuário (Administrador = true)
    [Tags]    Usuarios    Alta    CRUD    KAN-4
    Dado que eu possuo dados únicos para um novo usuário Administrador
    Quando eu envio POST para /usuarios com "administrador": "true"
    Então o status code é    201
    E a mensagem é  "Cadastro realizado com sucesso"
    E a resposta contém o campo  _id

KAN-6 - Buscar Usuário por _id recém-criado
    [Tags]    Usuarios    Alta    CRUD    KAN-6
    Dado que um usuário foi cadastrado com sucesso e seu _id foi salvo
    Quando eu envio GET para a rota /usuarios/_id com o _id salvo
    Então o status code é   200
    E o corpo da resposta contém o _id e dados do usuário

KAN-15 - Excluir Usuário recém-criado (sem carrinho)
    [Tags]    Usuarios    Alta    CRUD    Teardown    KAN-15
    Dado que o _id de um usuário sem carrinho foi salvo
    E o Token Admin é válido
    Quando eu envio DELETE para /usuarios/_id com Token
    Então o status code é   200
    E a mensagem é  "Registro excluído com sucesso"

KAN-18 - Cadastrar Novo Produto com sucesso (Token Admin Requerido)
    [Tags]    Produtos    Alta    CRUD    KAN-18
    Dado que o Token Admin é válido
    Quando eu envio POST para /produtos com Token e dados de produto únicos
    Então o status code é  201
    E a mensagem é  "Cadastro realizado com sucesso"

KAN-29 - Criar um Carrinho de Compras com Sucesso
    [Tags]    Carrinhos    Alta    Fluxo    KAN-29
    Dado que o Token do usuário é válido
    E o idProduto existe com quantidade em estoque suficiente
    Quando eu envio POST para /carrinhos com Token e dados válidos
    Então o status code é  201
    E a mensagem é  "Cadastro realizado com sucesso"
    E a resposta contém o campo   _id

KAN-37 - Concluir uma Compra (Excluir Carrinho)
    [Tags]    Carrinhos    Alta    Fluxo    KAN-37
    Dado que o Token do usuário é válido
    E o usuário possui um carrinho ativo
    Quando eu envio DELETE para /carrinhos/concluir-compra com Token
    Então o status code é  200
    E a mensagem é  "Registro excluído com sucesso"

KAN-40 - Cancelar uma Compra e Verificar Restauração de Estoque
    [Tags]    Carrinhos    Alta    RegraNegocio    KAN-40
    Dado que o Token do usuário é válido
    E o usuário possui um carrinho ativo com produtos
    E a Quantidade Inicial de Estoque X foi salva
    Quando eu envio DELETE para /carrinhos/cancelar-compra com Token
    Então o status code é  200
    E a mensagem é  "Registro excluído com sucesso"
    E o estoque dos produtos é restaurado para X