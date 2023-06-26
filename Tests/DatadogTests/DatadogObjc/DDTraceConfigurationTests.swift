/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-Present Datadog, Inc.
 */

import XCTest
import TestUtilities
@testable import DatadogTrace
@testable import DatadogObjc

class DDTraceConfigurationTests: XCTestCase {
    private var objc = DDTraceConfiguration()
    private var swift: Trace.Configuration { objc.swiftConfig }

    func testSampleRate() {
        objc.sampleRate = 30
        XCTAssertEqual(objc.sampleRate, 30)
        XCTAssertEqual(swift.sampleRate, 30)
    }

    func testService() {
        objc.service = "custom-service"
        XCTAssertEqual(objc.service, "custom-service")
        XCTAssertEqual(swift.service, "custom-service")
    }

    func testTags() {
        let random = mockRandomAttributes()
        objc.tags = random
        DDAssertDictionariesEqual(objc.tags!, random)
        DDAssertReflectionEqual(swift.tags!, castAttributesToSwift(random))
    }

    func testSetDDTraceURLSessionTracking() {
        var tracking: DDTraceURLSessionTracking

        tracking = DDTraceURLSessionTracking(firstPartyHostsTracing: .init(hosts: ["foo.com"]))
        objc.setURLSessionTracking(tracking)
        DDAssertReflectionEqual(swift.urlSessionTracking, .init(firstPartyHostsTracing: .trace(hosts: ["foo.com"])))

        tracking = DDTraceURLSessionTracking(firstPartyHostsTracing: .init(hosts: ["foo.com"], sampleRate: 99))
        objc.setURLSessionTracking(tracking)
        DDAssertReflectionEqual(swift.urlSessionTracking, .init(firstPartyHostsTracing: .trace(hosts: ["foo.com"], sampleRate: 99)))

        tracking = DDTraceURLSessionTracking(firstPartyHostsTracing: .init(hostsWithHeaderTypes: ["foo.com": [.b3, .datadog]]))
        objc.setURLSessionTracking(tracking)
        DDAssertReflectionEqual(swift.urlSessionTracking, .init(firstPartyHostsTracing: .traceWithHeaders(hostsWithHeaders: ["foo.com": [.b3, .datadog]])))

        tracking = DDTraceURLSessionTracking(firstPartyHostsTracing: .init(hostsWithHeaderTypes: ["foo.com": [.b3, .datadog]], sampleRate: 99))
        objc.setURLSessionTracking(tracking)
        DDAssertReflectionEqual(swift.urlSessionTracking, .init(firstPartyHostsTracing: .traceWithHeaders(hostsWithHeaders: ["foo.com": [.b3, .datadog]], sampleRate: 99)))
    }

    func testBundleWithRUM() {
        let random: Bool = .mockRandom()
        objc.bundleWithRUM = random
        XCTAssertEqual(objc.bundleWithRUM, random)
        XCTAssertEqual(swift.bundleWithRUM, random)
    }

    func testSendNetworkInfo() {
        let random: Bool = .mockRandom()
        objc.sendNetworkInfo = random
        XCTAssertEqual(objc.sendNetworkInfo, random)
        XCTAssertEqual(swift.sendNetworkInfo, random)
    }

    func testCustomEndpoint() {
        let random: URL = .mockRandom()
        objc.customEndpoint = random
        XCTAssertEqual(objc.customEndpoint, random)
        XCTAssertEqual(swift.customEndpoint, random)
    }
}
