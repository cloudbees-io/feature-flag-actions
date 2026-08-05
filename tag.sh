#!/usr/bin/env bash
set -eu

REMOTE="git@github.com:cloudbees-io/feature-flag-actions.git"

read -rp "Major version: " MAJOR
read -rp "Minor version: " MINOR
read -rp "Patch version: " PATCH

FULL_TAG="v${MAJOR}.${MINOR}.${PATCH}"
MAJOR_TAG="v${MAJOR}"

echo "Checking remote for existing tag ${FULL_TAG}..."
if git ls-remote --tags "$REMOTE" | grep -q "refs/tags/${FULL_TAG}$"; then
  echo "Error: tag ${FULL_TAG} already exists on the remote" >&2
  exit 1
fi

if git tag -l "$FULL_TAG" | grep -q "$FULL_TAG"; then
  echo "Removing local tag ${FULL_TAG}..."
  git tag -d "$FULL_TAG"
fi

echo "Creating and pushing ${FULL_TAG}..."
git tag -s "$FULL_TAG" -m "$FULL_TAG"
git push "$REMOTE" "$FULL_TAG"

echo "Creating/replacing ${MAJOR_TAG} and pushing..."
git tag -sf "$MAJOR_TAG" -m "$MAJOR_TAG"
git push -f "$REMOTE" "$MAJOR_TAG"

echo "Done: ${FULL_TAG} and ${MAJOR_TAG} pushed to ${REMOTE}"
