# TODOS

## Completed

- [x] Remove delegations from compose-development
- [x] Dev down command as well.
- [x] Add instruction to change permissions for exec files or make them executable by default.
- [x] Change all docker-compose commands to docker compose to reduce dependencies
- [x] Resolve issues with Vite and hot module reloading
- [x] Explore installation via Laravel installer instead of Composer
- [x] Check with React (Checked with Inertia and React)
- [x] Resolve WSL2 performance issues with Inertia + React by moving project to WSL
- [x] Test if database works

## MISC
- [ ] Issues with using laravel installer in the current directory
- [ ] Make it more convenient to execute scripts without having to worry about relative paths
- [ ] Document when containers need restarting
- [ ] Maybe different prefix than `COMPOSE` for .env.development and versioning for container images
- [ ] Improve QOL command feedback
- [ ] Consolidate into one readme

### Environment & Configuration
- [ ] Fix `COMPOSE_COMPOSER_VERSION` behavior
- [ ] Make laravel installer version configurable as well `COMPOSE_LARAVEL_INSTALLER_VERSION`
- [ ] Require the env file for the docker compose command. What did I mean by this?
- [ ] Bump npm version

### Testing
- [ ] Check if testing works
- [ ] PHP Debugger with PHPStorm. How would that work?

### Architecture & Optimization
- [ ] Maybe the separate containers for composer, artisan, npm and laravel are not required. Can we consolidate them?
- [ ] Impact of delegations and caching of volumes in composer-development.yml

## Dream
- [ ] Laravel Herd competitor with multiple environment support.