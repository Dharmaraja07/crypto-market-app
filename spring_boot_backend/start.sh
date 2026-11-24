#!/bin/bash
export PATH="/Applications/IntelliJ IDEA.app/Contents/plugins/maven-plugin/lib/maven3/bin:/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
cd "$(dirname "$0")"
mvn spring-boot:run -Dspring-boot.run.profiles=postgres
