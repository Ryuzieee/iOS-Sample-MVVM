//
//  ErrorDialog.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/31.
//

import SwiftUI

/// コンテンツの上にオーバーレイ表示するエラーダイアログ。
struct ErrorDialog: ViewModifier {
    let message: String
    let onDismiss: () -> Void
    let onRetry: () -> Void

    func body(content: Content) -> some View {
        content.alert(Strings.Common.errorTitle, isPresented: .constant(true)) {
            Button(Strings.Common.retry, action: onRetry)
            Button(Strings.Common.close, role: .cancel, action: onDismiss)
        } message: {
            Text(message)
        }
    }
}

/// セッション切れダイアログ。閉じることはできない。
struct SessionExpiredDialog: ViewModifier {
    @Binding var isPresented: Bool

    func body(content: Content) -> some View {
        content.alert(Strings.Dialog.sessionExpiredTitle, isPresented: $isPresented) {
            Button(Strings.Dialog.sessionExpiredButton) {
                // TODO: ログイン画面へ遷移
            }
        } message: {
            Text(Strings.Dialog.sessionExpiredMessage)
        }
    }
}

/// 強制アップデートダイアログ。閉じることはできない。
struct ForceUpdateDialog: ViewModifier {
    let storeUrl: String
    @Binding var isPresented: Bool

    func body(content: Content) -> some View {
        content.alert(Strings.Dialog.forceUpdateTitle, isPresented: $isPresented) {
            Button(Strings.Dialog.forceUpdateButton) {
                if let url = URL(string: storeUrl) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text(Strings.Dialog.forceUpdateMessage)
        }
    }
}

extension View {
    func errorDialog(message: String, onDismiss: @escaping () -> Void, onRetry: @escaping () -> Void) -> some View {
        modifier(ErrorDialog(message: message, onDismiss: onDismiss, onRetry: onRetry))
    }

    func sessionExpiredDialog(isPresented: Binding<Bool>) -> some View {
        modifier(SessionExpiredDialog(isPresented: isPresented))
    }

    func forceUpdateDialog(storeUrl: String, isPresented: Binding<Bool>) -> some View {
        modifier(ForceUpdateDialog(storeUrl: storeUrl, isPresented: isPresented))
    }
}
