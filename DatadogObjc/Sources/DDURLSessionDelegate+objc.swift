/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-Present Datadog, Inc.
 */

import Foundation
import DatadogCore
import DatadogInternal

@objc
@available(*, deprecated, message: "Use URLSessionInstrumentation instead.")
open class DDNSURLSessionDelegate: NSObject, URLSessionTaskDelegate, URLSessionDataDelegate {
    @objc
    override public init() {
        URLSessionInstrumentation.enable(
            with: .init(
                delegateClass: DatadogURLSessionDelegate.self
            ),
            in: CoreRegistry.default
        )
        super.init()
    }

    @objc
    public init(additionalFirstPartyHostsWithHeaderTypes: [String: Set<DDTracingHeaderType>]) {
        let firstPartyHosts = additionalFirstPartyHostsWithHeaderTypes.mapValues { tracingHeaderTypes in
            return Set(tracingHeaderTypes.map { $0.swiftType })
        }
        URLSessionInstrumentation.enable(
            with: .init(
                delegateClass: DatadogURLSessionDelegate.self,
                firstPartyHostsTracing: .traceWithHeaders(hostsWithHeaders: firstPartyHosts)
            ),
            in: CoreRegistry.default
        )
        super.init()
    }

    @objc
    public convenience init(additionalFirstPartyHosts: Set<String>) {
        self.init(
            additionalFirstPartyHostsWithHeaderTypes: additionalFirstPartyHosts.reduce(into: [:], { partialResult, host in
                partialResult[host] = [.datadog]
            })
        )
    }
}
