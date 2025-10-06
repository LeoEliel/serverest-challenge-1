# ServeRest Challenge - Automação de Testes

Projeto de automação de testes para a API ServeRest usando Robot Framework.

## Pré-requisitos

- Python 3.7+
- pip (gerenciador de pacotes Python)

## Instalação

1. Clone o repositório:
```bash
git clone <url-do-repositorio>
cd serverest-challenge-1
```

2. Instale as dependências:
```bash
pip install -r requirements.txt
```

## Estrutura do Projeto

```
serverest-challenge-1/
├── common/          # Configurações de sessão HTTP
├── data/           # Dados de teste e helpers
├── test/           # Testes e keywords
├── reports/        # Relatórios e documentação
├── json/           # Collections Postman
└── log/            # Logs de execução
```

## Como Executar os Testes

### Executar todos os testes:
```bash
robot test/tests.robot
```

### Executar testes por tag:
```bash
robot -i Alta test/tests.robot          # Apenas testes de prioridade Alta
robot -i Usuarios test/tests.robot      # Apenas testes de Usuários
robot -i CRUD test/tests.robot          # Apenas testes CRUD
```

### Executar com relatórios customizados:
```bash
robot -d reports test/tests.robot
```

### Executar teste específico:
```bash
robot -t "KAN-1 - Login com Credenciais Válidas" test/tests.robot
```

## Relatórios

Após a execução, os seguintes arquivos são gerados:
- `report.html` - Relatório visual dos testes
- `log.html` - Log detalhado da execução
- `output.xml` - Dados estruturados dos resultados

## Tags Disponíveis

- `Alta` - Testes de prioridade alta
- `Usuarios` - Testes relacionados a usuários
- `Produtos` - Testes relacionados a produtos
- `Carrinhos` - Testes relacionados a carrinhos
- `Login` - Testes de autenticação
- `CRUD` - Operações básicas (Create, Read, Update, Delete)
- `Fluxo` - Testes de fluxo completo
- `RegraNegocio` - Testes de regras de negócio

## API Base

Os testes são executados contra: `http://3.83.23.41:3000`