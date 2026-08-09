// Copyright 2026 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#if SWIFT_PACKAGE
  @testable import FirebaseCrashlyticsSwift
#else
  @testable import FirebaseCrashlytics
#endif
import XCTest

final class CrashReporterExtensionTests: XCTestCase {

  func testCrashReporterExtensionKeyConstant() {
    #if canImport(CrashReportExtension)
      if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
        XCTAssertEqual(
          CrashlyticsCrashReporterExtension.crashReporterExtensionEnabledKey,
          "FirebaseCrashlyticsCrashReporterExtensionEnabled"
        )
      }
    #endif
  }

  func testIsFeatureEnabledDefault() {
    #if canImport(CrashReportExtension)
      if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
        // By default when key is not in bundle infoDictionary, feature should be enabled
        XCTAssertTrue(CrashlyticsCrashReporterExtension.isFeatureEnabled())
      }
    #endif
  }
}
