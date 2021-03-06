//
//  Achtung+Manager.swift
//  
//
//  Created by ben on 8/13/20.
//

#if canImport(Combine)
import SwiftUI
import Combine

@available(OSX 10.15, iOS 13.0, *)
extension Achtung {
	public static let manager = Manager()
	
	public class Manager: ObservableObject {
		public init() {
			
		}
		
		@Published var pendingAlerts: [Achtung] = []
		
        public func show(title: Text? = nil, message: Text? = nil, fieldText: Binding<String>? = nil, fieldPlaceholder: String = "", tag: String? = nil, buttons: [Achtung.Button]) {
			guard title != nil || message != nil || buttons.isEmpty == false else { return }
			
			let alert = Achtung(achtung: self, title: title, message: message, fieldText: fieldText, fieldPlaceholder: fieldPlaceholder, tag: tag, buttons: buttons)
			DispatchQueue.main.async {
				if self.pendingAlerts.isEmpty {
					withAnimation() {
						self.pendingAlerts.append(alert)
					}
				} else {
					self.pendingAlerts.append(alert)
				}
			}
		}
		
		func remove(_ pending: Achtung) {
			if let index = self.pendingAlerts.firstIndex(of: pending) {
				_ = withAnimation() {
					self.pendingAlerts.remove(at: index)
				}
			}
		}
	}
	
	public struct Button: Identifiable {
		public enum Kind { case normal, cancel, destructive }
		public let id: String = UUID().uuidString
		public let label: Text
		public let kind: Kind
		public let action: (() -> Void)?
		
		func pressed() {
			self.action?()
		}
		
		public static func `default`(_ label: Text, action: (() -> Void)? = {}) -> Button {
			Button(label: label, kind: .normal, action: action)
		}
		
		public static func cancel(_ label: Text = Text("Cancel"), action: (() -> Void)? = {}) -> Button {
			Button(label: label, kind: .cancel, action: action)
		}
		
		public static func destructive(_ label: Text, _ action: (() -> Void)? = {}) -> Button {
			Button(label: label, kind: .destructive, action: action)
		}

	}
}

@available(OSX 10.15, iOS 13.0, *)
public protocol AchtungAlertableView: View {
	var achtung: Achtung.Manager? { get }
}

@available(OSX 10.15, iOS 13.0, *)
extension AchtungAlertableView {
	public func achtung(title: Text? = nil, message: Text? = nil, tag: String? = nil, buttons: [Achtung.Button]) {
		(achtung ?? Achtung.manager).show(title: title, message: message, tag: tag, buttons: buttons)
	}
}


@available(OSX 10.15, iOS 13.0, *)
public struct AchtungKey: EnvironmentKey {
	public static let defaultValue: Achtung.Manager? = nil
}

@available(OSX 10.15, iOS 13.0, *)
public extension EnvironmentValues {
	var achtung: Achtung.Manager? {
		get { return self[AchtungKey.self] }
		set { self[AchtungKey.self] = newValue }
	}
}

#endif
