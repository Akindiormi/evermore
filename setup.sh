#!/bin/bash
set -e
flutter create . --project-name evermore --org com.evermore --platforms=android,ios
flutter pub get
flutter analyze
