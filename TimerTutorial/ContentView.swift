//
//  ContentView.swift
//  TimerTutorial
//
//  Created by Robert Martinez on 1/24/24.
//

import Combine
import SwiftUI

struct ContentView: View {
    @State private var timeRemaining = 60
    @State private var showAlert = false
    @State private var isTimerRunning = false
    @State private var timer: AnyCancellable?
    @State private var selectedDuration = 60

    let durationRange = Array(20...100)

    var body: some View {
        VStack(spacing: 20) {
            Text("Time Remaining: \(timeRemaining)")
                .font(.title)

            Button(isTimerRunning ? "Pause Timer" : "Resume Timer") {
                pauseOrResumeTimer()
            }
            .font(.title2)

            Button("Cancel Timer", action: cancelTimer)
                .font(.title2)

                .onChange(of: selectedDuration) {
                    resetTimer()
                }

            Button("Start Timer", action: startTimer)

            Picker("Duraction", selection: $selectedDuration) {
                ForEach(durationRange, id: \.self) { duration in
                    Text("\(duration) seconds")
                }
            }

        }
        .alert("Time's Up!", isPresented: $showAlert, presenting: timeRemaining) { _ in
            Button("OK", role: .cancel) { }
        } message: { _ in
            Text("The one-minute timer has finished")
        }
        .onDisappear {
            self.timer?.cancel()
        }
    }

    func startTimer() {
        isTimerRunning = true
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                showAlert = true
                isTimerRunning = false
                timer?.cancel()
            }
        }
    }

    func cancelTimer() {
        timer?.cancel()
        isTimerRunning = false
        timeRemaining = selectedDuration
    }

    func pauseOrResumeTimer() {
        isTimerRunning.toggle()
        if isTimerRunning && timeRemaining > 0 {
            startTimer()
        } else {
            timer?.cancel()
        }
    }

    func resetAndStartTimer() {
        timeRemaining = selectedDuration
        startTimer()
    }

    func resetTimer() {
        timeRemaining = selectedDuration
        isTimerRunning = false
    }
}

#Preview {
    ContentView()
}
