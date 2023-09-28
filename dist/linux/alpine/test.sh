#!/bin/sh

# hack to get openjfx working in tests
LD_PRELOAD=/lib/libgcompat.so.0 mvn test || exit 1
mvn clean || exit 1
