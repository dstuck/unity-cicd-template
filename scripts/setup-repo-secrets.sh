#!/bin/bash

# Script to set up GitHub repository secrets for Unity CI/CD
# Requires: gh CLI and appropriate access

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
BUTLER_FILE="$HOME/.butler"
UNITY_LICENSE_FILE="$HOME/.unity/Unity_lic.ulf"

echo -e "${GREEN}Setting up GitHub repository secrets...${NC}\n"

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: gh CLI is not installed.${NC}"
    echo "Install it from: https://cli.github.com/"
    exit 1
fi

# Check if gh is authenticated
if ! gh auth status &> /dev/null; then
    echo -e "${YELLOW}Warning: Not authenticated with GitHub.${NC}"
    echo "Run: gh auth login"
    exit 1
fi

# Get repository name (current directory or prompt)
REPO_NAME=$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")
read -p "GitHub repository (owner/repo) [default: current repo]: " REPO_INPUT
if [ -n "$REPO_INPUT" ]; then
    REPO="$REPO_INPUT"
else
    # Try to get from git remote
    GIT_REMOTE=$(git remote get-url origin 2>/dev/null || echo "")
    if [ -n "$GIT_REMOTE" ]; then
        # Extract owner/repo from git remote URL
        if [[ $GIT_REMOTE =~ github.com[:/]([^/]+)/([^/]+)\.git ]]; then
            REPO="${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
        else
            echo -e "${RED}Could not determine repository from git remote.${NC}"
            read -p "Enter repository (owner/repo): " REPO
        fi
    else
        echo -e "${RED}Could not determine repository.${NC}"
        read -p "Enter repository (owner/repo): " REPO
    fi
fi

echo -e "\n${GREEN}Setting secrets for repository: $REPO${NC}\n"

# 1. Set BUTLER_API_KEY
if [ -f "$BUTLER_FILE" ]; then
    BUTLER_KEY=$(cat "$BUTLER_FILE" | tr -d '\n\r')
    if [ -n "$BUTLER_KEY" ]; then
        echo -e "${GREEN}Setting BUTLER_API_KEY...${NC}"
        echo "$BUTLER_KEY" | gh secret set BUTLER_API_KEY --repo "$REPO"
        echo -e "${GREEN}✓ BUTLER_API_KEY set${NC}\n"
    else
        echo -e "${RED}Error: BUTLER_API_KEY file is empty${NC}"
        exit 1
    fi
else
    echo -e "${RED}Error: Butler API key file not found at $BUTLER_FILE${NC}"
    exit 1
fi

# 2. Set UNITY_EMAIL
echo -e "${YELLOW}Enter Unity email:${NC}"
read -p "Unity email: " UNITY_EMAIL
if [ -z "$UNITY_EMAIL" ]; then
    echo -e "${RED}Error: Unity email cannot be empty${NC}"
    exit 1
fi
echo -e "${GREEN}Setting UNITY_EMAIL...${NC}"
echo "$UNITY_EMAIL" | gh secret set UNITY_EMAIL --repo "$REPO"
echo -e "${GREEN}✓ UNITY_EMAIL set${NC}\n"

# 3. Set UNITY_LICENSE
if [ -f "$UNITY_LICENSE_FILE" ]; then
    echo -e "${GREEN}Setting UNITY_LICENSE...${NC}"
    gh secret set UNITY_LICENSE --repo "$REPO" < "$UNITY_LICENSE_FILE"
    echo -e "${GREEN}✓ UNITY_LICENSE set${NC}\n"
else
    echo -e "${RED}Error: Unity license file not found at $UNITY_LICENSE_FILE${NC}"
    exit 1
fi

# 4. Set UNITY_PASSWORD
echo -e "${YELLOW}Enter Unity password:${NC}"
read -s UNITY_PASSWORD
echo ""
if [ -z "$UNITY_PASSWORD" ]; then
    echo -e "${RED}Error: Password cannot be empty${NC}"
    exit 1
fi
echo -e "${GREEN}Setting UNITY_PASSWORD...${NC}"
echo "$UNITY_PASSWORD" | gh secret set UNITY_PASSWORD --repo "$REPO"
echo -e "${GREEN}✓ UNITY_PASSWORD set${NC}\n"

echo -e "${GREEN}✓ All secrets have been set successfully!${NC}"
echo -e "\nSecrets set for repository: $REPO"
echo "  - BUTLER_API_KEY"
echo "  - UNITY_EMAIL"
echo "  - UNITY_LICENSE"
echo "  - UNITY_PASSWORD"
