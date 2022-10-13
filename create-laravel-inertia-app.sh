#!/bin/bash

APP_NAME=$1
DB=$2
DB_USERNAME=$3
DB_PASSWORD=$4

function usage() {
    echo "Usage: ./create-laravel-inertia-app.sh <app_name>"
}

if [[  "${APP_NAME}" == "" ]]; then
    usage
    exit 1
fi

echo "Creating Laravel Inertia Application: ${APP_NAME}"

echo "Creating Laravel project with composer"
composer create-project laravel/laravel ${APP_NAME}

cd ${APP_NAME}
echo "Installing PHP package inertiajs/inertia-laravel"
composer require inertiajs/inertia-laravel
php artisan inertia:middleware

echo "Installing Node.js packages @inertiajs/inertia @inertiajs/inertia-vue3"
npm install @inertiajs/inertia @inertiajs/inertia-vue3 @inertiajs/progress

echo "Installing Laravel Breeze"
composer require laravel/breeze --dev
php artisan breeze:install

echo "Updating .env"
# special treatment on Mac OS
sed -i "" "s/DB_DATABASE=laravel/DB_DATABASE=${DB}/" .env
sed -i "" "s/DB_USERNAME=root/DB_USERNAME=${DB_USERNAME}/" .env
sed -i "" "s/DB_PASSWORD=/DB_PASSWORD=${DB_PASSWORD}/" .env

php artisan migrate
npm install

echo "Installing more Node.js packages"
npm install vue@next vue-loader@next @vitejs/plugin-vue