//
//  pulsarTests.swift
//  pulsarTests
//
//  Created by Ali El Ali on 8/12/2024.
//

import Testing
@testable import pulsar
import QuartzCore

struct PulseAnimationLibraryTests {

    @Test func testPulseViewInitialization() async throws {
        let pulseView = await PulseView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
         #expect(pulseView != nil)
        await #expect(pulseView.backgroundColor == .clear)
    }

    @Test func testStartPulsing() async throws {
        let pulseView = await PulseView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        await pulseView.startPulsing()
        await #expect(pulseView.layer.sublayers?.first is CAShapeLayer)
    }

    @Test func testStopPulsing() async throws {
        let pulseView = await PulseView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        await pulseView.startPulsing()
        await pulseView.stopPulsing()
        await #expect(pulseView.layer.sublayers?.first is CAShapeLayer == false)
    }
}
