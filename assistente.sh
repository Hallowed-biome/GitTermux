#!/bin/bash

echo "🤖 Assistente GitHub iniciado!"
echo "Comandos: Auth, Init git, Create repo, Select repo, Folder create, Makefile, Edit file, File delete, Show all files, Push, exit"

while true; do
    echo ""
    read -p "💬 Comando: " COMANDO

    case "$COMANDO" in
        "Auth")
            echo "🌐 A iniciar o login no browser..."
            gh auth login --web
            ;;

        "Init git")
            git init
            read -p "❓ Nome da branch principal (ex: main): " BRANCH
            git branch -M "${BRANCH:-main}"
            echo "✅ Repositório local inicializado!"
            ;;

        "Create repo")
            read -p "❓ Nome para o novo repositório no GitHub: " REPO_NAME
            echo "🚀 A criar repositório '$REPO_NAME' no GitHub..."
            gh repo create "$REPO_NAME" --public --source=. --remote=origin
            ;;

        "Select repo")
            echo "🔍 A carregar repositórios do seu perfil..."
            REPO=$(gh repo list --limit 50 | awk '{print $1}' | fzf --prompt="Escolha o repo para clonar: ")
            if [ -n "$REPO" ]; then
                echo "📥 A clonar $REPO..."
                gh repo clone "$REPO"
                cd "$(basename "$REPO")" || exit
                echo "📂 Agora está dentro da pasta: $(pwd)"
            fi
            ;;

        "Folder create")
            read -p "❓ Folder Name? " FOLDER_NAME
            if [ -z "$FOLDER_NAME" ]; then
                echo "❌ O nome da pasta não pode estar vazio."
            else
                mkdir -p "$FOLDER_NAME"
                echo "📁 Pasta '$FOLDER_NAME' criada com sucesso!"
            fi
            ;;

        "Makefile")
            read -p "❓ Name? " FILE_NAME
            if [ -z "$FILE_NAME" ]; then
                echo "❌ O nome do ficheiro não pode estar vazio."
            else
                touch "$FILE_NAME"
                echo "📝 Ficheiro '$FILE_NAME' criado com sucesso!"
            fi
            ;;

        "Edit file")
            read -p "❓ Name? " EDIT_NAME
            if [ -f "$EDIT_NAME" ]; then
                nano "$EDIT_NAME"
            else
                echo "❌ O ficheiro '$EDIT_NAME' não existe. Use 'Makefile' primeiro."
            fi
            ;;

        "File delete")
            read -p "❓ Name? " DEL_NAME
            if [ -f "$DEL_NAME" ]; then
                read -p "⚠️ Tem a certeza que deseja apagar '$DEL_NAME'? (y/n): " CONFIRM
                if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
                    rm "$DEL_NAME"
                    echo "🗑️ Ficheiro '$DEL_NAME' eliminado."
                else
                    echo "❌ Operação cancelada."
                fi
            else
                echo "❌ O ficheiro '$DEL_NAME' não existe."
            fi
            ;;

        "Show all files")
            echo "🗂️ Lista de ficheiros e pastas no diretório atual:"
            echo "------------------------------------------------"
            ls -A --color=always -I .git
            echo "------------------------------------------------"
            ;;

        "Push")
            if [ ! -d ".git" ]; then
                echo "❌ Esta pasta não está conectada a nenhum repositório!"
                echo "Execute primeiro: 'Init git' seguido de 'Create repo'."
                continue
            fi
            
            read -p "❓ Commit message? " COMMIT_MSG
            git add .
            git commit -m "${COMMIT_MSG:-"update"}"
            
            CURRENT_BRANCH=$(git branch --show-current)
            echo "🚀 A enviar para o GitHub na branch $CURRENT_BRANCH..."
            git push -u origin "$CURRENT_BRANCH"
            ;;

        "exit"|"sair")
            echo "👋 Até à próxima!"
            break
            ;;

        *)
            echo "❓ Comando não reconhecido."
            ;;
    esac
done
