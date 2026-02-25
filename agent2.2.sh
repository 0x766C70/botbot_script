#!/bin/bash

# Configuration
MISTRAL_API_KEY="2IxSTDOqmJOzT1KbpJxV1hcoq4YXfTF4"
CONV_ID="${4:-}"  # Utilisation de ${var:-} pour éviter les erreurs si vide
today=$(date +"%Y-%m-%d")
speaker="${1:-utilisateur}"  # Valeur par défaut
message="${3:-Bonjour}"      # Valeur par défaut

# Validation des paramètres
if [ $# -lt 3 ]; then
    echo "Usage: $0 <speaker> <brain> <message> [conversation_id]"
    exit 1
fi

case "$2" in
    "botbot_fdn")
	AGENT_ID="ag:00bd343b:20251002:botbot-fdn:7a3e7bdb"
	;;
    "botbot_mifa")
	AGENT_ID="ag:00bd343b:20251010:mifa-bot:d61e378c"
	;;
esac

# Construction de la requête
if [ -n "$CONV_ID" ]; then
    #echo "Using existing conversation ID: $CONV_ID"
    API_URL="https://api.mistral.ai/v1/conversations/$CONV_ID"
    REQUEST_BODY=$(jq -n \
        --arg today "$today" \
        --arg speaker "$speaker" \
        --arg message "$message" \
        --arg agent_id "$AGENT_ID" \
        '{
            inputs: "Nous sommes le \($today) et ton interlocuteur est \($speaker). Il te dit: \($message)",
            stream: false,
            store: true,
            handoff_execution: "server"
        }')
else
    #echo "Starting a new conversation."
    API_URL="https://api.mistral.ai/v1/conversations"
    REQUEST_BODY=$(jq -n \
        --arg today "$today" \
        --arg speaker "$speaker" \
        --arg message "$message" \
        --arg agent_id "$AGENT_ID" \
        '{
            inputs: [{
                role: "user",
                content: ("Nous sommes le \($today) et ton interlocuteur est \($speaker). Il te dit: \($message)"),
                object: "entry",
                type: "message.input"
            }],
            stream: false,
            agent_id: $agent_id
        }')
fi

echo $REQUEST_BODY

# Exécution de la requête
response=$(curl -s --location "$API_URL" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer $MISTRAL_API_KEY" \
    -d "$REQUEST_BODY")


# Affichage du résultat
clean_text=$(echo "$response" | jq -r '.outputs[0].content[0].text')
clean_conv=$(echo "$response" | jq -r '.conversation_id')

jq_answer=$(jq -n \
        --arg reponse "$clean_text" \
        --arg conv "$clean_conv" \
	'{
	   message: "\($reponse)",
	   conv: "\($conv)"
   	}')

echo "$jq_answer"
