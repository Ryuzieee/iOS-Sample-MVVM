# iOS-Sample-MVVM Makefile
# Android の ./gradlew ktlintFormat / ./gradlew detekt に相当

# フォーマット自動修正 (= ktlintFormat)
format:
	swiftformat .

# 静的解析 (= detekt)
lint:
	swiftlint lint

# フォーマット + 静的解析
check: format lint

# 静的解析 (警告のみ、CI用)
lint-strict:
	swiftlint lint --strict

.PHONY: format lint check lint-strict
