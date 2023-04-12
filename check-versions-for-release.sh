#!/bin/bash

if [ "$1" == "" ]; then
  echo "Argument: <release-type> required (one of 'ga|milestone|snapshot')"
  exit 1
fi
RELEASE_TYPE="$1"
VERBOSE="$2"

set +e

if [ "$RELEASE_TYPE" = "milestone" ]; then
  echo "Checking versions for $RELEASE_TYPE release"
  lines=$(find . -type f -name pom.xml | xargs grep SNAPSHOT | grep -v ".contains(" | grep -v regex | wc -l)
  if [ $lines -ne 0 ]; then
    echo "Snapshots version found ($lines). Exiting build"
    if [ "$VERBOSE" = "true" ]; then
        echo $(find . -type f -name pom.xml | xargs grep SNAPSHOT | grep -v ".contains(" | grep -v regex)
    fi
    exit 1
  fi
elif [ "$RELEASE_TYPE" = "ga" ]; then
  echo "Checking versions for $RELEASE_TYPE release"
  lines=$(find . -type f -name pom.xml | xargs egrep "SNAPSHOT|M[0-9]|RC[0-9]" | grep -v ".contains(" | grep -v regex | wc -l)
  if [ $lines -ne 0 ]; then
    echo "Non release versions found ($lines). Exiting build"
    if [ "$VERBOSE" = "true" ]; then
        echo $(find . -type f -name pom.xml | xargs egrep "SNAPSHOT|M[0-9]|RC[0-9]" | grep -v ".contains(" | grep -v regex)
    fi
    exit 1
  fi
else
  echo "Not checking versions for $RELEASE_TYPE release"
fi
