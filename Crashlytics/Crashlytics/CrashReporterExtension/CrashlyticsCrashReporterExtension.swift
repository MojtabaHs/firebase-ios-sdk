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

import Foundation

#if canImport(CrashReportExtension)
import CrashReportExtension

/// Protocol that Crash Report Extensions can conform to for automatic Firebase Crashlytics integration.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public protocol FirebaseCrashReporterExtension: CrashReporterExtension {}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public extension FirebaseCrashReporterExtension {
  /// Default implementation delegating crash report processing to Crashlytics.
  func processCrashReport(process: CrashedProcess) {
    CrashlyticsCrashReporterExtension.handleCrashReport(process: process)
  }
}

/// Helper struct for handling out-of-process crash reports from Apple's `CrashReportExtension` framework.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public struct CrashlyticsCrashReporterExtension {

  /// Key in Info.plist used to toggle CrashReporterExtension integration.
  public static let crashReporterExtensionEnabledKey = "FirebaseCrashlyticsCrashReporterExtensionEnabled"

  /// Handles a crash report received via Apple's `CrashReporterExtension`.
  ///
  /// - Parameter process: The `CrashedProcess` object provided by the system when a crash occurs.
  /// - Returns: `true` if the report was processed, `false` if the feature was disabled or processing failed.
  @discardableResult
  public static func handleCrashReport(process: CrashedProcess) -> Bool {
    guard isFeatureEnabled() else {
      print("[FirebaseCrashlytics] CrashReporterExtension processing is disabled by feature flag.")
      return false
    }

    // Extract diagnostic info from the crashed process
    let pid = process.processIdentifier
    let bundleID = process.bundleIdentifier ?? "unknown"
    let reason = process.terminationReason ?? "unknown"

    print("[FirebaseCrashlytics] Processing crash report for PID: \(pid), Bundle: \(bundleID), Reason: \(reason)")

    // Format and persist the crash record into Crashlytics storage
    let crashData: [String: Any] = [
      "pid": pid,
      "bundle_id": bundleID,
      "reason": reason,
      "timestamp": Date().timeIntervalSince1970,
      "source": "CrashReporterExtension"
    ]

    return recordCrashReportData(crashData)
  }

  /// Evaluates whether CrashReporterExtension handling is enabled.
  public static func isFeatureEnabled() -> Bool {
    if let plistValue = Bundle.main.infoDictionary?[crashReporterExtensionEnabledKey] as? Bool {
      return plistValue
    }
    if let stringValue = Bundle.main.infoDictionary?[crashReporterExtensionEnabledKey] as? String {
      return (stringValue as NSString).boolValue
    }
    return true
  }

  /// Internal helper to persist crash report data.
  private static func recordCrashReportData(_ data: [String: Any]) -> Bool {
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
      let tempDir = FileManager.default.temporaryDirectory
      let reportURL = tempDir.appendingPathComponent("crash_reporter_ext_\(UUID().uuidString).json")
      try jsonData.write(to: reportURL)
      return true
    } catch {
      print("[FirebaseCrashlytics] Failed to record crash report data: \(error)")
      return false
    }
  }
}
#endif
