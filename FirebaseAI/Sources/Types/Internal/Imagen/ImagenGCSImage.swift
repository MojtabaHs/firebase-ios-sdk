// Copyright 2024 Google LLC
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

/// An image generated by Imagen, stored in Cloud Storage (GCS) for Firebase.
///
/// TODO(#14451): Make this `public` and move to the `Public` directory when ready.
@available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, *)
struct ImagenGCSImage: Sendable {
  /// The IANA standard MIME type of the image file; either `"image/png"` or `"image/jpeg"`.
  ///
  /// > Note: To request a different format, set ``ImagenGenerationConfig/imageFormat`` in
  ///   your ``ImagenGenerationConfig``.
  public let mimeType: String

  /// The URI of the file in Cloud Storage (GCS) for Firebase.
  ///
  /// This is a `"gs://"`-prefixed URI , for example, `"gs://bucket-name/path/sample_0.jpg"`.
  public let gcsURI: String

  init(mimeType: String, gcsURI: String) {
    self.mimeType = mimeType
    self.gcsURI = gcsURI
  }
}

@available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, *)
extension ImagenGCSImage: ImagenImageRepresentable {
  // TODO(andrewheard): Make this public when the SDK supports Imagen operations that take images as
  // input (upscaling / editing).
  var _internalImagenImage: _InternalImagenImage {
    _InternalImagenImage(mimeType: mimeType, bytesBase64Encoded: nil, gcsURI: gcsURI)
  }
}

@available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, *)
extension ImagenGCSImage: Equatable {}

// MARK: - Codable Conformances

@available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, *)
extension ImagenGCSImage: Decodable {
  enum CodingKeys: String, CodingKey {
    case mimeType
    case gcsURI = "gcsUri"
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let mimeType = try container.decode(String.self, forKey: .mimeType)
    let gcsURI = try container.decode(String.self, forKey: .gcsURI)
    self.init(mimeType: mimeType, gcsURI: gcsURI)
  }
}
