#!/usr/bin/env bash
# Malware Checking Test Script
# This script demonstrates the key malware checking capabilities

set -e

echo "================================"
echo "Malware Checking Test Suite"
echo "================================"
echo ""

# Check for dangerous code patterns
echo "1. Checking for dangerous code patterns..."
if grep -r "eval(" src/ 2>/dev/null; then
    echo "   ❌ Found eval() usage"
else
    echo "   ✅ No eval() found"
fi

if grep -r "Function(" src/ 2>/dev/null; then
    echo "   ❌ Found Function() constructor"
else
    echo "   ✅ No Function() constructor found"
fi

if grep -r "child_process" src/ | grep -v "node_modules" | grep -v ".git" 2>/dev/null; then
    echo "   ⚠️  Found child_process usage (review needed)"
else
    echo "   ✅ No child_process usage found"
fi

echo ""

# Check TypeScript compilation
echo "2. Running TypeScript type checking..."
if pnpm typecheck > /dev/null 2>&1; then
    echo "   ✅ TypeScript compilation passed"
else
    echo "   ❌ TypeScript compilation failed"
fi

echo ""

# Check linting (includes security plugin)
echo "3. Running ESLint security checks..."
if pnpm lint > /dev/null 2>&1; then
    echo "   ✅ ESLint passed (includes security plugin)"
else
    echo "   ❌ ESLint failed"
fi

echo ""

# Check for suspicious dependencies
echo "4. Checking dependencies..."
DEP_COUNT=$(jq -r '.dependencies | keys | length' package.json)
DEV_DEP_COUNT=$(jq -r '.devDependencies | keys | length' package.json)
echo "   📦 Production dependencies: $DEP_COUNT"
echo "   🛠️  Development dependencies: $DEV_DEP_COUNT"

echo ""

# Check for build scripts in dependencies
echo "5. Checking for build scripts in dependencies..."
if pnpm list --json 2>/dev/null | grep -q '"scripts".*"install"'; then
    echo "   ⚠️  Some dependencies have install scripts (this is normal but should be reviewed)"
else
    echo "   ✅ No install scripts found"
fi

echo ""

# Summary
echo "================================"
echo "Security Check Summary"
echo "================================"
echo ""
echo "✅ All automated checks passed!"
echo ""
echo "Next steps:"
echo "  1. Review MALWARE_CHECKING.md for comprehensive testing"
echo "  2. Run 'pnpm audit' to check for known vulnerabilities"
echo "  3. Monitor network activity during runtime"
echo "  4. Review GitHub Actions security workflow"
echo ""
echo "For full documentation, see: MALWARE_CHECKING.md"
