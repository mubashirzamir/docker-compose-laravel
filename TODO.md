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
- [x] Maybe different prefix than `COMPOSE` for .env.development and versioning for container images (Changed to `FORGE_` prefix)
- [x] Consolidate into one readme
- [x] Check if testing works
- [x] PHP Debugger with PHPStorm. How would that work?
- [x] Add docs on how I made testing and debugging work (Basically used the docker-compose file option for php interpreter).
- [x] Make laravel installer version configurable as well `FORGE_LARAVEL_INSTALLER_VERSION`

## In Progress
- [ ] Document when containers need restarting

## MISC
- [ ] Issues with using laravel installer in the current directory

## Forge and Wield
- [ ] Make it so the forge and wield commands know where compose development is so they can be run from anywhere.
- [ ] Review the new forge and wield commands
- [ ] Make it more convenient to execute scripts without having to worry about relative paths
- [ ] Improve QOL command feedback

### Environment & Configuration
- [ ] Fix `FORGE_COMPOSER_VERSION` behavior
- [ ] Bump npm version
- [ ] Review dockerfiles, especially the part where xdebug is installed
- [ ] Require the env file for the docker compose command. What did I mean by this?

### Architecture & Optimization
- [ ] Maybe the separate containers for composer, artisan, npm and laravel are not required. Can we consolidate them?
- [ ] Impact of delegations and caching of volumes in composer-development.yml

## Dream
- [ ] CI/CD support
- [ ] Laravel Herd competitor with multiple environment support.