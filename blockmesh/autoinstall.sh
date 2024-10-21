#!/bin/bash

# Оновлюємо сервер
echo "Оновлення сервера..."
bash <(curl -s https://raw.githubusercontent.com/asapov01/Backup/main/server-upgrade.sh)
echo "Оновлення завершено. Очікуйте 2-4 хвилини перед продовженням."

# Скачуємо архів, розархівовуємо та заходимо в папку BlockMesh Node
echo "Завантаження та розпакування BlockMesh CLI..."
wget https://github.com/block-mesh/block-mesh-monorepo/releases/download/v0.0.307/blockmesh-cli-x86_64-unknown-linux-gnu.tar.gz
tar -xzvf blockmesh-cli-x86_64-unknown-linux-gnu.tar.gz
rm blockmesh-cli-x86_64-unknown-linux-gnu.tar.gz
cd target/release || exit

# Запуск screen сесії
echo "Запуск screen сесії для BlockMesh Node..."
screen -dmS blockmesh_node

# Підключаємося до screen сесії та запускаємо ноду (замініть значення на ваші дані)
EMAIL="" # Замініть на ваш емейл
PASSWORD="" # Замініть на ваш пароль

# Команда для запуску ноди
echo "Запускаємо ноду BlockMesh..."
screen -S blockmesh_node -X stuff "./blockmesh-cli login --email $EMAIL --password $PASSWORD\n"

