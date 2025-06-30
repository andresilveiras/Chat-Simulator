#!/bin/bash

# Habilitar modo rigoroso para tratamento de erros
set -euo pipefail

# Script para gerar builds de release limpos
# Remove frameworks e arquivos desnecessários

# Função para tratamento de erros
error_handler() {
    echo "❌ Erro no script: $1"
    echo "📍 Linha: $2"
    exit 1
}

# Configurar trap para capturar erros
trap 'error_handler "Erro inesperado" $LINENO' ERR

echo "🚀 Gerando builds de release..."

# Verificar se o Flutter está instalado
if ! command -v flutter &> /dev/null; then
    error_handler "Flutter não está instalado ou não está no PATH" $LINENO
fi

# Verificar se estamos no diretório correto
if [[ ! -f "pubspec.yaml" ]]; then
    error_handler "pubspec.yaml não encontrado. Execute este script na raiz do projeto Flutter" $LINENO
fi

# Extrair versão dinamicamente do pubspec.yaml
echo "📋 Extraindo versão do pubspec.yaml..."
VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //' | tr -d ' ')
if [[ -z "$VERSION" ]]; then
    error_handler "Não foi possível extrair a versão do pubspec.yaml" $LINENO
fi

echo "📦 Versão detectada: $VERSION"

# Verificar se existe uma tag Git correspondente (opcional)
if git rev-parse --verify "v$VERSION" &> /dev/null; then
    echo "🏷️  Tag Git v$VERSION encontrada"
elif git rev-parse --verify "$VERSION" &> /dev/null; then
    echo "🏷️  Tag Git $VERSION encontrada"
else
    echo "⚠️  Nenhuma tag Git encontrada para a versão $VERSION"
    echo "💡 Considere criar uma tag: git tag v$VERSION"
fi

# Versão do app (agora extraída dinamicamente)
RELEASE_DIR="release/v${VERSION}"

# Criar pasta de release
echo "📁 Criando pasta de release..."
mkdir -p "$RELEASE_DIR"

# Build Android
echo "📱 Gerando APK Android..."
flutter build apk --release

# Verificar se o APK foi gerado
if [[ ! -f "build/app/outputs/flutter-apk/app-release.apk" ]]; then
    error_handler "APK não foi gerado com sucesso" $LINENO
fi

# Copiar APK
echo "📋 Copiando APK..."
cp "build/app/outputs/flutter-apk/app-release.apk" "$RELEASE_DIR/ChatSimulator-v${VERSION}-android.apk"

# Build iOS (sem frameworks)
echo "🍎 Gerando build iOS..."
flutter build ios --release --no-codesign

# Verificar se o app iOS foi gerado
if [[ ! -d "build/ios/iphoneos/Runner.app" ]]; then
    error_handler "App iOS não foi gerado com sucesso" $LINENO
fi

# Criar versão limpa do iOS app (sem frameworks)
echo "🧹 Limpando build iOS..."
cp -r "build/ios/iphoneos/Runner.app" "$RELEASE_DIR/ChatSimulator-v${VERSION}-ios.app"

# Remover frameworks do iOS build
rm -rf "$RELEASE_DIR/ChatSimulator-v${VERSION}-ios.app/Frameworks/"

# Remover pasta aninhada se existir
rm -rf "$RELEASE_DIR/ChatSimulator-v${VERSION}-ios.app/Runner.app"

# Copiar notas de release
if [[ -f "RELEASE_NOTES.md" ]]; then
    cp "RELEASE_NOTES.md" "$RELEASE_DIR/"
else
    echo "⚠️  RELEASE_NOTES.md não encontrado"
fi

echo "✅ Builds gerados com sucesso!"
echo "📁 Arquivos em: $RELEASE_DIR"
echo "🏷️  Versão: $VERSION"
echo ""
echo "📋 Arquivos gerados:"
ls -la "$RELEASE_DIR" 