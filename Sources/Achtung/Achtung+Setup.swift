//
//  Achtung+Setup.swift
//  
//
//  Created by Ben Gottlieb on 12/6/21.
//

#if canImport(Combine)
#if os(iOS)

import SwiftUI
import Combine
import UIKit

@available(OSX 10.15, iOS 13.0, *)
public extension Achtung {
	func isSetup() -> Bool {
		if hostWindow == nil {
			print("#### Achtung was not successfully set up. Please call Achtung.instance.setup(scene:) at init time ###")
			return false
		}
		return true
	}
	
	func add(toScene: UIWindowScene?) {
		if hostWindow != nil { return }				 // already added
		guard let scene = toScene ?? firstWindowScene else {
			print("#### Unable to find a window scene, no Achtung for you! ####")
			return
		}
		
		let window = HostWindow(windowScene: scene)
		window.windowLevel = .statusBar
		window.rootViewController = UIHostingController(rootView: Achtung.Container())
		window.rootViewController?.view.backgroundColor = .clear
		window.isHidden = false
		self.hostWindow = window
	}

	var firstWindowScene: UIWindowScene? {
		UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first
	}

	class HostWindow: UIWindow {
		public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
			guard let hitView = super.hitTest(point, with: event) else { return nil }
			if !Achtung.instance.pendingAlerts.isEmpty { return hitView }
			return rootViewController?.view == hitView ? nil : hitView
		}
	}
}
#else
@available(OSX 10.15, iOS 13.0, *)
public extension Achtung {
	func setup() { }
	func isSetup() -> Bool { false }
}
#endif
#endif
