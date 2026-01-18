# Setup Scripts

## setup-repo-secrets.sh

Sets up GitHub repository secrets required for Unity CI/CD workflows.

### Prerequisites

1. **GitHub CLI (`gh`)** - Install from https://cli.github.com/
   ```bash
   brew install gh
   gh auth login
   ```

2. **Required files:**
   - `~/.butler` - Contains Butler API key for itch.io deployment
   - `~/.unity/Unity_lic.ulf` - Unity license file

### Usage

```bash
./scripts/setup-repo-secrets.sh
```

The script will:
1. Check for required tools and files
2. Prompt for repository name (or detect from git remote)
3. Prompt for Unity email and password
4. Set the following secrets:
   - `BUTLER_API_KEY` - From `~/.butler`
   - `UNITY_EMAIL` - Prompted from user
   - `UNITY_LICENSE` - From `~/.unity/Unity_lic.ulf`
   - `UNITY_PASSWORD` - Prompted from user (hidden input)
