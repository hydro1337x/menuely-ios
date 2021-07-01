//
//  ApplicationEventsHandler.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 01.07.2021..
//

import UIKit
import Combine
import Resolver

struct ApplicationEventsHandler {
    @Injected private var appState: Store<AppState>
    private var cancelBag = CancelBag()
    
    init() {
        setupKeyboardHeightObserver()
        setupSceneDidBecomeActiveObserver()
        setupSceneWillResignActiveObserver()
    }
    
    private func setupKeyboardHeightObserver() {
        NotificationCenter.default.keyboardHeightPublisher
            .sink { [appState] height in
                appState[\.application.keyboardHeight] = height
            }
            .store(in: cancelBag)
    }
    
    private func setupSceneDidBecomeActiveObserver() {
        NotificationCenter.default.sceneDidBecomeActivePublisher.sink { [appState] _ in
            appState[\.application.isActive] = true
        }
        .store(in: cancelBag)
    }
    
    private func setupSceneWillResignActiveObserver() {
        NotificationCenter.default.sceneWillResignActivePublisher.sink { [appState] _ in
            appState[\.application.isActive] = false
        }
        .store(in: cancelBag)
    }
}

// MARK: - Notifications

private extension NotificationCenter {
    var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        let willShow = publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        let willHide = publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        return Publishers.Merge(willShow, willHide)
            .eraseToAnyPublisher()
    }
    
    var sceneDidBecomeActivePublisher: AnyPublisher<Notification, Never> {
        let publisher = publisher(for: UIApplication.didBecomeActiveNotification).eraseToAnyPublisher()
        return publisher
    }
    
    var sceneWillResignActivePublisher: AnyPublisher<Notification, Never> {
        let publisher = publisher(for: UIApplication.willResignActiveNotification).eraseToAnyPublisher()
        return publisher
    }
}

private extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
            .cgRectValue.height ?? 0
    }
}
