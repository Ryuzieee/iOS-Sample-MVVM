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

    @State private var showSessionExpired = false
    @State private var showForceUpdate = false

    func body(content: Content) -> some View {
        content
            .alert(
                Strings.Common.errorTitle,
                isPresented: generalErrorBinding
            ) {
                Button(Strings.Common.retry) { onRetry() }
                Button(Strings.Common.close, role: .cancel) {}
            } message: {
                Text(generalErrorMessage)
            }
            .sessionExpiredDialog(isPresented: $showSessionExpired)
            .forceUpdateDialog(storeUrl: forceUpdateStoreUrl, isPresented: $showForceUpdate)
            .onChange(of: isPresented) {
                guard isPresented, let error else { return }
                switch error {
                case .sessionExpired:
                    showSessionExpired = true
                case .forceUpdate:
                    showForceUpdate = true
                default:
                    break
                }
            }
    }

    private var generalErrorBinding: Binding<Bool> {
        Binding(
            get: {
                guard isPresented, let error else { return false }
                switch error {
                case .sessionExpired, .forceUpdate:
                    return false
                default:
                    return true
                }
            },
            set: { isPresented = $0 }
        )
    }

    private var generalErrorMessage: String {
        if let error, case .network = error {
            return Strings.Error.networkMessage
        }
        return error?.errorDescription ?? Strings.Common.errorTitle
    }

    private var forceUpdateStoreUrl: String {
        if let error, case let .forceUpdate(storeUrl) = error {
            return storeUrl
        }
        return ""
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
