#!/bin/bash

# Carregar variáveis de ambiente do arquivo .env
export $(grep -v '^#' .env | xargs)

# URL da API para obter informações da organização
API_URL="${AZURE_DEVOPS_ORG}/_apis/projects?api-version=7.1-preview.1"

# Fazer a requisição usando curl e capturar a resposta
response=$(curl -s -w "%{http_code}" -u ":${AZURE_DEVOPS_PAT}" "$API_URL" -o tmp/response_auth.json)

# Verificar o código de resposta HTTP
if [ "$response" -eq 200 ]; then
    echo "Credenciais válidas! Você está autenticado com sucesso."

    # Função para verificar logs de criação de usuários
    check_user_creation_logs() {
        echo "Buscando logs de criação de usuários..."
        response=$(curl -s -w "%{http_code}" -u ":${AZURE_DEVOPS_PAT}" "${AZURE_DEVOPS_ORG_AUDIT}/_apis/audit/auditlog?startTime=2024-01-01T00:00:00Z&endTime=2024-10-01T00:00:00Z&$top=100&actionId=User.Created&api-version=7.1-preview.1" -o tmp/response.json)

        if [ "$response" -eq 200 ]; then
            echo "Requisição bem-sucedida."
            response=$(cat tmp/response.json)  # Carrega a resposta JSON

            Verifica se a chave 'value' está presente
            if echo "$response" | jq -e '.value' > /dev/null; then
                echo "$response" | jq -r '.value[] | select(.actionId=="User.Create") | .id + " - " + .actor.displayName + " criou " + .details.displayName + " em " + .details.timestamp'
            else
                echo "A chave 'value' não está presente na resposta."
                echo "Resposta recebida:"
                echo "$response"
            fi
        else
            echo "Erro na requisição. Código de resposta: $response"
            exit 1
        fi
    }

    # Função para verificar logs de remoção de usuários
    check_user_removal_logs() {
        echo "Buscando logs de remoção de usuários..."
        response=$(curl -s -u ":${AZURE_DEVOPS_PAT}" "${AZURE_DEVOPS_ORG_AUDIT}/_apis/audit/auditlog?api-version=7.1-preview.1")

        # Verifica se a resposta é JSON antes de processar com jq
        if echo "$response" | jq . > /dev/null 2>&1; then
            echo "$response" | jq -r '.value[] | select(.actionId=="User.Delete") | .id + " - " + .actor.displayName + " removeu " + .details.displayName + " em " + .details.timestamp'
        else
            echo "A resposta da API não é JSON válido."
            echo "Resposta recebida:"
            echo "$response"
        fi
    }

    # Função para verificar logs de alteração de perfil/permissões de usuários
    check_permission_change_logs() {
        echo "Buscando logs de alteração de permissões..."
        response=$(curl -s -u ":${AZURE_DEVOPS_PAT}" "${AZURE_DEVOPS_ORG_AUDIT}/_apis/audit/auditlog?api-version=7.1-preview.1")

        # Verifica se a resposta é JSON antes de processar com jq
        if echo "$response" | jq . > /dev/null 2>&1; then
            echo "$response" | jq -r '.value[] | select(.actionId=="User.Update") | .id + " - " + .actor.displayName + " alterou permissões de " + .details.displayName + " em " + .details.timestamp'
        else
            echo "A resposta da API não é JSON válido."
            echo "Resposta recebida:"
            echo "$response"
        fi
    }

    # Menu de opções
    while true; do
        echo "Escolha uma ação:
        1. Verificar logs de criação de usuários
        2. Verificar logs de remoção de usuários
        3. Verificar logs de alteração de permissões
        4. Sair"

        read -p "Opção: " action

        case $action in
            1) check_user_creation_logs ;;
            2) check_user_removal_logs ;;
            3) check_permission_change_logs ;;
            4) exit 0 ;;
            *) echo "Opção inválida." ;;
        esac
    done

else
    echo "Falha na autenticação. Código de resposta: $response"
fi