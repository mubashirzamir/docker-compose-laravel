# Acknowledgements

This project is based on the [docker-compose-laravel](https://github.com/aschmelyun/docker-compose-laravel) repository
by aschmelyun, with improvements and customizations for my personal development workflow.

# docker-compose-laravel

Docker compose workflow for Laravel development using the following services:

- Nginx
- PHP-FPM
- PostgreSQL
- Redis
- MailHog

## Usage

### Prerequisites

To get started, make sure you have [Docker installed](https://docs.docker.com/desktop/) on your system, and then clone
this repository.

### Set Up Image Versions

Before building and running the containers, you may want to check the `.env.development` file in the root of this
repository to ensure that the versions of the images you are using are compatible with your project or needs. The file
contains the following variables:

```env
FORGE_NGINX_VERSION=nginx:1.28.0-alpine
FORGE_POSTGRES_VERSION=postgres:17.5
FORGE_PHP_VERSION=php:8.3-fpm-alpine
FORGE_PHP_EXTENSIONS=pdo pdo_pgsql
FORGE_COMPOSER_VERSION=composer:2.8.9
FORGE_REDIS_VERSION=redis:8.0.1-alpine
FORGE_NODE_VERSION=node:22.16.0
FORGE_MAILHOG_VERSION=mailhog/mailhog
FORGE_NETWORKS_NAME=app_network
```

### Default Port Mappings:

- **nginx** - `:80`
- **php** - `:9000`
- **postgresql** - `:5432`
- **redis** - `:6379`
- **mailhog** - `:8025`

### Make Scripts Executable

After cloning the repository, make the convenience scripts executable by running:

```bash
chmod +x forge wield
```

This will allow you to use the QOL commands:

### When to Use Each Script

- **`./forge up`** - Start containers with helpful status messages and URLs
- **`./forge stop`** - Stop containers
- **`./forge down`** - Stop and remove containers
- **`./forge rebuild`** - Rebuild images (use after modifying Dockerfiles)
- **`../wield run <service> <command>`** - Run one-off commands with service validation and examples
- **`../wield exec <service> <command>`** - Execute commands in running containers with service validation

Next, navigate in your terminal to the directory you cloned this, and spin up the containers for the web server by
running:

- `docker compose -f compose-development.yml --env-file .env.development up -d`

Alternatively you can use the provided convenience script:

- `./forge up` - Start the containers

Other relevant scripts:

- `./forge stop` - Stop the containers (preserves them for faster restart)
- `./forge down` - Stop and remove the containers
- `./forge rebuild` - Rebuild images and start containers (use after Dockerfile changes)

### Setting up Laravel Project

After that completes:

   ```bash
   mkdir src
   cd src
   ```

Laravel project can be created using either the Laravel installer or Composer:

### A. Laravel Installer

**Note**: Due to issues with the Laravel installer in the current directory, use this workaround:

1. Create a new Laravel project in a temporary directory:
   ```bash
   ../wield run laravel new testing
   ```

2. Move all files and folders from the `testing` directory to the current `src` directory:
   ```bash
   mv testing/* .
   mv testing/.* . 2>/dev/null || true  # Move hidden files (like .env, .gitignore)
   rmdir testing   
   ```

### B. Composer

**Alternative**: You can also use Composer directly:

```bash
../wield run composer create-project laravel/laravel .
```

### Using the Containers

Four additional containers are included that handle Composer, Laravel Installer, NPM, and Artisan commands *without*
having to have these platforms installed on your local computer. Use the following command examples from your project
root, modifying them to fit your particular use case.

- `docker compose -f ../compose-development.yml run --rm composer update`
- `docker compose -f ../compose-development.yml run --rm laravel new project-name`
- `docker compose -f ../compose-development.yml run --rm npm run dev`
- `docker compose -f ../compose-development.yml run --rm artisan migrate`

And for persistent containers:

- `docker compose -f ../compose-development.yml exec nginx sh`
- `docker compose -f ../compose-development.yml exec php sh`
- `docker compose -f ../compose-development.yml exec postgres sh`
- `docker compose -f ../compose-development.yml exec redis sh`
- `docker compose -f ../compose-development.yml exec mailhog sh`

Alternatively you can use the following QOL commands:

- `../wield run composer update`
- `../wield run laravel new project-name`
- `../wield run npm run dev`
- `../wield run artisan migrate`

And for persistent containers:

- `../wield exec nginx sh`
- `../wield exec php sh`
- `../wield exec postgres sh`
- `../wield exec redis sh`
- `../wield exec mailhog sh`

## Compiling Assets

This configuration should be able to compile assets with both [laravel mix](https://laravel-mix.com/)
and [vite](https://vitejs.dev/). In order to get started, you first need to add ` --host 0.0.0.0` after the end of your
relevant dev command in `package.json`. So for example, with a Laravel project using Vite, you should see:

```json
{
   "scripts": {
      "dev": "vite --host 0.0.0.0",
      "build": "vite build"
   }
}
```

Then, run the following commands to install your dependencies and start the dev server:

- `docker compose run --rm npm install`
- `docker compose run --rm --service-ports npm run dev`

Alternatively you can use the following QOL commands:

- `../wield run npm i`
- `../wield run npm run dev`

After that, you should be able to use `@vite` directives to enable hot-module reloading on your local Laravel
application.

Want to build for production? Simply run `docker compose run --rm npm run build`.

Alternatively you can use the following QOL command:

- `../wield run npm run build`

## Inertia.js + Vite Setup

This setup also works with Inertia.js for building modern single-page applications with Laravel. Here's how to configure
it:

### 1. Configure Vite for Inertia

Create or update your `vite.config.js` file in your Laravel project root:

```javascript
import {defineConfig} from 'vite';
import laravel from 'laravel-vite-plugin';
import react from '@vitejs/plugin-react'; // For React
// import vue from '@vitejs/plugin-vue'; // For Vue

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
        react(), // For React
        // vue(), // For Vue
    ],
    server: {
        host: '0.0.0.0',      // Bind to all interfaces for Docker networking
        port: 5173,           // Vite dev server port
        hmr: {
            host: 'localhost' // Browser connects here for hot module replacement
        },
        watch: {
            usePolling: true  // Required for file watching in Docker containers
        },
    },
});
```

**Note:** The `usePolling: true` setting is required when running Vite in Docker containers or WSL2. This is due to WSL2
limitations where file system watching doesn't work when files are edited by Windows applications. While this leads to
higher CPU utilization, it ensures reliable file watching across different environments.

### 2. Start Development

```bash
../wield run npm run dev
```

Your Inertia.js application should now work with hot module replacement and proper Docker networking!

## Database Configuration

After setting up your Laravel project, you need to configure it to use the PostgreSQL database. In your Laravel
project's `.env` file, use these settings:

```env
DB_CONNECTION=pgsql
DB_HOST=postgres
DB_PORT=5432
DB_DATABASE=app
DB_USERNAME=laravel
DB_PASSWORD=secret
```

**Important**: The `DB_HOST=postgres` must match the service name in `compose-development.yml`. The PostgreSQL service
is named `postgres`, so that's what Laravel should connect to.

---

## Persistent PostgreSQL Storage

Persistent storage for PostgreSQL has already been set up in your project, so your database data will **not** be lost
when you bring down the Docker network.

The setup works as follows:

1. A `volumes/postgres` folder exists in the project root.
2. In your `compose-development.yml` file, the PostgreSQL service includes the volume mapping:

```yaml
postgres:
  image: ${COMPOSE_POSTGRES_VERSION:-postgres:latest}
  restart: unless-stopped
  tty: true
  ports:
    - "${POSTGRES_PORT:-5432}:5432"
  environment:
    - POSTGRES_DB=app
    - POSTGRES_USER=laravel
    - POSTGRES_PASSWORD=secret
  volumes:
    - ./volumes/postgres:/var/lib/postgresql/data
  networks:
    - app_network
```

This ensures that all database files are stored in the `volume/postgres` folder on the host machine, so stopping or
removing containers will **not delete your database**.

## Testing and Debugging in PHPStorm

To set up testing and debugging in PHPStorm, follow these steps:

1. **Set Up PHP Interpreter**:
    - Go to `File > Settings > Languages & Frameworks > PHP`.
    - Click the `...` button next to the CLI Interpreter dropdown.
    - Click the `+` button and select `From Docker, Vagrant, VM, Remote...`.
    - Choose `Docker Compose`.
    - Select your Docker server and the `compose-development.yml` file.
    - Set the service to `php`.
    - Click `OK` to save.

2. **Set Up PHPUnit**:
    - Go to `File > Settings > Languages & Frameworks > PHP > Test Frameworks`.
    - Click the `+` button and select `PHPUnit by Remote Interpreter`.
    - Choose the interpreter you just created.
    - Select `Path to ` and provide the path `/var/www/html/vendor/bin/phpunit`.
    - Click `OK` to save.

## WSL2 Performance Optimization

Add information from Vite's docs here.

## aschmelyun start
---

## Permissions Issues

If you encounter any issues with filesystem permissions while visiting your application or running a container command,
try completing one of the sets of steps below.

**If you are using your server or local environment as the root user:**

- Bring any container(s) down with `docker compose down`
- Replace any instance of `php.dockerfile` in the compose-development.yml file with `php.root.dockerfile`
- Re-build the containers by running
  `docker compose -f compose-development.yml --env-file .env-development --no-cache build`

**If you are using your server or local environment as a user that is not root:**

- Bring any container(s) down with `docker compose down`
- In your terminal, run `export UID=$(id -u)` and then `export GID=$(id -g)`
- If you see any errors about readonly variables from the above step, you can ignore them and continue
- Re-build the containers by running `docker compose build --no-cache`

Then, either bring back up your container network or re-run the command you were trying before, and see if that fixes
it.

## MailHog

The current version of Laravel (9 as of today) uses MailHog as the default application for testing email sending and
general SMTP work during local development. Using the provided Docker Hub image, getting an instance set up and ready is
simple and straight-forward. The service is included in the `compose-development.yml` file, and spins up alongside the
webserver and database services.

To see the dashboard and view any emails coming through the system, visit [localhost:8025](http://localhost:8025) after
running `docker compose -f compose-development.yml --env-file .env.development up -d`.

## Usage in Production

While I originally created this template for local development, it's robust enough to be used in basic Laravel
application deployments. The biggest recommendation would be to ensure that HTTPS is enabled by making additions to the
`nginx/default.conf` file and utilizing something like [Let's Encrypt](https://hub.docker.com/r/linuxserver/letsencrypt)
to produce an SSL certificate.

## aschmelyun end
