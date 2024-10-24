# Sistema de Relatórios de Logs do Azure DevOps

Este projeto é um sistema de linha de comando construído com Ruby, projetado para gerar relatórios de logs do Azure DevOps. O sistema consulta diretamente as APIs do Azure DevOps, permite a geração de relatórios em PDF e Excel, e utiliza Docker para facilitar a implantação e execução.

## Funcionalidades

- Consulta direta aos logs do Azure DevOps
- Geração de relatórios em PDF
- Exportação de dados em Excel
- Interface de linha de comando para interação com o usuário
- Containerização com Docker para fácil implantação

## Pré-requisitos

- Docker e Docker Compose
- Credenciais do Azure DevOps (organização e token de acesso pessoal)

## Clone e Configuração

1. Clone o repositório:

   ```
   git clone https://github.com/seu-usuario/nome-do-repo.git
   cd nome-do-repo
   ```
2. Crie um arquivo `.env` na raiz do projeto com suas credenciais do Azure DevOps:

   ```
   AZURE_DEVOPS_ORG=https://dev.azure.com/sua-organizacao
   AZURE_DEVOPS_PAT=seu-token-de-acesso-pessoal
   ```

## Execução do Programa no Container

  Para executar o programa dentro do container Docker, siga estas etapas:

1. Certifique-se de que o Docker está instalado e em execução em seu sistema.
2. Construa a imagem Docker (se ainda não o fez):
   ``docker-compose build``
3. Inicie o container:
   ``docker-compose up -d``
4. Execute o programa dentro do container:
   ``docker-compose exec app ruby main.rb``

   Este comando executa o script `main.rb` dentro do container.
5. Siga as instruções no console para inserir as datas de início e fim, bem como o tipo de relatório desejado.
6. Para sair do programa, use Ctrl+C.
7. Quando terminar, você pode parar o container com:
   ``docker-compose down``

  Observação: Os relatórios gerados serão salvos no diretório compartilhado entre o container e seu sistema local, conforme definido no `docker-compose.yml`.

## Uso

Ao executar o sistema, você será solicitado a fornecer:

1. Data de início (formato YYYY-MM-DD)
2. Data de fim (formato YYYY-MM-DD)
3. Tipo de relatório (pdf, excel ou imprimir)

O sistema irá gerar o relatório solicitado e salvá-lo no diretório atual.

## Desenvolvimento

Para desenvolvimento local sem Docker:

1. Certifique-se de ter Ruby instalado (versão recomendada: 3.0.0 ou superior)
2. Instale as dependências:

   ```
   bundle install
   ```
3. Execute o sistema:

   ```
   ruby main.rb
   ```

## Contribuindo

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Faça commit das suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request
