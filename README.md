# Prometheus-Grafana Stack

Este repositório contém uma aplicação Spring Boot integrada com uma stack de monitoramento composta por Prometheus e Grafana. A arquitetura inclui MySQL como banco de dados, Redis para cache e Nginx como proxy reverso, proporcionando uma solução completa para observabilidade.

## Visão Geral

Este projeto demonstra como configurar e integrar:

* **Aplicação Spring Boot:** Uma aplicação Java simples (provavelmente um fórum, dada a estrutura de pacotes como `br.com.alura.forum`) que pode ser monitorada.
* **Prometheus:** Um sistema de monitoramento e alerta de código aberto.
* **Grafana:** Uma plataforma de análise e visualização interativa de dados.
* **MySQL:** Banco de dados relacional para persistência de dados da aplicação.
* **Redis:** Um armazenamento de estrutura de dados em memória, usado como cache.
* **Nginx:** Servidor web usado como proxy reverso para a aplicação.

## Arquitetura

O sistema é orquestrado via Docker Compose, com os seguintes serviços:

* `app`: A aplicação Spring Boot.
* `mysql`: O banco de dados MySQL.
* `redis-forum-api`: O servidor Redis para cache da aplicação.
* `prometheus`: O servidor Prometheus configurado para coletar métricas da aplicação.
* `grafana`: O servidor Grafana, com plugins para visualização de logs, traces e métricas, conectado ao Prometheus e Loki.
* `nginx`: Atua como proxy reverso para a aplicação.
* `alertmanager`: Gerencia alertas enviados pelo Prometheus (configurado via `alertmanager.yml`).

## Como Começar

### Pré-requisitos

* Docker
* Docker Compose

### Configuração e Execução

1.  **Clone o repositório:**
    ```bash
    git clone <URL_DO_SEU_REPOSITORIO>
    cd prometheus-grafana
    ```
2.  **Construa a aplicação Spring Boot:**
    Navegue até o diretório `app` e construa o projeto Maven:
    ```bash
    cd app
    ./mvnw clean install # ou mvn clean install se você tiver o Maven instalado globalmente
    cd ..
    ```
3.  **Inicie a Stack com Docker Compose:**
    ```bash
    docker-compose up --build -d
    ```
    Isso irá construir as imagens Docker necessárias (se ainda não existirem) e iniciar todos os serviços em segundo plano.

### Acessando os Serviços

* **Aplicação (via Nginx):** `http://localhost/topicos`, `http://localhost/topicos/1`
* **Grafana:** `http://localhost:3000` (credenciais padrão: `admin`/`admin`)
* **Prometheus:** `http://localhost:9090`
* **Alertmanager:** `http://localhost:9093`

### Parando a Stack

Para parar todos os serviços e remover os containers:

```bash
docker-compose down
```

Para parar os serviços e também remover volumes (dados persistentes):

```bash
docker-compose down -v
```

Para parar e remover tudo, incluindo images:

```bash
docker-compose down -v --rmi all
```

## Integração com Slack para Alertas

Este repositório inclui a configuração para o Alertmanager do Prometheus enviar notificações de alerta para um canal específico do Slack, com o nome `#forum-api`.

A integração é configurada no arquivo `alertmanager/alertmanager.yml` e geralmente envolve os seguintes passos:

1.  **Configuração de um `webhook` do Slack:** No Slack, é gerado um URL de webhook de entrada (Incoming Webhook) que o Alertmanager usa para enviar as mensagens.
2.  **Definição do `receiver` no Alertmanager:** O `alertmanager.yml` possui uma seção `receivers` onde você define o canal do Slack e o URL do webhook. Exemplo de estrutura no `alertmanager.yml`:

    ```yaml
    receivers:
      - name: 'slack-notifications'
        slack_configs:
          - channel: '#forum-api' # Seu canal do Slack
            api_url: '<SEU_SLACK_WEBHOOK_URL>' # O webhook URL do Slack
    ```
3.  **Encaminhamento de Alertas:** As regras de `routes` no `alertmanager.yml` direcionam quais alertas (baseados em labels) devem ser enviados para este `receiver` do Slack. Por exemplo, todos os alertas que chegam podem ser roteados para o `slack-notifications` receiver.

Para que os alertas funcionem corretamente, é essencial que a variável de ambiente `SLACK_WEBHOOK_URL` (ou a URL direta no `alertmanager.yml`) esteja configurada com o webhook válido do seu workspace no Slack.

## Estrutura do Repositório

* `.gitignore`: Define os arquivos e diretórios a serem ignorados pelo Git.
* `alertmanager/`: Contém a configuração do Alertmanager (`alertmanager.yml`), essencial para roteamento de alertas, incluindo a integração com o Slack.
* `app/`: Contém o código-fonte da aplicação Spring Boot, incluindo:
    * `pom.xml`: Arquivo de configuração do Maven.
    * `src/main/java/`: Código-fonte Java da aplicação.
    * `src/main/resources/`: Arquivos de configuração, como `application.properties` e scripts SQL (`data.sql`).
    * `start.sh`: Script para iniciar a aplicação (vazio, pode ser expandido).
* `client/`: Contém `client.sh`, um script bash para simular requisições à API.
* `docker-compose.yaml`: Define e configura os serviços Docker da aplicação.
* `grafana/`: Contém configurações e plugins do Grafana, incluindo:
    * Plugins como `grafana-exploretraces-app`, `grafana-lokiexplore-app` e `grafana-metricsdrilldown-app` para funcionalidades específicas de observabilidade.
* `mysql/`: Contém o script SQL para inicialização do banco de dados (`database.sql`).
* `nginx/`: Contém as configurações do Nginx (`nginx.conf`) e proxy (`proxy.conf`).
* `prometheus/`: Contém a configuração do Prometheus (`prometheus.yml`).

## 🤔 How to contribute

-   Make a fork;
-   Clone the forked repository;
-   Create a branch with your feature: `git checkout -b my-feature`;
-   Commit changes: `git commit -m 'feat: My new feature'`;
-   Make a push to your branch: `git push -u origin my-feature`;
-   Create a PR from your branch to my branch.

After merging your receipt request to done, you can delete a branch from yours.

## :memo: License

This project is under the MIT license. See the [LICENSE](LICENSE](LICENSE)) for details.

Made with ♥ by Gabriel Vieira :wave: [Get in touch!](https://www.linkedin.com/in/bielvieira/)
