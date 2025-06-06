// Copyright 2025 Google LLC
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

import XCTest

@testable import FirebaseAI

@available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, *)
final class RequestOptionsTests: XCTestCase {
  let defaultTimeout: TimeInterval = 180.0

  func testInitialize_defaultValues() {
    let requestOptions = RequestOptions()

    XCTAssertEqual(requestOptions.timeout, defaultTimeout)
  }

  func testInitialize_timeout() {
    let expectedTimeout = 60.0

    let requestOptions = RequestOptions(timeout: expectedTimeout)

    XCTAssertEqual(requestOptions.timeout, expectedTimeout)
  }
}
