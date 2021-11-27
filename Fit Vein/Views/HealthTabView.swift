//
//  HealthTabView.swift
//  Fit Vein
//
//  Created by Łukasz Janiszewski on 25/10/2021.
//

import SwiftUI
import HealthKit

struct HealthTabView: View {
    @ObservedObject private var healthKitViewModel = HealthKitViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
        
            NavigationView {
                VStack(spacing: screenHeight * 0.05) {
                    HStack {
                        Spacer()
                        tileView(tileNumber: 0, tileName: "Steps", tileImage: "flame.fill", tileValue: healthKitViewModel.stepCount.last == nil ? "No Data" : "\(healthKitViewModel.value(from: healthKitViewModel.stepCount.last!.stat).value) \(healthKitViewModel.value(from: healthKitViewModel.stepCount.last!.stat).units)")
                        Spacer()
                        tileView(tileNumber: 1, tileName: "Calories", tileImage: "flame.fill", tileValue: healthKitViewModel.activeEnergyBurned.last == nil ? "No Data" : "\(healthKitViewModel.value(from: healthKitViewModel.activeEnergyBurned.last!.stat).value) \(healthKitViewModel.value(from: healthKitViewModel.activeEnergyBurned.last!.stat).units)")
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        tileView(tileNumber: 2, tileName: "Distance", tileImage: "flame.fill", tileValue: healthKitViewModel.distanceWalkingRunning.last == nil ? "No Data" : "\(healthKitViewModel.value(from: healthKitViewModel.distanceWalkingRunning.last!.stat).value) \(healthKitViewModel.value(from: healthKitViewModel.distanceWalkingRunning.last!.stat).units)")
                        Spacer()
                        tileView(tileNumber: 3, tileName: "Workout Time", tileImage: "timer", tileValue: healthKitViewModel.appleExerciseTime.last == nil ? "No Data" : "\(healthKitViewModel.value(from: healthKitViewModel.appleExerciseTime.last!.stat).value) \(healthKitViewModel.value(from: healthKitViewModel.appleExerciseTime.last!.stat).units)")
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        tileView(tileNumber: 4, tileName: "Pulse", tileImage: "heart.fill", tileValue: healthKitViewModel.heartRate.last == nil ? "No Data" : "\(healthKitViewModel.value(from: healthKitViewModel.heartRate.last!.stat).value) \(healthKitViewModel.value(from: healthKitViewModel.heartRate.last!.stat).units)")
                        Spacer()
                    }
                }
                .navigationTitle("Health Data")
                .navigationBarHidden(false)
            }
        }
    }
    
    struct tileView: View {
        private var tileNumber: Int
        private var tileName: String
        private var tileImage: String
        private var tileValue: String
        
        init(tileNumber: Int, tileName: String, tileImage: String, tileValue: String) {
            self.tileNumber = tileNumber
            self.tileName = tileName
            self.tileImage = tileImage
            self.tileValue = tileValue
        }
        
        var body: some View {
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                let screenHeight = geometry.size.height
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .frame(height: screenHeight)
                        .foregroundColor([0, 3, 4].contains(tileNumber) ? .green : Color(UIColor.systemGray5))
                    
                    VStack {
                        HStack {
                            Image(systemName: tileImage)
                            Text(tileName)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack {
                            Text(tileValue.contains("km") ? tileValue : tileValue.removeCharactersFromString(string: tileValue, character: ".", before: false, upToCharacter: " "))
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                    }
                    .foregroundColor([0, 3, 4].contains(tileNumber) ? Color(UIColor.systemGray5) : .green)
                    .padding()
                }
                .padding()
                .opacity(0.9)
            }
        }
    }
}

struct HealthTabView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone XS MAX", "iPhone 8"], id: \.self) { deviceName in
                HealthTabView()
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName(deviceName)
            }
        }
    }
}
