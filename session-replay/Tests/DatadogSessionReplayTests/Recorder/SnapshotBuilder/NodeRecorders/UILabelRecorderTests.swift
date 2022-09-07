/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import XCTest
@testable import DatadogSessionReplay

// swiftlint:disable opening_brace
class UILabelRecorderTests: XCTestCase {
    private let recorder = UILabelRecorder()
    /// The label under test.
    private let label = UILabel()
    /// `ViewAttributes` simulating common attributes of label's `UIView`.
    private var viewAttributes: ViewAttributes = .mockAny()

    func testWhenLabelHasNoTextAndNoAppearance() throws {
        // When
        oneOf([
            { self.label.text = nil },
            { self.label.text = "" },
        ])
        viewAttributes = .mockWith(hasAnyAppearance: false)

        // Then
        let semantics = try XCTUnwrap(recorder.semantics(of: label, with: viewAttributes, in: .mockAny()))
        XCTAssertTrue(semantics is InvisibleElement)
        XCTAssertNil(semantics.wireframesBuilder)
    }

    func testWhenLabelHasTextOrAppearance() throws {
        // When
        oneOf([
            {
                self.label.text = .mockRandom()
                self.viewAttributes = .mockWith(hasAnyAppearance: true)
            },
            {
                self.label.text = nil
                self.viewAttributes = .mockWith(hasAnyAppearance: true)
            },
            {
                self.label.text = .mockRandom()
                self.viewAttributes = .mockWith(hasAnyAppearance: false)
            },
        ])

        // Then
        let semantics = try XCTUnwrap(recorder.semantics(of: label, with: viewAttributes, in: .mockAny()))
        XCTAssertTrue(semantics is SpecificElement)

        let builder = try XCTUnwrap(semantics.wireframesBuilder as? UILabelWireframesBuilder)
        XCTAssertEqual(builder.attributes, viewAttributes)
        XCTAssertEqual(builder.text, label.text ?? "")
        XCTAssertEqual(builder.textColor, label.textColor?.cgColor)
        XCTAssertEqual(builder.font, label.font)
    }

    func testWhenViewIsNotOfExpectedType() {
        // When
        let view = UITextField()

        // Then
        XCTAssertNil(recorder.semantics(of: view, with: viewAttributes, in: .mockAny()))
    }
}
// swiftlint:enable opening_brace
