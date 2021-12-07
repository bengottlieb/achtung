//
//  AchtungView.swift
//  
//
//  Created by ben on 8/13/20.
//

#if canImport(Combine)
import SwiftUI
import Combine

@available(OSX 10.15, iOS 13.0, *)
public class Achtung: ObservableObject {
	public static let instance = Achtung()
	var hostWindow: UIWindow?
	var toasts: [Toast] = []
	weak var nextToastTimer: Timer?

	
	@Published var currentToast: Toast?
	@Published var pendingAlerts: [Achtung.Alert] = []

	private init() {
		
	}
	
	public func setup(in scene: UIWindowScene? = nil) {
		DispatchQueue.main.async {
			self.add(toScene: scene)
		}
	}
	
	func showNextToast() {
		if currentToast == nil, let next = toasts.first {
			withAnimation(.easeOut(duration: Achtung.Toast.showDuration)) {
				currentToast = next
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + next.duration) {
				self.dismissCurrentToast()
			}
			toasts.removeFirst()
		}
	}
	
	func dismissCurrentToast() {
		if currentToast != nil {
			withAnimation(.easeIn(duration: Achtung.Toast.hideDuration)) {
				currentToast = nil
			}
			nextToastTimer = Timer.scheduledTimer(withTimeInterval: Achtung.Toast.hideDuration, repeats: false) { _ in
				self.showNextToast()
			}
		}
	}

}

//@available(OSX 10.15, iOS 13.0, *)
//public extension AchtungAlertableView {
//	func achtung<Item: Identifiable>(item target: Binding<Item?>, content: (Item) -> Achtung.Alert?) -> some View {
//		if let item = target.wrappedValue, let alert = content(item) {
//			achtung(title: alert.title, message: alert.message, tag: alert.tag, buttons: alert.buttons)
//			DispatchQueue.main.async { target.wrappedValue = nil }
//		}
//		return self
//	}
//}

#endif
