//
//  ControlCenterView.swift
//  ControlCenterForSwiftUI
//
//  Created by Alessio Rubicini on 14/09/25.
//

import SwiftUI

struct ControlCenterView: View {
    @State private var brightness: Double = 0.65 // ~60-70% as shown in image
    @State private var volume: Double = 0.25 // ~20-30% as shown in image
    
    // State for small buttons
    @State private var isWiFiOn = true
    @State private var isFlashlightOn = false
    @State private var isAirplaneModeOn = false
    @State private var isBatterySaverOn = true
    @State private var isDarkModeOn = false
    
    var body: some View {
        ZStack {
            Image(packageResource: "ios26-wallpaper", ofType: "jpg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Small buttons grid
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(80), spacing: 20), count: 4), spacing: 20) {
                    CCButton(icon: "wifi", isOn: $isWiFiOn, iconColorOn: .cyan, iconColorOff: .white) {
                        // Handle flashlight toggle
                        print("Flashlight toggled: \(isFlashlightOn)")
                    }
                    
                    CCButton(icon: "battery.25percent", isOn: $isBatterySaverOn, iconColorOn: .yellow, iconColorOff: .white) {
                        // Handle battery saver toggle
                        print("Battery saver toggled: \(isBatterySaverOn)")
                    }
                    
                    CCButton(icon: "personalhotspot", isOn: .constant(false)) {
                        // Handle airplane mode toggle
                        print("Airplane mode toggled: \(isAirplaneModeOn)")
                    }
                    
                    CCButton(icon: "circle.lefthalf.filled", isOn: $isDarkModeOn) {
                        // Handle dark mode toggle
                        print("Dark mode toggled: \(isDarkModeOn)")
                    }
                    
                    VStack(spacing: 20) {
                        CCButton(icon: "lock.rotation", isOn: $isAirplaneModeOn, iconColorOn: .red, iconColorOff: .white) {
                            // Handle airplane mode toggle
                            print("Airplane mode toggled: \(isAirplaneModeOn)")
                        }
                        
                        CCButton(icon: "circle.lefthalf.filled", isOn: $isDarkModeOn) {
                            // Handle dark mode toggle
                            print("Dark mode toggled: \(isDarkModeOn)")
                        }
                    }
                    
                    
                    VStack(spacing: 20) {
                        CCButton(icon: "wifi", isOn: .constant(false), iconColorOn: .cyan, iconColorOff: .white) {
                            // Handle flashlight toggle
                            print("Flashlight toggled: \(isFlashlightOn)")
                        }
                        
                        CCButton(icon: "battery.25percent", isOn: $isBatterySaverOn, iconColorOn: .yellow, iconColorOff: .white) {
                            // Handle battery saver toggle
                            print("Battery saver toggled: \(isBatterySaverOn)")
                        }
                    }
                    
                    // Base icon initializer (no step icons)
                    CCVerticalSlider(
                        value: $brightness,
                        icon: "sun.max.fill",
                        zeroIcon: nil,
                        iconColorInactive: .white,
                        iconColorActive: .yellow
                    )
                    
                    // Step icons initializer (no base icon)
                    CCVerticalSlider(
                        value: $volume,
                        zeroIcon: "speaker.slash.fill",
                        iconColorInactive: .white,
                        iconColorActive: .cyan,
                        stepIcons: [
                            CCVerticalSlider.StepIcon(threshold: 0.01, symbolName: "speaker.wave.1.fill"),
                            CCVerticalSlider.StepIcon(threshold: 0.33, symbolName: "speaker.wave.2.fill"),
                            CCVerticalSlider.StepIcon(threshold: 0.66, symbolName: "speaker.wave.3.fill")
                        ]
                    )
                    
                    CCButton(icon: "flashlight.on.fill", isOn: $isFlashlightOn) {
                        // Handle flashlight toggle
                        print("Flashlight toggled: \(isFlashlightOn)")
                    }
                    
                    CCButton(icon: "ruler.fill", isOn: .constant(false), iconColorOn: .black, iconColorOff: .white) {
                        // Handle battery saver toggle
                        print("Battery saver toggled: \(isBatterySaverOn)")
                    }
                    
                    CCButton(icon: "airplane", isOn: .constant(false), iconColorOn: .orange, iconColorOff: .white) {
                        // Handle airplane mode toggle
                        print("Airplane mode toggled: \(isAirplaneModeOn)")
                    }
                    
                    CCButton(icon: "circle.lefthalf.filled", isOn: $isDarkModeOn) {
                        // Handle dark mode toggle
                        print("Dark mode toggled: \(isDarkModeOn)")
                    }
                }

            }.padding()
        }
    }
}

#Preview {
    ControlCenterView()
}

