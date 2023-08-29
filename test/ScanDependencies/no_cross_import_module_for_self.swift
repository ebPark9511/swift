// RUN: %empty-directory(%t)
// RUN: mkdir -p %t/clang-module-cache
// RUN: %target-swift-frontend -scan-dependencies -module-cache-path %t/clang-module-cache %s -o %t/deps.json -I %S/Inputs/CHeaders -I %S/Inputs/CHeaders/ExtraCModules -I %S/Inputs/Swift -emit-dependencies -emit-dependencies-path %t/deps.d -swift-version 4 -module-name _cross_import_E
// Check the contents of the JSON output
// RUN: %validate-json %t/deps.json | %FileCheck %s

// REQUIRES: executable_test
// REQUIRES: objc_interop

// Ordinarily, importing `E` and `SubE` triggers a cross-import of `_cross_import_E`, but not here, because we are building `_cross_import_E` Swift module itself.
import EWrapper
import SubEWrapper

// CHECK:   "swift": "_cross_import_E"
// CHECK:  "directDependencies": [
// CHECK-DAG:   "swift": "EWrapper"
// CHECK-DAG:   "swift": "SubEWrapper"
// CHECK-DAG:   "swift": "Swift"
// CHECK-DAG:   "swift": "SwiftOnoneSupport"
// CHECK-DAG:   "swift": "_Concurrency"
// CHECK-DAG:   "swift": "_StringProcessing"
// CHECK-DAG:   "clang": "_SwiftConcurrencyShims"
// CHECK-NOT:   "swift": "_cross_import_E"
// CHECK: ]

