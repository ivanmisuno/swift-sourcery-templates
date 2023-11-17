#!/bin/bash

xcodebuild -scheme ExampleProjectSpm -destination 'platform=iOS Simulator,OS=14.6,name=iPhone 11' -configuration "Debug" -sdk "iphonesimulator"
