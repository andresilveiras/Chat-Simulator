#!/bin/bash

# Script para gerar builds de release limpos
# Remove frameworks e arquivos desnecessários

echo "🚀 Gerando builds de release..."

# Versão do app
VERSION="1.0.0"
RELEASE_DIR="release/v${VERSION}"

# Criar pasta de release
mkdir -p "$RELEASE_DIR"

# Build Android
echo "📱 Gerando APK Android..."
flutter build apk --release

# Copiar APK
cp "build/app/outputs/flutter-apk/app-release.apk" "$RELEASE_DIR/ChatSimulator-v${VERSION}-android.apk"

# Build iOS (sem frameworks)
echo "🍎 Gerando build iOS..."
flutter build ios --release --no-codesign

# Criar versão limpa do iOS app (sem frameworks)
echo "🧹 Limpando build iOS..."
cp -r "build/ios/iphoneos/Runner.app" "$RELEASE_DIR/ChatSimulator-v${VERSION}-ios.app"

# Remover frameworks do iOS build
rm -rf "$RELEASE_DIR/ChatSimulator-v${VERSION}-ios.app/Frameworks/"

# Remover pasta aninhada se existir
rm -rf "$RELEASE_DIR/ChatSimulator-v${VERSION}-ios.app/Runner.app"

# Copiar notas de release
cp "RELEASE_NOTES.md" "$RELEASE_DIR/"

echo "✅ Builds gerados com sucesso!"
echo "📁 Arquivos em: $RELEASE_DIR"
echo ""
echo "📋 Arquivos gerados:"
ls -la "$RELEASE_DIR" 