//
//  CCButton.swift
//  ControlCenterForSwiftUI
//
//  Created by Alessio Rubicini on 14/09/25.
//

import SwiftUI

/// A Control Center–style button with glass/blur aesthetics and flexible content.
///
/// CCButton renders either:
/// - a circular icon-only button, or
/// - a rounded rectangle with an icon and optional text label.
///
/// The visual state reacts to `isOn`, switching icon color and background accordingly.
/// Use `glassEffect` to control the intensity/behavior of the glass effect.
struct CCButton: View {
    let icon: String
    @Binding var isOn: Bool
    let onTap: () -> Void
    let iconColorOn: Color
    let iconColorOff: Color
    let text: String?
    let glassEffect: Glass
    
    /// Creates a Control Center–style button.
    ///
    /// - Parameters:
    ///   - icon: The SF Symbol name to display.
    ///   - isOn: Binding for the button's on/off state. Defaults to `false`.
    ///   - iconColorOn: Icon color when `isOn` is `true`. Defaults to `.white`.
    ///   - iconColorOff: Icon color when `isOn` is `false`. Defaults to `.white`.
    ///   - text: Optional label shown next to the icon. When provided, the button uses a rounded rectangle layout.
    ///   - glassEffect: The glass effect style applied to the button background. Defaults to `.regular`.
    ///   - onTap: Closure called after the on/off toggle animation completes. Defaults to no-op.
    init(
        icon: String, 
        isOn: Binding<Bool> = .constant(false), 
        iconColorOn: Color = .white,
        iconColorOff: Color = .white,
        text: String? = nil,
        glassEffect: Glass = .regular,
        onTap: @escaping () -> Void = {}
    ) {
        self.icon = icon
        self._isOn = isOn
        self.iconColorOn = iconColorOn
        self.iconColorOff = iconColorOff
        self.text = text
        self.glassEffect = glassEffect
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                isOn.toggle()
                onTap()
            }
        }) {
            if let text = text {
                RoundedRectangle(cornerRadius: 50.0)
                    .glassEffect(.clear.interactive())
                    .frame(width: 150, height: 68)
                    .overlay {
                        HStack(spacing: 10) {
                            Image(systemName: icon)
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(isOn ? iconColorOn : iconColorOff)
                            
                            Text(text)
                                .foregroundStyle(.white)
                                .fontWeight(.medium)
                        }.padding(10)
                    }
                
            } else {
                ZStack {
                    Circle()
                        .fill(isOn ? Color.white : Color.clear)
                        .frame(width: 80, height: 80)
                        .background {
                            if !isOn {
                                Circle()
                            }
                        }
                        
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(isOn ? iconColorOn : iconColorOff)
                }.glassEffect(glassEffect.interactive())
            }

        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel("\(icon) button")
        .accessibilityAddTraits(isOn ? .isSelected : [])
    }
}

#Preview("CC Small Buttons") {
    ZStack {
        // Background similar to the image
        Image(packageResource: "ios26-wallpaper", ofType: "jpg")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
        
        HStack(spacing: 20) {
            CCButton(
                icon: "battery.25percent",
                isOn: .constant(true),
                iconColorOn: .yellow,
                iconColorOff: .white
            )
            CCButton(
                icon: "flashlight.on.fill",
                isOn: .constant(true),
                iconColorOn: .orange,
                iconColorOff: .white
            )
            CCButton(
                icon: "circle.lefthalf.filled",
                isOn: .constant(false),
                iconColorOn: .yellow,
                iconColorOff: .white
            )
            CCButton(
                icon: "waveform",
                isOn: .constant(false),
                iconColorOn: .cyan,
                iconColorOff: .white
            )
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.black)
}
