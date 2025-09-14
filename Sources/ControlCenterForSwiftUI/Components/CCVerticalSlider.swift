//
//  ControlCenterVerticalSlider.swift
//  ControlCenterForSwiftUI
//
//  Created by Alessio Rubicini on 14/09/25.
//

import SwiftUI

struct CCVerticalSlider: View {
    
    @Binding var value: Double
    let icon: String
    let iconColorOutside: Color
    let iconColorInside: Color
    let glassEffect: Glass = .regular
    
    // Static threshold for color change
    private static let colorChangeThreshold: Double = 0.15
    
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
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(value > Self.colorChangeThreshold ? iconColorInside : iconColorOutside)
                    .animation(.easeInOut(duration: 0.2), value: value > Self.colorChangeThreshold)
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


