//
//  ShoppingDetailSizeSheet.swift
//  Contem
//
//  Created by 송재훈 on 11/14/25.
//

import SwiftUI

struct ShoppingDetailSizeSheet: View {

    // MARK: - Properties

    let detailInfo: ShoppingDetailInfo?
    let selectedSize: String?
    let onSizeSelected: (String) -> Void
    let onDismiss: () -> Void

    // MARK: - Computed Properties

    /// value3에서 간단하게 사이즈 추출 (간소화 버전)
    private var sizes: [String] {
        guard let detailInfo = detailInfo else { return [] }

        // value3 예시: "(85(XS), 62, 111, ...), (90(S), 65, 116, ...), ..."
        // 각 괄호 쌍에서 첫 번째 값만 추출
        let sizePattern = "\\((\\d+\\([A-Z]+\\))"

        do {
            let regex = try NSRegularExpression(pattern: sizePattern)
            let range = NSRange(detailInfo.sizeInfo.startIndex..., in: detailInfo.sizeInfo)
            let matches = regex.matches(in: detailInfo.sizeInfo, range: range)

            return matches.compactMap { match -> String? in
                guard let range = Range(match.range(at: 1), in: detailInfo.sizeInfo) else { return nil }
                return String(detailInfo.sizeInfo[range])
            }
        } catch {
            // Regex 실패 시 기본 사이즈 반환
            return ["85(XS)", "90(S)", "95(M)", "100(L)", "105(XL)", "110(XXL)"]
        }
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("사이즈 선택")
                    .font(.titleMedium)
                    .foregroundColor(.primary100)

                Spacer()

                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary100)
                        .font(.bodyLarge)
                }
            }
            .padding(.spacing20)

            Divider()

            // Size List
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(sizes, id: \.self) { size in
                        ShoppingDetailSizeRow(
                            size: size,
                            isSelected: selectedSize == size
                        ) {
                            onSizeSelected(size)
                        }
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - ShoppingDetailSizeRow

struct ShoppingDetailSizeRow: View {

    // MARK: - Properties

    let size: String
    let isSelected: Bool
    let action: () -> Void

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            HStack {
                Text(size)
                    .font(isSelected ? .titleSmall : .bodyLarge)
                    .foregroundColor(.primary100)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.primary100)
                        .font(.titleSmall)
                }
            }
            .padding(.horizontal, .spacing20)
            .padding(.vertical, .spacing16)
            .background(isSelected ? .gray25 : .primary0)
        }

        Divider()
    }
}

//#Preview {
//    ShoppingDetailSizeSheet(
//        detailInfo: ShoppingDetailInfo.sample,
//        selectedSize: nil,
//        onSizeSelected: { _ in },
//        onDismiss: {}
//    )
//}
