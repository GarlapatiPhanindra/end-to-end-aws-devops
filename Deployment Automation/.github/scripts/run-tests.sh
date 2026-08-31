#!/usr/bin/env bash
set -euo pipefail

test_type="${1:?Usage: run-tests.sh <unit|integration>}"
command_variable="${test_type^^}_TEST_COMMAND"
command="${!command_variable:-}"

if [[ -n "$command" ]]; then
  bash -lc "$command"
  exit 0
fi

if [[ -f package.json ]]; then
  npm ci
  if [[ "$test_type" == integration ]]; then npm run test:integration; else npm test -- --runInBand; fi
elif [[ -f pyproject.toml || -f requirements.txt ]]; then
  python -m pip install --upgrade pip
  [[ -f requirements.txt ]] && python -m pip install -r requirements.txt
  python -m pip install pytest
  if [[ "$test_type" == integration ]]; then python -m pytest tests/integration; else python -m pytest tests/unit; fi
elif [[ -f pom.xml ]]; then
  if [[ "$test_type" == integration ]]; then mvn -B verify -Pintegration; else mvn -B test; fi
elif [[ -f build.gradle || -f build.gradle.kts ]]; then
  if [[ "$test_type" == integration ]]; then ./gradlew integrationTest; else ./gradlew test; fi
elif [[ -f go.mod ]]; then
  if [[ "$test_type" == integration ]]; then go test -tags=integration ./...; else go test ./...; fi
else
  echo "No supported tests found. Set $command_variable as a repository variable."
  exit 1
fi
