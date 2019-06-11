#!/bin/bash

DESTINO=$1
if [ -z "$DESTINO" ]
then
  echo "Informe um destino para o projeto! Atenção, se a pasta não existir ela será criada. Ex: ./initDev.sh DESTINO"
  exit 0;
fi

mkdir -p "$DESTINO"
cd "$DESTINO" || (echo "A pasta de destino não foi criada!" && exit 0)

# Constroi o package.json sem perguntar parametros, para usar parametros é só tirar o "-y"
yarn init -y

# Instalar modulos em ambiente de desenvolvimento
# typescript é o modulo para node responsavel para tipagem do javascript
# sucrase é responsavel por converter o typescript em javascript porque o browser ou o node não lê arquivo ts e sim js
# nodemon é o módulo responsável por executar o app e monitorar as mudanças reiniciando se necessário
# eslint e módulos relacionados ajudam a identificar erros em tempo de desenvolvimento
yarn add -D @babel/cli @babel/preset-env @babel/core eslint

touch .babelrc

echo '{"presets": ["@babel/preset-env"]}' > .babelrc

# Cria o diretório onde ficaram os codigos-fontes do projeto
mkdir src dev

# Cria o primeiro arquivo para iniciar o projeto
touch src/main.js

# Insere no arquivo package.json após a linha de license dois scripts, um para iniciar o app em modo desenvolvimento e outro para build
sed -i '/"license": "MIT",/a   "scripts": { "dev": "babel ./src/main.js -o ./dev/bundle.js -w", "build": "" },' package.json

# Cria e preenche o arquivo de configuração do nodemon
# touch nodemon.json
# echo '{"watch": ["src"], "ext": "js", "execMap": {"js": "sucrase-node src/main.js"}}' > nodemon.json

# Configura o eslint, remove o package-lock.json que é usado pelo npm e instala as dependências com o yarn já que estamos usando o yarn e não o npm
yarn eslint --init && rm package-lock.json && yarn
