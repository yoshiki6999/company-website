#!/bin/bash

################################################################################
# Security Check Script - AI Development Template
# Enforces CLAUDE.md §6.1 Security Baseline
#
# Purpose: Automated scanning for common security violations
# Exit Code: 0 = all PASS, 1 = any FAIL detected
################################################################################

# Note: Do NOT use set -e here — arithmetic ((count++)) returns 1 when count is 0,
# which would cause premature script exit with set -e enabled.

PASS_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Header
echo "========================================"
echo "  Security Check Report"
echo "  Date: $TIMESTAMP"
echo "========================================"
echo ""

################################################################################
# Check 1: CORS Wildcard Check
################################################################################
check_cors_wildcard() {
    local patterns=(
        'Access-Control-Allow-Origin.*\*'
        'origin.*["'"'"']\*["'"'"']'
        'cors({.*origin.*\*'
    )

    local results=()

    # Search in source files, excluding node_modules, .git, dist, build
    for pattern in "${patterns[@]}"; do
        while IFS= read -r line; do
            if [ -n "$line" ]; then
                results+=("$line")
            fi
        done < <(
            find "$PROJECT_ROOT" \
                -type f \
                \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" -o -name "*.json" \) \
                -not -path "*/node_modules/*" \
                -not -path "*/.git/*" \
                -not -path "*/dist/*" \
                -not -path "*/build/*" \
                -exec grep -l "$pattern" {} \; 2>/dev/null || true
        )
    done

    if [ ${#results[@]} -gt 0 ]; then
        echo -e "${RED}[FAIL]${NC} CORS: Wildcard origins found"
        for result in "${results[@]}"; do
            echo "  - $result"
        done
        ((FAIL_COUNT++))
    else
        echo -e "${GREEN}[PASS]${NC} CORS: No wildcard origins found"
        ((PASS_COUNT++))
    fi
}

################################################################################
# Check 2: Hardcoded Secrets Check
################################################################################
check_hardcoded_secrets() {
    local patterns=(
        'password\s*=\s*["'"'"'][^"'"'"']*[^"'"'"']'
        'secret\s*=\s*["'"'"'][^"'"'"']*[^"'"'"']'
        'api_key\s*=\s*["'"'"'][^"'"'"']*[^"'"'"']'
        'apiKey\s*=\s*["'"'"'][^"'"'"']*[^"'"'"']'
        'token\s*=\s*["'"'"'][^"'"'"']*[^"'"'"']'
    )

    local results=()

    for pattern in "${patterns[@]}"; do
        while IFS= read -r file; do
            if [ -n "$file" ]; then
                while IFS= read -r line; do
                    # Skip empty values and env references
                    if [[ ! "$line" =~ process\.env ]] && [[ ! "$line" =~ \$\{ ]] && [[ ! "$line" =~ \"\" ]]; then
                        results+=("$file: $line")
                    fi
                done < <(
                    grep -n "$pattern" "$file" 2>/dev/null || true
                )
            fi
        done < <(
            find "$PROJECT_ROOT" \
                -type f \
                \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" \) \
                -not -path "*/node_modules/*" \
                -not -path "*/.git/*" \
                -not -path "*/dist/*" \
                -not -path "*/build/*" \
                2>/dev/null || true
        )
    done

    if [ ${#results[@]} -gt 0 ]; then
        echo -e "${RED}[FAIL]${NC} Secrets: Hardcoded secrets found"
        for result in "${results[@]}"; do
            echo "  - $result"
        done
        ((FAIL_COUNT++))
    else
        echo -e "${GREEN}[PASS]${NC} Secrets: No hardcoded secrets detected"
        ((PASS_COUNT++))
    fi
}

################################################################################
# Check 3: Hardcoded URLs Check
################################################################################
check_hardcoded_urls() {
    local patterns=(
        'localhost'
        '127\.0\.0\.1'
        'railway\.app'
        'vercel\.app'
    )

    local results=()
    for pattern in "${patterns[@]}"; do
        while IFS= read -r file; do
            if [ -n "$file" ]; then
                # Check if file should be excluded (test/spec/config files are expected to have URLs)
                local should_exclude=0
                case "$file" in
                    *.env*|*test*|*spec*|*config*|*.example*)
                        should_exclude=1
                        ;;
                esac

                if [ $should_exclude -eq 0 ]; then
                    while IFS= read -r line; do
                        results+=("$file: $line")
                    done < <(
                        grep -n "$pattern" "$file" 2>/dev/null || true
                    )
                fi
            fi
        done < <(
            find "$PROJECT_ROOT" \
                -type f \
                \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" \) \
                -not -path "*/node_modules/*" \
                -not -path "*/.git/*" \
                -not -path "*/dist/*" \
                -not -path "*/build/*" \
                2>/dev/null || true
        )
    done

    if [ ${#results[@]} -gt 0 ]; then
        echo -e "${RED}[FAIL]${NC} URLs: Hardcoded environment URLs found"
        for result in "${results[@]}"; do
            echo "  - $result"
        done
        ((FAIL_COUNT++))
    else
        echo -e "${GREEN}[PASS]${NC} URLs: No hardcoded environment URLs"
        ((PASS_COUNT++))
    fi
}

################################################################################
# Check 4: Naked API Endpoints Check
################################################################################
check_naked_endpoints() {
    local results=()
    local endpoint_pattern='(app\.(get|post|put|delete|patch)|router\.(get|post|put|delete|patch)|export async function (GET|POST|PUT|DELETE|PATCH))'

    while IFS= read -r file; do
        if [ -n "$file" ]; then
            local line_num=0
            while IFS= read -r line; do
                ((line_num++))
                if [[ "$line" =~ $endpoint_pattern ]]; then
                    # Check if auth/middleware is present nearby (within 3 lines before or after)
                    local context_start=$((line_num - 3))
                    [ $context_start -lt 1 ] && context_start=1
                    local context_end=$((line_num + 3))

                    local has_auth=0
                    if grep -q -E '(auth|middleware|protect|verify|token|jwt|permission|role)' <(sed -n "${context_start},${context_end}p" "$file") 2>/dev/null; then
                        has_auth=1
                    fi

                    if [ $has_auth -eq 0 ]; then
                        results+=("$file:$line_num: $line")
                    fi
                fi
            done < "$file"
        fi
    done < <(
        find "$PROJECT_ROOT" \
            -type f \
            \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" \) \
            -not -path "*/node_modules/*" \
            -not -path "*/.git/*" \
            -not -path "*/dist/*" \
            -not -path "*/build/*" \
            -not -path "*test*" \
            -not -path "*spec*" \
            2>/dev/null || true
    )

    if [ ${#results[@]} -gt 0 ]; then
        echo -e "${YELLOW}[WARN]${NC} Auth: ${#results[@]} potentially unprotected endpoints found"
        for result in "${results[@]}"; do
            echo "  - $result"
        done
        ((WARN_COUNT++))
    else
        echo -e "${GREEN}[PASS]${NC} Auth: All endpoints appear to have auth protection"
        ((PASS_COUNT++))
    fi
}

################################################################################
# Check 5: SQL Injection Risk Check
################################################################################
check_sql_injection() {
    local results=()

    # Look for string concatenation with SQL keywords
    while IFS= read -r file; do
        if [ -n "$file" ]; then
            while IFS= read -r line; do
                if [[ "$line" =~ SELECT|INSERT|UPDATE|DELETE|DROP ]]; then
                    # Check if it's using parameterized queries
                    if [[ ! "$line" =~ \? ]] && [[ ! "$line" =~ \$1|\$2|\$3 ]] && [[ ! "$line" =~ \:\w+ ]] && [[ "$line" =~ \+ ]] || [[ "$line" =~ \` ]]; then
                        results+=("$file: $line")
                    fi
                fi
            done < <(
                grep -n "SELECT\|INSERT\|UPDATE\|DELETE\|DROP" "$file" 2>/dev/null || true
            )
        fi
    done < <(
        find "$PROJECT_ROOT" \
            -type f \
            \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" \) \
            -not -path "*/node_modules/*" \
            -not -path "*/.git/*" \
            -not -path "*/dist/*" \
            -not -path "*/build/*" \
            2>/dev/null || true
    )

    if [ ${#results[@]} -gt 0 ]; then
        echo -e "${RED}[FAIL]${NC} SQL: Potential SQL injection risks found"
        for result in "${results[@]}"; do
            echo "  - $result"
        done
        ((FAIL_COUNT++))
    else
        echo -e "${GREEN}[PASS]${NC} SQL: No obvious SQL injection patterns"
        ((PASS_COUNT++))
    fi
}

################################################################################
# Check 6: Secrets in Git History Check
################################################################################
check_secrets_in_git() {
    local results=()

    if [ -d "$PROJECT_ROOT/.git" ]; then
        while IFS= read -r line; do
            if [ -n "$line" ]; then
                results+=("$line")
            fi
        done < <(
            cd "$PROJECT_ROOT" && git log --all --oneline -20 --diff-filter=A -- "*.env" "*.env.*" "*secret*" "*credential*" 2>/dev/null || true
        )

        if [ ${#results[@]} -gt 0 ]; then
            echo -e "${YELLOW}[WARN]${NC} Git: Secret files found in git history"
            for result in "${results[@]}"; do
                echo "  - $result"
            done
            ((WARN_COUNT++))
        else
            echo -e "${GREEN}[PASS]${NC} Git: No secret files in recent git history"
            ((PASS_COUNT++))
        fi
    else
        echo -e "${GREEN}[PASS]${NC} Git: Not a git repository (skipped)"
        ((PASS_COUNT++))
    fi
}

################################################################################
# Check 7: .env in .gitignore Check
################################################################################
check_env_in_gitignore() {
    if [ -f "$PROJECT_ROOT/.gitignore" ]; then
        if grep -q "^\.env" "$PROJECT_ROOT/.gitignore"; then
            echo -e "${GREEN}[PASS]${NC} Gitignore: .env is properly ignored"
            ((PASS_COUNT++))
        else
            echo -e "${RED}[FAIL]${NC} Gitignore: .env not found in .gitignore"
            ((FAIL_COUNT++))
        fi
    else
        echo -e "${RED}[FAIL]${NC} Gitignore: .gitignore file not found"
        ((FAIL_COUNT++))
    fi
}

################################################################################
# Check 8: Dependencies Lock File Check
################################################################################
check_lock_file() {
    local lock_files=("package-lock.json" "pnpm-lock.yaml" "bun.lockb" "yarn.lock")
    local found=0

    for lock_file in "${lock_files[@]}"; do
        if [ -f "$PROJECT_ROOT/$lock_file" ]; then
            echo -e "${GREEN}[PASS]${NC} Lockfile: $lock_file found"
            found=1
            ((PASS_COUNT++))
            break
        fi
    done

    if [ $found -eq 0 ]; then
        echo -e "${RED}[FAIL]${NC} Lockfile: No dependency lock file found (package-lock.json, pnpm-lock.yaml, bun.lockb, or yarn.lock)"
        ((FAIL_COUNT++))
    fi
}

################################################################################
# Execute All Checks
################################################################################
echo "Running security checks..."
echo ""

check_cors_wildcard
check_hardcoded_secrets
check_hardcoded_urls
check_naked_endpoints
check_sql_injection
check_secrets_in_git
check_env_in_gitignore
check_lock_file

################################################################################
# Summary
################################################################################
echo ""
echo "========================================"
TOTAL=$((PASS_COUNT + FAIL_COUNT + WARN_COUNT))
echo "  Summary: $PASS_COUNT PASS / $FAIL_COUNT FAIL / $WARN_COUNT WARN (of $TOTAL checks)"

if [ $FAIL_COUNT -eq 0 ]; then
    echo "  Result: ${GREEN}PASSED${NC} (ready for deployment)"
else
    echo "  Result: ${RED}FAILED${NC} (fix required before deployment)"
fi

echo "========================================"

# Exit code
if [ $FAIL_COUNT -gt 0 ]; then
    exit 1
else
    exit 0
fi
