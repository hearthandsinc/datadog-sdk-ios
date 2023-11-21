/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-Present Datadog, Inc.
 */

#if os(iOS)
import Foundation
import DatadogInternal

internal struct ResourceRequestBuilder: FeatureRequestBuilder {
    /// Custom URL for uploading data to.
    let customUploadURL: URL?
    /// Sends telemetry through sdk core.
    let telemetry: Telemetry
    /// Builds multipart form for request's body.
    var multipartBuilder: MultipartFormDataBuilder = MultipartFormData(boundary: UUID())

    func request(for events: [Event], with context: DatadogContext) throws -> URLRequest {
        let decoder = JSONDecoder()
        let resources = try events.map { event in
            try decoder.decode(CodableResource.self, from: event.data)
        }
        return try createRequest(resources: resources, context: context)
    }

    private func createRequest(resources: [CodableResource], context: DatadogContext) throws -> URLRequest {
        var multipart = multipartBuilder

        let builder = URLRequestBuilder(
            url: url(with: context),
            queryItems: [],
            headers: [
                .contentTypeHeader(contentType: .multipartFormData(boundary: multipart.boundary.uuidString)),
                .userAgentHeader(appName: context.applicationName, appVersion: context.version, device: context.device),
                .ddAPIKeyHeader(clientToken: context.clientToken),
                .ddEVPOriginHeader(source: context.source),
                .ddEVPOriginVersionHeader(sdkVersion: context.sdkVersion),
                .ddRequestIDHeader(),
            ],
            telemetry: telemetry
        )

        resources.forEach {
            multipart.addFormData(
                name: "image",
                filename: $0.identifier,
                data: $0.data,
                mimeType: "image/png"
            )
        }
        if let context = resources.first?.context, let data = try? JSONEncoder().encode(context) {
            multipart.addFormData(
                name: "event",
                filename: "blob",
                data: data,
                mimeType: "application/json"
            )
        }

        return builder.uploadRequest(with: multipart.data, compress: false)
    }

    private func url(with context: DatadogContext) -> URL {
        customUploadURL ?? context.site.endpoint.appendingPathComponent("api/v2/replay")
    }
}

internal struct CodableResource: Codable, Hashable, Resource {
    internal struct Context: Codable, Equatable {
        internal struct Application: Codable, Equatable {
            let id: String
        }
        let type: String
        let application: Application

        init(_ applicationId: String) {
            self.type = "resource"
            self.application = .init(id: applicationId)
        }
    }
    internal var identifier: String
    internal var data: Data
    internal var context: Context

    internal init(resource: Resource, context: Context) {
        self.identifier = resource.identifier
        self.data = resource.data
        self.context = context
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
#endif
