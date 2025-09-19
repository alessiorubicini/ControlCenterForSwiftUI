//
//  ControlCenterVerticalSlider.swift
//  ControlCenterForSwiftUI
//
//  Created by Alessio Rubicini on 14/09/25.
//

import SwiftUI

struct CCVerticalSlider: View {
    
    @Binding var value: Double
    let icon: String? // Optional to support the stepIcons-only initializer
    let zeroIcon: String?
    let iconColorInactive: Color
    let iconColorActive: Color
    let glassEffect: Glass
    
    /// Optional icons mapped to thresholds of `value` in the range 0...1.
    /// The icon for the highest threshold less than or equal to `value` is used.
    /// Example: [(0.01, "speaker.wave.1.fill"), (0.33, "speaker.wave.2.fill"), (0.66, "speaker.wave.3.fill")]
    struct StepIcon {
        let threshold: Double
        let symbolName: String
        
        init(threshold: Double, symbolName: String) {
            self.threshold = threshold
            self.symbolName = symbolName
        }
    }
    let stepIcons: [StepIcon]
    
    /// Creates a vertical slider that displays a single base icon.
    ///
    /// Use this initializer when you want a consistent icon regardless of value.
    /// If `zeroIcon` is provided, it is shown when the value is effectively zero.
    ///
    /// - Parameters:
    ///   - value: A binding to the slider's normalized value in the range 0...1.
    ///   - icon: The SF Symbol name shown at the bottom of the slider.
    ///   - zeroIcon: Optional SF Symbol shown when the value is near zero.
    ///   - iconColorInactive: Icon color when the filled area is below the internal threshold.
    ///   - iconColorActive: Icon color when the filled area exceeds the internal threshold.
    ///   - glassEffect: The glass effect style applied to the slider track.
    init(
        value: Binding<Double>,
        icon: String,
        zeroIcon: String? = nil,
        iconColorInactive: Color,
        iconColorActive: Color,
        glassEffect: Glass = .regular
    ) {
        self._value = value
        self.icon = icon
        self.zeroIcon = zeroIcon
        self.iconColorInactive = iconColorInactive
        self.iconColorActive = iconColorActive
        self.glassEffect = glassEffect
        self.stepIcons = []
    }
    
    /// Creates a vertical slider that changes its icon based on value thresholds.
    ///
    /// Use this initializer to provide a set of step icons that progress as the value increases.
    /// The icon for the highest `threshold` less than or equal to the current value is used;
    /// when the value is greater than zero but below the first threshold, the first step icon is shown.
    /// If `zeroIcon` is provided, it is shown when the value is effectively zero.
    ///
    /// - Parameters:
    ///   - value: A binding to the slider's normalized value in the range 0...1.
    ///   - zeroIcon: Optional SF Symbol shown when the value is near zero.
    ///   - iconColorInactive: Icon color when the filled area is below the internal threshold.
    ///   - iconColorActive: Icon color when the filled area exceeds the internal threshold.
    ///   - glassEffect: The glass effect style applied to the slider track.
    ///   - stepIcons: An ordered list of `(threshold, symbolName)` pairs. Thresholds are clamped to 0...1 and sorted ascending.
    init(
        value: Binding<Double>,
        zeroIcon: String? = nil,
        iconColorInactive: Color,
        iconColorActive: Color,
        glassEffect: Glass = .regular,
        stepIcons: [StepIcon]
    ) {
        self._value = value
        self.icon = nil
        self.zeroIcon = zeroIcon
        self.iconColorInactive = iconColorInactive
        self.iconColorActive = iconColorActive
        self.glassEffect = glassEffect
        // Ensure thresholds are clamped to 0...1 and sorted ascending for predictable behavior
        self.stepIcons = stepIcons
            .map { StepIcon(threshold: min(max($0.threshold, 0), 1), symbolName: $0.symbolName) }
            .sorted { $0.threshold < $1.threshold }
    }
    
    
    
    // Static threshold for color change
    private static let colorChangeThreshold: Double = 0.20
    // Treat very small values as zero for icon purposes
    private static let zeroEpsilon: Double = 0.001
    
    // New state variable to track the drag's "overshoot" for progressive stretching.
    @State private var dragOffset: CGFloat = 0
    
    // Define slider dimensions and corner radius.
    private var sliderWidth: CGFloat { 80 }
    private var sliderHeight: CGFloat { 170 }
    private var cornerRadius: CGFloat { 40 }
    
    // A computed property to determine the scale factor based on the drag offset.
    // The scale factor increases progressively as dragOffset increases,
    // and is capped at 1.1 to prevent excessive stretching.
    private var scaleFactor: CGFloat {
        1.0 + min(abs(dragOffset) * 0.005, 0.1)
    }
    
    // A computed property to set the anchor point for the scaling effect.
    // This ensures the stretching happens from the correct end of the slider.
    private var scaleAnchor: UnitPoint {
        // If dragOffset is positive (dragged past the top boundary), anchor at the bottom.
        if dragOffset > 0 {
            return .bottom
        // If dragOffset is negative (dragged past the bottom boundary), anchor at the top.
        } else if dragOffset < 0 {
            return .top
        // Otherwise, the drag is within bounds, so the anchor is in the center.
        } else {
            return .center
        }
    }
    
    // Decide which icon to show based on current value and step icons
    private var currentIconName: String {
        // Near-zero uses zeroIcon when available
        if value <= Self.zeroEpsilon, let zeroIcon = zeroIcon { return zeroIcon }
        
        if !stepIcons.isEmpty {
            // Find the last step whose threshold is <= value
            var chosen: String? = nil
            for step in stepIcons {
                if value >= step.threshold {
                    chosen = step.symbolName
                } else {
                    break
                }
            }
            // If none matched but value > 0, use the first step icon (covers values below first threshold)
            return chosen ?? stepIcons.first!.symbolName
        }
        
        // Fall back to base icon when using the base-icon initializer
        return icon ?? ""
    }
    
    var body: some View {
        ZStack {
            // Background track
            RoundedRectangle(cornerRadius: cornerRadius)
                .frame(width: sliderWidth, height: sliderHeight)
                .glassEffect(glassEffect)
            
            // Active fill
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    
                    Rectangle()
                        .fill(Color(red: 0.98, green: 0.96, blue: 0.92))
                        .frame(width: geometry.size.width, height: geometry.size.height * value)
                        .animation(.easeInOut(duration: 0.1), value: value)
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            }
            
            // Icon at the bottom of the slider
            VStack {
                Spacer()
                
                Image(systemName: currentIconName)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(value > Self.colorChangeThreshold ? iconColorActive : iconColorInactive)
                    .animation(.easeInOut(duration: 0.2), value: value > Self.colorChangeThreshold)
                    .contentTransition(.symbolEffect(.replace.byLayer))
            }.padding(.bottom, 30)
        }
        .frame(width: sliderWidth, height: sliderHeight)
        // Apply the progressive scale effect with a spring animation.
        // The spring animation provides the natural, responsive feel.
        .scaleEffect(
            x: 1.0,
            y: scaleFactor,
            anchor: scaleAnchor
        )
        .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: dragOffset)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    // Calculate the new value for the slider based on the drag location, clamping it to the 0-1 range.
                    let newHeight = 1 - (gesture.location.y / sliderHeight)
                    let newValue = max(0, min(1, newHeight))
                    
                    // The dragOffset now represents the "overshoot" distance beyond the 0 or 1 boundaries.
                    // It is calculated from the unclamped 'newHeight', making the stretching progressive.
                    if newHeight > 1 {
                        // This condition is met when dragging up past the top boundary.
                        // We calculate the positive overshoot distance.
                        dragOffset = (newHeight - 1) * sliderHeight
                    } else if newHeight < 0 {
                        // This condition is met when dragging down past the bottom boundary.
                        // We calculate the negative overshoot distance.
                        dragOffset = newHeight * sliderHeight
                    } else {
                        // Reset dragOffset when the slider is within its normal range
                        dragOffset = 0
                    }
                    
                    // Update the main value, clamped between 0 and 1.
                    value = newValue
                    
                    // Haptic feedback
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                }
                .onEnded { _ in
                    // When the drag ends, reset the dragOffset to its neutral state,
                    // which causes the slider to spring back to its original scale.
                    dragOffset = 0
                }
        )
        
    }
}

