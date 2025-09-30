# 📄 Melhorias Aplicadas no Planejamento de Testes ServeRest



Data: 29/09/2025

Baseado no Feedback do Challenge Anterior e Foco em Automação com Robot Framework.

Por Leonardo Eliel da Unitest Squad.

---



## 1. Melhorias na Cobertura e Cenários


* **Validação de Dados:** Adicionada maior cobertura nos cenários de Cadastro (`POST /usuarios` e `POST /produtos`) para garantir a manipulação correta de campos obrigatórios ausentes e dados duplicados (KAN-5, KAN-19).

* **Fluxo de Segurança Refinado:** Incluídos testes explícitos para rotas de Admin (`/produtos`) com Tokens de usuários comuns (KAN-25) e testes sem token (KAN-20), garantindo a aplicação correta do erro 403 Forbidden e 401 Unauthorized.

* **Verificação de Estoque:** No módulo Carrinhos, a cobertura de DELETE foi ampliada para incluir a verificação obrigatória de restauração de estoque (KAN-40) após o cancelamento da compra.


## 2. Ajustes na Priorização (Foco em Automação)

* **Prioridade Alta para Ciclo de Vida:** Os testes de criação e exclusão (Setup e Teardown) de Usuários, Login e Produtos (ex: **KAN-04**, **KAN-01**, **KAN-17**) foram reclassificados como **ALTA**. Eles são a base para qualquer suíte de testes automatizada (Regressão e Fumaça).

* **Reclassificação de Testes de Borda:** Testes de validação de campo individual (ex: **KAN-07**) foram mantidos como **Baixa**, pois serão facilmente cobertos por testes *data-driven* no Robot Framework.


## 3. Inclusão da Estratégia de Automação (Robot Framework)

* **Ferramenta Principal:** A automação será realizada utilizando **Robot Framework** com a biblioteca **RequestsLibrary** para interações HTTP.

* **Estratégia de Teste:** O foco inicial será a criação de uma suíte de **Testes de Regressão Funcional e *Smoke Tests***, priorizando o ciclo de vida dos dados (CRUD).

* **Setup e Teardown:** Cada caso de teste automatizado exigirá a implementação de **palavras-chave (Keywords)** de Setup (Ex: `Criar Usuário Admin`) e Teardown (Ex: `Excluir Usuário`) para garantir que os testes sejam independentes e o ambiente seja limpo após cada execução.