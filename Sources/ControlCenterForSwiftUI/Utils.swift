//
//  Utils.swift
//  ControlCenterForSwiftUI
//
//  Created by Alessio Rubicini on 14/09/25.
//

import SwiftUI

// These are just utils for the example view
extension Image {
    init(packageResource name: String, ofType type: String) {
        #if canImport(UIKit)
        guard let path = Bundle.module.path(forResource: name, ofType: type),
              let uiImage = UIImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(uiImage: uiImage)
        #elseif canImport(AppKit)
        guard let path = Bundle.module.path(forResource: name, ofType: type),
              let nsImage = NSImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(nsImage: nsImage)
        #else
        self.init(name)
        #endif
    }
}

