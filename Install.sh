#!/bin/bash

echo "📥 A instalar as dependências necessárias (gh e fzf)..."
pkg update && pkg upgrade -y
pkg install gh fzf git -y

echo "⚙️ A configurar o comando 'assistente' no sistema..."
# Descarrega o script principal e envia-o direto para a pasta de binários do Termux
curl -sLo $PREFIX/bin/assistente https://githubusercontent.com

# Dá permissão de execução ao comando
chmod +x $PREFIX/bin/assistente

echo "✅ Instalação concluída com sucesso!"
echo "🚀 Agora basta digitar 'assistente' em qualquer lugar do seu Termux para começar!"
