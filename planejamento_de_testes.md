# Plano de Testes: API REST ServeRest

**Data de Elaboração:** 05 de Setembro de 2025

## 1. Apresentação

Este documento detalha o plano de testes para a API REST da aplicação ServeRest, acessível através do endpoint base `https://compassuol.serverest.dev/`. O foco deste planejamento é garantir a qualidade, a conformidade com as regras de negócio e a estabilidade de todos os endpoints da API, incluindo Usuários, Login, Produtos e Carrinhos, utilizando como base a documentação Swagger, as User Stories e o mapa mental da aplicação.

Este plano servirá como guia para a execução dos testes, o mapeamento de issues e a criação de uma **collection Postman** para validação contínua.

## 2. Objetivo

O objetivo principal é validar de forma sistemática todos os endpoints da API ServeRest para garantir que eles operem conforme o esperado.

### Objetivos Específicos:

* Validar o **CRUD completo** do endpoint `/usuarios`.

* Verificar o processo de **autenticação** no endpoint `/login`.

* Validar o **CRUD completo** do endpoint `/produtos`, incluindo a necessidade de autenticação.

* Validar o **fluxo completo** do endpoint `/carrinhos`, desde a criação até a conclusão ou cancelamento da compra.

* Garantir que todas as **regras de negócio** e critérios de aceitação sejam atendidos.

* Identificar, documentar e reportar quaisquer divergências (**issues**) entre o comportamento esperado e o real.

* Produzir uma collection Postman com scripts de validação para **automação** dos testes.

## 3. Escopo

### Endpoints e Funcionalidades em Escopo:

* **Usuários (`/usuarios`):** CRUD completo (POST, GET, PUT, DELETE).

* **Login (`/login`):** Autenticação (POST).

* **Produtos (`/produtos`):** CRUD completo (POST, GET, PUT, DELETE).

* **Carrinhos (`/carrinhos`):**

  * `GET /carrinhos` e `GET /carrinhos/{_id}`: Listagem e busca de carrinhos.

  * `POST /carrinhos`: Criação de um novo carrinho (requer autenticação).

  * `DELETE /carrinhos/concluir-compra`: Finalização de uma compra (requer autenticação).

  * `DELETE /carrinhos/cancelar-compra`: Cancelamento de uma compra e retorno dos produtos ao estoque (requer autenticação).

### Fora de Escopo:

* A aplicação front-end (`https://front.serverest.dev/login`).

* Testes de performance, carga ou estresse.

* Testes de infraestrutura ou segurança aprofundados.

## 4. Análise

A análise será baseada na comparação direta entre os resultados obtidos nas chamadas da API e o comportamento esperado, definido pelas User Stories e pelo Swagger. Serão avaliados:

* **Status Codes HTTP:** Conformidade com os padrões REST.

* **Corpo da Resposta (Response Body):** Validação da estrutura do JSON e dos dados.

* **Headers da Resposta:** Verificação de headers importantes como `Authorization`.

* **Regras de Negócio:** Validação de lógicas específicas (unicidade de e-mail, controle de estoque, etc.).

## 5. Técnicas Aplicadas

* **Teste Baseado em Especificação:** Uso das User Stories e Swagger.

* **Análise de Valor Limite:** Para campos com restrições (ex: tamanho da senha).

* **Particionamento de Equivalência:** Para campos com regras (ex: formato e domínio do e-mail).

* **Teste de Transição de Estado:** Para validar fluxos sequenciais (Login -> Criar Carrinho -> Concluir Compra).

* **Teste de Robustez (Fuzzing):** Envio de dados malformados, inesperados ou de tipos incorretos para validar o tratamento de erros.

## 6. Ambiente e Recursos de Teste (API)

### Local dos Testes

* Local de trabalho pessoal.

* Ambiente utilizado na plataforma Air Learning, podendo ser realizado remotamente.

### Ambiente de Testes (Hardware e Software)

* **Sistema Operacional:** Windows 11 Home Single Language (Versão 24H2)

* **Hardware:** PC (Intel i5, 12GB RAM, 64 bits)

* **Software:**

  * Ferramenta de Teste de API: **Postman**

  * Navegador (para consulta): Google Chrome

### Recursos Necessários

* **Humanos:** Testadores.

* **Equipamentos:** Computadores com acesso à internet.

* **Recursos Financeiros:** Não consta.

## 7. Mapa Mental da Aplicação (Estrutura da API)

```bash
API ServeRest
├─── Endpoint: /login
│    └─── POST
│         ├─── Sucesso -> 200 OK
│         └─── Falha   -> 401 Unauthorized
│
├─── Endpoint: /usuarios
│    ├─── POST (Criar)
│    │    ├─── Sucesso -> 201 Created
│    │    └─── Falha   -> 400 Bad Request (E-mail duplicado, dados inválidos)
│    ├─── GET (Listar / Buscar por ID)
│    │    └─── Sucesso -> 200 OK
│    ├─── PUT /{_id} (Atualizar/Criar)
│    │    ├─── Atualizado -> 200 OK
│    │    └─── Criado     -> 201 Created
│    └─── DELETE /{_id} (Excluir)
│         ├─── Sucesso -> 200 OK
│         └─── Falha   -> 400 Bad Request (Usuário com carrinho)
│
├─── Endpoint: /produtos
│    ├─── POST (Criar)
│    │    ├─── Sucesso      -> 201 Created
│    │    ├─── Falha (Nome) -> 400 Bad Request
│    │    ├─── Falha (Auth) -> 401 Unauthorized
│    │    └─── Falha (Perm) -> 403 Forbidden
│    ├─── GET (Listar / Buscar por ID)
│    │    └─── Sucesso -> 200 OK
│    ├─── PUT /{_id} (Atualizar/Criar)
│    │    ├─── Atualizado   -> 200 OK
│    │    └─── Criado       -> 201 Created
│    └─── DELETE /{_id} (Excluir)
│         ├─── Sucesso -> 200 OK
│         └─── Falha   -> 400 Bad Request (Produto em carrinho)
│
└─── Endpoint: /carrinhos
├─── POST (Criar)
│    ├─── Sucesso -> 201 Created
│    ├─── Falha   -> 400 Bad Request (Produto s/ estoque, etc.)
│    └─── Falha   -> 401 Unauthorized
├─── GET (Listar / Buscar por ID)
│    └─── Sucesso -> 200 OK
├─── DELETE /concluir-compra
│    ├─── Sucesso -> 200 OK
│    └─── Falha   -> 401 Unauthorized
└─── DELETE /cancelar-compra
├─── Sucesso -> 200 OK
└─── Falha   -> 401 Unauthorized
```

## 8. Cenários de Teste Detalhados (BDD/Gherkin)

Esta seção contém cenários para todos os métodos da API, organizados por Endpoint e Método HTTP, com referência aos IDs atômicos (`KAN-ID`).

### Login (`/login`)

**Feature: Autenticação de Usuário**

#### POST

**KAN-1:** Login com Credenciais Válidas (Admin)

```gherkin
Dado que existe um usuário cadastrado com e-mail e senha válidos
Quando eu envio uma requisição POST para a rota /login com essas credenciais
Então a resposta deve ter o status code 200
E o corpo da resposta deve conter um campo authorization
```

**KAN-2**: Tentar login com e-mail inválido (não cadastrado)

```gherkin
Dado que um usuário tenta se autenticar com e-mail não cadastrado
Quando eu envio uma requisição POST para a rota /login
Então a resposta deve ter o status code 401
E a resposta deve conter a mensagem "Email e/ou senha inválidos"
```

**KAN-3:** Tentar login com senha inválida (E-mail correto)

```gherkin
Dado que um usuário tenta se autenticar com e-mail correto e senha incorreta
Quando eu envio uma requisição POST para a rota /login
Então a resposta deve ter o status code 401
E a resposta deve conter a mensagem "Email e/ou senha inválidos"
```

KAN-7: Tentar login com campo obrigatório ausente ou vazio

```gherkin
Dado que eu vou tentar realizar login
Quando eu envio uma requisição POST para a rota /login omitindo o campo 'email' (ou 'password')
Então a resposta deve ter o status code 400
E o corpo da resposta deve indicar o campo obrigatório ausente ou inválido
```

Cenário: Validar expiração do token de autenticação

```gherkin
Dado que eu realizei o login e obtive um token de autenticação
Quando eu aguardo o tempo de expiração do token (600 segundos)
E tento acessar uma rota protegida, como POST /produtos
Então a resposta deve ter o status code 401
E a resposta deve conter uma mensagem sobre token expirado
```

Usuários (/usuarios)
Feature: Gerenciamento de Usuários

POST
KAN-4: Cadastrar Novo Usuário (Administrador = true)
```gherkin
Dado que eu possuo os dados de um novo usuário
E o campo 'administrador' é 'true'
Quando eu envio uma requisição POST para a rota /usuarios com esses dados
Então a resposta deve ter o status code 201
E a resposta deve conter a mensagem "Cadastro realizado com sucesso"
```

KAN-8: Cadastrar Novo Usuário (Administrador = false)

```gherkin
Dado que eu possuo os dados de um novo usuário
E o campo 'administrador' é 'false'
Quando eu envio uma requisição POST para a rota /usuarios com esses dados
Então a resposta deve ter o status code 201
E a resposta deve conter a mensagem "Cadastro realizado com sucesso"
```

KAN-5: Tentar criar um usuário com um e-mail duplicado

```gherkin
Dado que já existe um usuário cadastrado com o e-mail "email.duplicado@exemplo.com"
Quando eu envio uma requisição POST para a rota /usuarios com o mesmo e-mail
Então a resposta deve ter o status code 400
E a resposta deve conter a mensagem "Este email já está sendo usado"
```

Sub-Feature: Testes de Robustez e Dados Inválidos (POST /usuarios)
KAN-6: Tentar criar um usuário sem um campo obrigatório

```gherkin
Dado que eu vou criar um novo usuário
Quando eu envio uma requisição POST para a rota /usuarios sem o campo "email"
Então a resposta deve ter o status code 400
E o corpo da resposta deve indicar que o campo "email" é obrigatório
```

Cenário: Testar a criação de usuário com tipos de dados incorretos no payload

```gherkin
Dado que eu vou criar um novo usuário
Quando eu envio uma requisição POST para a rota /usuarios com o campo "nome" sendo o número 123 em vez de uma string
Então a resposta deve ter o status code 400
E o corpo da resposta deve indicar que o campo "nome" deve ser do tipo string
```

Cenário de Esquema: Testar a criação de usuário com dados de string malformados ou inesperados
```gherkin
Dado que eu vou criar um novo usuário
Quando eu envio uma requisição POST para a rota /usuarios com o campo "<campo>" preenchido com "<valor_invalido>"
Então a resposta deve ter o status code 400
E o corpo da resposta deve indicar que o campo "<campo>" é inválido
```
| Campo | valor_invalido | Descrição |
|---|---|---|
| **nome** | (uma string com mais de 255 caracteres) | String Longa |
| **nome** | "" | String Vazia (em branco) |
| **nome** | "´select * from customer" | Injeção de SQL |
| **password** | "1234" | Senha muito curta |
| **password** | "12345678901" | Senha muito longa |
| **email** | "email-invalido" | E-mail sem @ |
| **email** | "usuario@gmail.com" | E-mail com domínio proibido |

GET
KAN-9/KAN-11: Listar todos os usuários cadastrados

```gherkin
Dado que existem múltiplos usuários cadastrados no sistema
Quando eu envio uma requisição GET para a rota /usuarios
Então a resposta deve ter o status code 200
E o corpo da resposta deve ser uma lista contendo todos os usuários
```

KAN-10: Buscar um usuário por um ID existente

```gherkin
Dado que existe um usuário cadastrado com um ID conhecido
Quando eu envio uma requisição GET para a rota /usuarios/{id} com o ID conhecido
Então a resposta deve ter o status code 200
E o corpo da resposta deve conter os dados do usuário específico
```

KAN-12: Tentar buscar um usuário por um ID inexistente

```gherkin
Dado que um ID de usuário não existe no sistema
Quando eu envio uma requisição GET para a rota /usuarios/{id} com o ID inexistente
Então a resposta deve ter o status code 400
E a resposta deve conter a mensagem "Usuário não encontrado"
```

PUT
KAN-13: Atualizar um usuário existente com sucesso

```gherkin
Dado que existe um usuário cadastrado com um ID conhecido
Quando eu envio uma requisição PUT para a rota /usuarios/{id} com novos dados válidos
Então a resposta deve ter o status code 200
E a resposta deve conter a mensagem "Registro alterado com sucesso"
```

KAN-16: Criar um novo usuário ao tentar atualizar um ID inexistente

```gherkin
Dado que um ID de usuário não existe no sistema
Quando eu envio uma requisição PUT para a rota /usuarios/{id} com dados de um novo usuário
Então a resposta deve ter o status code 201
E a resposta deve conter a mensagem "Cadastro realizado com sucesso"
```

Cenário: Tentar atualizar um usuário com um e-mail já existente em outro registro
```gherkin
Dado que existe o usuário A com o e-mail "emailA@teste.com"
E existe o usuário B com o e-mail "emailB@teste.com"
Quando eu envio uma requisição PUT para a rota /usuarios/{id_usuario_A} com os dados do usuário A, alterando o e-mail para "emailB@teste.com"
Então a resposta deve ter o status code 400
E a resposta deve conter a mensagem "Este email já está sendo usado"
```

DELETE
KAN-14: Excluir um usuário existente com sucesso
```gherkin
Dado que existe um usuário cadastrado sem carrinho
Quando eu envio uma requisição DELETE para a rota /usuarios/{id} deste usuário
Então a resposta deve ter o status code 200
E a resposta deve conter a mensagem "Registro excluído com sucesso"
```

KAN-15: Tentar excluir um usuário que possui um carrinho
```gherkin
Dado que um usuário com carrinho ativo existe
Quando eu envio uma requisição DELETE para a rota /usuarios/{id} desse usuário
Então a resposta deve ter o status code 400
E a resposta deve conter a mensagem "Não é permitido excluir usuário com carrinho cadastrado"
```
Produtos (/produtos)
Feature: Gerenciamento de Produtos

POST
KAN-17: Cadastrar um produto com sucesso
```gherkin
Dado que eu estou autenticado como um administrador
Quando eu envio uma requisição POST para a rota /produtos com dados de um novo produto
Então a resposta deve ter o status code 201
E a resposta deve conter a mensagem "Cadastro realizado com sucesso"
```
KAN-18: Tentar cadastrar um produto sem autenticação
```gherkin
Dado que eu não estou autenticado
Quando eu envio uma requisição POST para a rota /produtos
Então a resposta deve ter o status code 401
E a resposta deve conter uma mensagem sobre token ausente ou inválido
```
KAN-20: Tentar cadastrar um produto com um nome já existente
```gherkin
Dado que eu estou autenticado como um administrador
E já existe um produto com o nome "Produto Duplicado"
Quando eu envio uma requisição POST para a rota /produtos com o nome "Produto Duplicado"
Então a resposta deve ter o status code 400
E a resposta deve conter a mensagem "Já existe produto com esse nome"
```
KAN-19: Tentar cadastrar um produto com um usuário não-administrador
```gherkin
Dado que eu estou autenticado como um usuário comum (não administrador)
Quando eu envio uma requisição POST para a rota /produtos
Então a resposta deve ter o status code 403
E a resposta deve conter a mensagem "Rota exclusiva para administradores"
```
GET
KAN-21/KAN-23: Listar todos os produtos cadastrados
```gherkin
Dado que existem múltiplos produtos cadastrados no sistema
Quando eu envio uma requisição GET para a rota /produtos
Então a resposta deve ter o status code 200
E o corpo da resposta deve ser uma lista contendo todos os produtos
```
KAN-22: Buscar um produto por um ID existente
```gherkin
Dado que existe um produto cadastrado com um ID conhecido
Quando eu envio uma requisição GET para a rota /produtos/{id} com o ID conhecido
Então a resposta deve ter o status code 200
E o corpo da resposta deve conter os dados do produto específico
```
PUT
KAN-24: Atualizar um produto existente com sucesso
```gherkin
Dado que eu estou autenticado como administrador
E existe um produto cadastrado com um ID conhecido
Quando eu envio uma requisição PUT para a rota /produtos/{id} com novos dados válidos
Então a resposta deve ter o status code 200
E a resposta deve conter a mensagem "Registro alterado com sucesso"
```
KAN-26: Tentar atualizar um produto sem autenticação
```gherkin
Dado que existe um produto cadastrado com um ID conhecido
Quando eu envio uma requisição PUT para a rota /produtos/{id} sem um token de autenticação
Então a resposta deve ter o status code 401
E a resposta deve conter a mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"
```
KAN-25: Tentar atualizar um produto com um nome já existente em outro registro
```gherkin
Dado que eu estou autenticado como administrador
E existe o produto X com o nome "ProdutoX"
E existe o produto Y com o nome "ProdutoY"
Quando eu envio uma requisição PUT para a rota /produtos/{id_produto_X} com os dados do produto X, alterando o nome para "ProdutoY"
Então a resposta deve ter o status code 400
E a resposta deve conter a mensagem "Já existe produto com esse nome"
```
DELETE
KAN-27: Excluir um produto com sucesso
```gherkin
Dado que eu estou autenticado como administrador
E existe um produto que não está em nenhum carrinho
Quando eu envio uma requisição DELETE para a rota /produtos/{id} deste produto
Então a resposta deve ter o status code 200
E a resposta deve conter a mensagem "Registro excluído com sucesso"
```
KAN-28: Tentar excluir um produto que está em um carrinho
```gherkin
Dado que eu estou autenticado como administrador
E existe um produto que está associado a um carrinho
Quando eu envio uma requisição DELETE para a rota /produtos/{id} deste produto
Então a resposta deve ter o status code 400
E a resposta deve conter a mensagem "Não é permitido excluir produto que faz parte de carrinho"
```
Carrinhos (/carrinhos)
Feature: Gerenciamento de Carrinhos

POST
KAN-29: Criar um carrinho de compras com sucesso
```gherkin
Dado que eu estou autenticado como um usuário comum
E existe um produto com quantidade em estoque suficiente
Quando eu envio uma requisição POST para a rota /carrinhos com o ID do produto
Então a resposta deve ter o status code 201
E a resposta deve conter a mensagem "Cadastro realizado com sucesso"
```
KAN-32: Tentar criar um carrinho com produto inexistente
```gherkin
Dado que eu estou autenticado como um usuário comum
Quando eu envio uma requisição POST para a rota /carrinhos com um ID de produto que não existe
Então a resposta deve ter o status code 400
E a resposta deve conter a mensagem "Produto não encontrado"
```
KAN-31: Tentar criar um carrinho com produto sem estoque
```gherkin
Dado que eu estou autenticado como um usuário comum
E existe um produto cuja quantidade em estoque é 0
Quando eu envio uma requisição POST para a rota /carrinhos com o ID desse produto
Então a resposta deve ter o status code 400
E a resposta deve conter a mensagem "Produto não possui quantidade suficiente"
```
KAN-30: Tentar criar um segundo carrinho antes de concluir o primeiro (Regra de Negócio)
```gherkin
Dado que eu estou autenticado como um usuário e já possuo um carrinho ativo
Quando eu envio uma segunda requisição POST para a rota /carrinhos
Então a resposta deve ter o status code 400
E a resposta deve conter a mensagem "Não é permitido ter mais de um carrinho"
```
GET
KAN-36: Listar todos os carrinhos cadastrados
```gherkin
Dado que existem múltiplos carrinhos cadastrados no sistema
Quando eu envio uma requisição GET para a rota /carrinhos
Então a resposta deve ter o status code 200
E o corpo da resposta deve ser uma lista contendo todos os carrinhos
```
KAN-34: Buscar um carrinho por um ID existente
```gherkin
Dado que existe um carrinho cadastrado com um ID conhecido
Quando eu envio uma requisição GET para a rota /carrinhos/{id} com o ID conhecido
Então a resposta deve ter o status code 200
E o corpo da resposta deve conter os dados do carrinho específico
```
KAN-35: Buscar Carrinho por _id inexistente
```gherkin
Dado que um ID de carrinho não existe no sistema
Quando eu envio uma requisição GET para a rota /carrinhos/{id} com o ID inexistente
Então a resposta deve ter o status code 400
E a resposta deve conter a mensagem "Carrinho não encontrado"
```
DELETE
KAN-37: Concluir uma compra com sucesso
```gherkin
Dado que eu estou autenticado como um usuário e possuo um carrinho ativo
Quando eu envio uma requisição DELETE para a rota /carrinhos/concluir-compra
Então a resposta deve ter o status code 200
E a resposta deve conter a mensagem "Registro excluído com sucesso"
```
KAN-39: Tentar Concluir Compra sem Token de Autenticação
```gherkin
Dado que eu possuo um carrinho ativo
Quando eu envio uma requisição DELETE para a rota /carrinhos/concluir-compra sem um token de autenticação
Então a resposta deve ter o status code 401
E a resposta deve conter uma mensagem sobre token ausente ou inválido
```
KAN-40: Cancelar uma compra e verificar o retorno do estoque
```gherkin
Dado que eu estou autenticado como um usuário e possuo um carrinho com um produto
E a quantidade inicial em estoque do produto é X
Quando eu envio uma requisição DELETE para a rota /carrinhos/cancelar-compra
Então a resposta deve ter o status code 200
E a quantidade em estoque do produto deve ser restaurada para X
```
KAN-41: Tentar Cancelar Compra sem Token de Autenticação
```gherkin
Dado que eu possuo um carrinho ativo
Quando eu envio uma requisição DELETE para a rota /carrinhos/cancelar-compra sem um token de autenticação
Então a resposta deve ter o status code 401
E a resposta deve conter uma mensagem sobre token ausente ou inválido
```
## 9. Priorização da Execução dos Cenários de Teste

| Prioridade | Critérios de Seleção | Exemplos de CTs Priorizados |
| :--- | :--- | :--- |
| **ALTA** | Testes de **Ciclo de Vida** (CRUD básico) e **Caminho Feliz** que servem como SETUP e TEARDOWN para outros testes. | KAN-1, KAN-4/KAN-8, KAN-14, KAN-29, KAN-37, KAN-40 (Fluxo principal). |
| **MÉDIA** | Testes de **Segurança/Autorização** (401/403) e validação de falha de regras de negócio. | KAN-2/KAN-3, KAN-19, KAN-30, KAN-31, KAN-32. |
| **BAIXA** | Testes de Validação de campos específicos e formatos (testes de borda detalhados). | KAN-7, KAN-26, KAN-35. |

## 10. Matriz de Risco

| Risco Identificado | Impacto | Probabilidade | Plano de Contingência |
| ----- | ----- | ----- | ----- |
| Ambiente de testes instável ou fora do ar | Alto | Baixa | Comunicação constante com a equipe de infra/DevOps. Agendar testes em janelas de maior estabilidade. |
| Dados de teste inconsistentes | Médio | Médio | Criar scripts para limpar e popular o banco de dados antes de cada ciclo de teste, garantindo um estado conhecido. |
| Documentação Swagger desatualizada | Médio | Médio | Priorizar as User Stories e o comportamento real como fonte da verdade. Reportar as inconsistências como issues. |

## 11. Cobertura de Testes

A cobertura de testes para a API ServeRest será medida através de múltiplas métricas para garantir não apenas que os requisitos funcionais sejam atendidos, mas também que a API seja robusta, segura e resiliente a entradas inesperadas. O objetivo é adotar uma abordagem estratégica que cubra a API sob diferentes perspectivas.

### 11.1 Cobertura por Requisitos (Regras de Negócio)

Esta é a métrica de maior prioridade. O objetivo é garantir **100% de cobertura** de todos os Critérios de Aceitação definidos nas User Stories (US001 a US004). Cada regra de negócio, como "Não é permitido excluir usuário com carrinho" ou "Rota exclusiva para administradores", será mapeada e validada por um ou mais cenários de teste. Os cenários BDD detalhados no Capítulo 8 são a implementação direta desta estratégia.

### 11.2 Cobertura por Endpoints e Métodos HTTP

Esta métrica garante que todas as rotas e verbos HTTP disponíveis na API sejam exercitados, conforme documentado no Swagger.

| Rota | Método | Coberto |
| ----- | ----- | ----- |
| `/login` | POST | Sim |
| `/usuarios` | GET, POST | Sim |
| `/usuarios/{_id}` | GET, PUT, DELETE | Sim |
| `/produtos` | GET, POST | Sim |
| `/produtos/{_id}` | GET, PUT, DELETE | Sim |
| `/carrinhos` | GET, POST | Sim |
| `/carrinhos/{_id}` | GET | Sim |
| `/carrinhos/concluir-compra` | DELETE | Sim |
| `/carrinhos/cancelar-compra` | DELETE | Sim |

### 11.3 Cobertura por Códigos de Status (Status Code)

O objetivo é validar que a API retorne os códigos de status HTTP corretos para cada situação, incluindo sucesso e, crucialmente, os diversos cenários de erro.

| Código HTTP | Descrição | Endpoints de Exemplo | Coberto |
| ----- | ----- | ----- | ----- |
| **200 OK** | Sucesso em operações de busca ou alteração. | `GET /usuarios`, `PUT /produtos/{_id}` | Sim |
| **201 Created** | Sucesso na criação de um novo recurso. | `POST /usuarios`, `POST /produtos` | Sim |
| **400 Bad Request** | Erro do cliente (dados inválidos, regras de negócio violadas). | `POST /usuarios` (e-mail duplicado), `POST /carrinhos` (sem estoque) | Sim |
| **401 Unauthorized** | Erro de autenticação (token ausente, inválido ou expirado). | `POST /produtos` (sem token) | Sim |
| **403 Forbidden** | Erro de autorização (usuário não tem permissão). | `POST /produtos` (com usuário não-admin) | Sim |

### 11.4 Cobertura por Corpo da Requisição (Payload)

Esta métrica foca na validação dos dados de entrada enviados no corpo das requisições POST e PUT. Utilizando as técnicas de Análise de Valor Limite e Particionamento de Equivalência, serão testadas diversas variações do payload para garantir a resiliência da API.

**Exemplos de Cobertura:**

* **Campo `password` em `/usuarios`:** Serão testados valores com menos de 5 caracteres, exatamente 5, entre 5 e 10, exatamente 10 e mais de 10 caracteres.

* **Campo `email` em `/usuarios`:** Serão testados e-mails com formato válido, inválido (sem `@`, sem `.com`), e com domínios proibidos (`gmail.com`, `hotmail.com`).

* **Payload de `/produtos`:** Serão enviadas requisições com o corpo completo, com campos obrigatórios ausentes e com campos contendo tipos de dados incorretos (ex: `preco` como string).

## 12. Testes Candidatos a Automação e Estratégia (Robot Framework)

A prioridade para implementação da automação será focada no **Robot Framework** e na estruturação de uma **Collection Postman** como artefato auxiliar, seguindo a ordem de criticidade abaixo:

1. **Smoke Test Suite (Prioridade Alta):** Cenários de "caminho feliz" para todas as rotas, incluindo criar usuário, fazer login, criar produto e criar e finalizar um carrinho.

2. **Regression Suite (Prioridade Média/Alta):** Todos os cenários negativos de validação de regras de negócio.

3. **Full Suite (Prioridade Média/Baixa):** Todos os cenários mapeados, incluindo os de robustez e exceção.

### Estratégia de Automação com Robot Framework

* **Ferramenta Principal:** A automação será realizada utilizando **Robot Framework** com a biblioteca **RequestsLibrary** (para requisições HTTP) e **JSONLibrary** (para validação de estruturas de resposta).

* **Estratégia de Teste:** O foco inicial será a criação de uma suíte de **Testes de Regressão Funcional e *Smoke Tests***, priorizando o ciclo de vida dos dados (CRUD).

* **Gestão de Dados:** A automação será projetada para consumir dados únicos (utilizando geradores de dados se necessário) e garantir que as variáveis de contexto (`authToken`, `newUserId`) sejam passadas entre os testes (encadeamento).

* **Setup e Teardown:** A suíte de testes terá rotinas de **Setup** e **Teardown** (limpeza de dados, exclusão de usuários e carrinhos) para garantir que cada teste comece e termine em um estado limpo, prevenindo falhas ambientais.

Esta automação no **Robot Framework** será o núcleo do desafio, e a Collection Postman será o artefato complementar a ser entregue.