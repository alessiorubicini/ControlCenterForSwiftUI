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
    
    // State for small buttons (each independent)
    @State private var isWiFiOn = true
    @State private var isBluetoothOn = true
    @State private var isAirplaneModeOn = false
    @State private var isCellularOn = true
    @State private var isFocusOn = false
    @State private var isOrientationLockOn = false
    @State private var isFlashlightOn = false
    @State private var isTimerOn = false
    @State private var isVpnOn = false
    @State private var isCameraOn = false
    @State private var isDarkModeOn = false
    @State private var isLowPowerOn = false
    @State private var isHotspotOn = false
    
    var body: some View {
        ZStack {
            Image(packageResource: "ios26-wallpaper", ofType: "jpg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Small buttons grid
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(80), spacing: 20), count: 4), spacing: 20) {
                    // Connectivity
                    CCButton(icon: "airplane", isOn: $isAirplaneModeOn, iconColorOn: .orange, iconColorOff: .white) {
                        print("Airplane Mode: \(isAirplaneModeOn)")
                    }
                    CCButton(icon: "antenna.radiowaves.left.and.right", isOn: $isCellularOn, iconColorOn: .green, iconColorOff: .white) {
                        print("Cellular: \(isCellularOn)")
                    }
                    CCButton(icon: "wifi", isOn: $isWiFiOn, iconColorOn: .cyan, iconColorOff: .white) {
                        print("Wi‑Fi: \(isWiFiOn)")
                    }
                    CCButton(icon: "personalhotspot", isOn: $isHotspotOn, iconColorOn: .green, iconColorOff: .white) {
                        print("Personal Hotspot: \(isHotspotOn)")
                    }

                    VStack(spacing: 20) {
                        // Focus & orientation
                        CCButton(icon: "moon.fill", isOn: $isFocusOn, iconColorOn: .purple, iconColorOff: .white) {
                            print("Focus: \(isFocusOn)")
                        }
                        CCButton(icon: "lock.rotation", isOn: $isOrientationLockOn, iconColorOn: .red, iconColorOff: .white) {
                            print("Orientation Lock: \(isOrientationLockOn)")
                        }
                    }
                    
                    VStack(spacing: 20) {
                        // Appearance & power stacked for alignment
                        CCButton(icon: "circle.lefthalf.filled", isOn: $isDarkModeOn, iconColorOn: .yellow, iconColorOff: .white) {
                            print("Dark Mode: \(isDarkModeOn)")
                        }
                        CCButton(icon: "battery.25percent", isOn: $isLowPowerOn, iconColorOn: .yellow, iconColorOff: .white) {
                            print("Low Power Mode: \(isLowPowerOn)")
                        }
                    }

                    // Sliders
                    CCVerticalSlider(
                        value: $brightness,
                        icon: "sun.max.fill",
                        zeroIcon: nil,
                        iconColorInactive: .white,
                        iconColorActive: .yellow
                    )
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

                    // Utilities
                    CCButton(icon: "flashlight.on.fill", isOn: $isFlashlightOn, iconColorOn: .yellow, iconColorOff: .white) {
                        print("Flashlight: \(isFlashlightOn)")
                    }
                    CCButton(icon: "timer", isOn: $isTimerOn, iconColorOn: .orange, iconColorOff: .white) {
                        print("Timer: \(isTimerOn)")
                    }
                    CCButton(icon: "network", isOn: $isVpnOn, iconColorOn: .orange, iconColorOff: .white) {
                        print("VPN: \(isVpnOn)")
                    }
                    CCButton(icon: "camera.fill", isOn: $isCameraOn, iconColorOn: .white, iconColorOff: .white) {
                        print("Camera: \(isCameraOn)")
                    }

                
                }
                
                Spacer()

            }.padding(50)
            
            
        }
    }
}

#Preview {
    ControlCenterView()
}

