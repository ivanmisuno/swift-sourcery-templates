#!/bin/bash

xcodebuild test \
    -scheme ExampleProjectSpm \
    -destination 'platform=iOS Simulator,OS=17.4,name=iPhone 15' \
    -configuration "Debug" \
    -sdk "iphonesimulator" \
    -skipPackagePluginValidation \
    | xcbeautify
