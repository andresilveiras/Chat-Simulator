#!/bin/bash

# Habilitar modo rigoroso para tratamento de erros
set -euo pipefail

# Script para criar releases completos com tags Git

# Função para tratamento de erros
error_handler() {
    echo "❌ Erro no script: $1"
    echo "📍 Linha: $2"
    exit 1
}

# Configurar trap para capturar erros
trap 'error_handler "Erro inesperado" $LINENO' ERR

echo "🚀 Criando release completo..."

# Verificar se estamos no diretório correto
if [[ ! -f "pubspec.yaml" ]]; then
    error_handler "pubspec.yaml não encontrado. Execute este script na raiz do projeto Flutter" $LINENO
fi

# Extrair versão do pubspec.yaml
VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //' | tr -d ' ')
if [[ -z "$VERSION" ]]; then
    error_handler "Não foi possível extrair a versão do pubspec.yaml" $LINENO
fi

echo "📦 Versão: $VERSION"

# Verificar se já existe uma tag para esta versão
if git rev-parse --verify "v$VERSION" &> /dev/null; then
    echo "⚠️  Tag v$VERSION já existe!"
    read -p "Deseja continuar mesmo assim? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Operação cancelada"
        exit 1
    fi
fi

# Verificar se há mudanças não commitadas
if [[ -n $(git status --porcelain) ]]; then
    echo "⚠️  Há mudanças não commitadas no repositório"
    git status --short
    read -p "Deseja continuar mesmo assim? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Operação cancelada"
        exit 1
    fi
fi

# Gerar builds
echo "🔨 Gerando builds..."
./scripts/build_release.sh

# Fazer commit das mudanças se houver
if [[ -n $(git status --porcelain) ]]; then
    echo "📝 Fazendo commit das mudanças..."
    git add .
    git commit -m "chore: prepare release v$VERSION"
fi

# Criar tag
echo "🏷️  Criando tag v$VERSION..."
git tag -a "v$VERSION" -m "Release v$VERSION"

echo "✅ Release v$VERSION criado com sucesso!"
echo ""
echo "📋 Próximos passos:"
echo "1. Push das mudanças: git push origin main"
echo "2. Push da tag: git push origin v$VERSION"
echo "3. Criar release no GitHub com os arquivos em release/v$VERSION/" 