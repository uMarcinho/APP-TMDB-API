# Flutter TMDB App

Aplicativo desenvolvido em Flutter que consome a API do TMDB (The Movie Database) para exibir 
filmes populares e permitir a busca por nome. O projeto segue boas práticas de organização, 
componentes reutilizáveis e tratamento básico de erros.

Observação: projeto desenvolvido com a IDE Android Studio.

---

## Como Executar o Projeto

### 1. Clonar o repositório

### 2. Instalar as dependências
```bash
flutter pub get
```

### 3. Configurar a chave da API
- No projeto, localize o arquivo:
  ```
  lib/config/api_config.dart
  ```
  e substitua o valor da constante pela sua chave API

### 4. Executar o app
```bash
flutter run
```

---

##  Executando os Testes

O projeto inclui testes unitários básicos.  
Para rodá-los:
```bash
flutter test
```

---

## Considerações sobre CI/CD

O projeto foi estruturado com foco nos requisitos solicitados mas tambem pode ser facilmente 
integrado a pipelines de CI/CD no futuro.  

Exemplos de possíveis integrações:

- Execução automática dos testes via GitHub Actions;
- Análise de qualidade de código;
- Build automatizado do app.
