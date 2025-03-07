//
//  ContentView.swift
//  CapcakeCorner
//
//  Created by Eugène Kiriloff on 04/03/2025.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
  @State private var hapticEngine: CHHapticEngine?
  var body: some View {
    Button("Call haptics", action: complexSuccess)
      .onAppear(perform: startHapticEngine)
  }

  private func startHapticEngine() {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
      return
    }
    do {
      hapticEngine = try CHHapticEngine()
      try hapticEngine?.start()
    } catch {
      print("Failed to create haptic engine: \(error)")
    }
  }

  private func complexSuccess() {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
      return
    }

    var events = [CHHapticEvent]()

    for i in stride(from: 0, to: 1, by: 0.1) {
      let intencity = CHHapticEventParameter(
        parameterID: .hapticIntensity,
        value: Float(i)
      )
      let sharpness = CHHapticEventParameter(
        parameterID: .hapticSharpness,
        value: Float(i)
      )
      let event = CHHapticEvent(
        eventType: .hapticTransient,
        parameters: [intencity, sharpness],
        relativeTime: i
      )
      events.append(event)
    }

    for i in stride(from: 0, to: 1, by: 0.1) {
      let intencity = CHHapticEventParameter(
        parameterID: .hapticIntensity,
        value: Float(1 - i)
      )
      let sharpness = CHHapticEventParameter(
        parameterID: .hapticSharpness,
        value: Float(1 - i)
      )
      let event = CHHapticEvent(
        eventType: .hapticTransient,
        parameters: [intencity, sharpness],
        relativeTime: 1 + i
      )
      events.append(event)
    }

    do {
      let pattern = try CHHapticPattern(events: events, parameters: [])
      let player = try hapticEngine?.makePlayer(with: pattern)
      try player?.start(atTime: .zero)
    } catch {
      print(error.localizedDescription)
    }
  }
}

#Preview {
  ContentView()
}
