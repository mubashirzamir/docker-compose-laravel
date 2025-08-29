## This is where your Laravel app goes

To get started, **delete the contents of this folder** and then do one of the following:

### A. LARAVEL INSTALLER

**Note**: Due to issues with the Laravel installer in the current directory, use this workaround:

1. Create a new Laravel project in a temporary directory:
   ```bash
   ../dev-run laravel new testing
   ```

2. Move all files and folders from the `testing` directory to the current `src` directory:
   ```bash
   mv testing/* .
   mv testing/.* . 2>/dev/null || true  # Move hidden files (like .env, .gitignore)
   rmdir testing   
   ```

### B. COMPOSER

**Alternative**: You can also use Composer directly:
```bash
../dev-run composer create-project laravel/laravel .
```
