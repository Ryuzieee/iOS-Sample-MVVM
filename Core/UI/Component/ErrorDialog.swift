//
//  ErrorDialog.swift
//  iOS-Sample-MVVM
//
//  Created by 山下竜二 on 2026/03/31.
//

import SwiftUI

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

/// エラー種別に応じたダイアログを表示する ViewModifier。
/// キャッシュ表示中のオーバーレイエラーに使用する。
struct ErrorOverlayDialog: ViewModifier {
    let error: AppError?
    @Binding var isPresented: Bool
    let onRetry: () -> Void

    func body(content: Content) -> some View {
        content
            .alert(alertTitle, isPresented: $isPresented) {
                alertActions
            } message: {
                Text(alertMessage)
            }
    }

    private var alertTitle: String {
        guard let error else { return Strings.Common.errorTitle }
        switch error {
        case .sessionExpired: return Strings.Dialog.sessionExpiredTitle
        case .forceUpdate: return Strings.Dialog.forceUpdateTitle
        default: return Strings.Common.errorTitle
        }
    }

    private var alertMessage: String {
        guard let error else { return Strings.Common.errorTitle }
        switch error {
        case .sessionExpired: return Strings.Dialog.sessionExpiredMessage
        case .forceUpdate: return Strings.Dialog.forceUpdateMessage
        case .network: return Strings.Error.networkMessage
        default: return error.errorDescription ?? Strings.Common.errorTitle
        }
    }

    @ViewBuilder
    private var alertActions: some View {
        switch error {
        case .sessionExpired:
            Button(Strings.Dialog.sessionExpiredButton) {
                // TODO: ログイン画面へ遷移
            }
        case let .forceUpdate(storeUrl):
            Button(Strings.Dialog.forceUpdateButton) {
                if let url = URL(string: storeUrl) {
                    UIApplication.shared.open(url)
                }
            }
        default:
            Button(Strings.Common.retry) { onRetry() }
            Button(Strings.Common.close, role: .cancel) {}
        }
    }
}

extension View {
    func sessionExpiredDialog(isPresented: Binding<Bool>) -> some View {
        modifier(SessionExpiredDialog(isPresented: isPresented))
    }

    func forceUpdateDialog(storeUrl: String, isPresented: Binding<Bool>) -> some View {
        modifier(ForceUpdateDialog(storeUrl: storeUrl, isPresented: isPresented))
    }

    func errorDialog(error: AppError?, isPresented: Binding<Bool>, onRetry: @escaping () -> Void) -> some View {
        modifier(ErrorOverlayDialog(error: error, isPresented: isPresented, onRetry: onRetry))
    }
}
