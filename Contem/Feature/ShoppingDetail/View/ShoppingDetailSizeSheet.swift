//
//  ShoppingDetailSizeSheet.swift
//  Contem
//
//  Created by 송재훈 on 11/14/25.
//

import SwiftUI

struct ShoppingDetailSizeSheet: View {
    
    let detailInfo: ShoppingDetailInfo?
    let selectedSize: String?
    let onSizeSelected: (String) -> Void
    let onDismiss: () -> Void
    
    /// value3에서 간단하게 사이즈 추출 (간소화 버전)
    private var sizes: [String] {
        guard let detailInfo = detailInfo else { return [] }
        
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
    
    // [수정] 3열 그리드 레이아웃 정의
    private let gridColumns: [GridItem] = [
        GridItem(.flexible(), spacing: .spacing8),
        GridItem(.flexible(), spacing: .spacing8),
        GridItem(.flexible(), spacing: .spacing8)
    ]
    
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
            
            ScrollView {
                LazyVGrid(columns: gridColumns, spacing: .spacing8) {
                    ForEach(sizes, id: \.self) { size in
                        ShoppingDetailSizeGridItem(
                            size: size,
                            isSelected: selectedSize == size
                        ) {
                            onSizeSelected(size)
                        }.background(.white)
                    }
                    .padding(.horizontal, .spacing12)
                    .padding(.bottom, .spacing20)
                }
            }
            .padding(.top, 16)
            .background(Color.gray25.opacity(0.5))
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}

    
    
// MARK: - ShoppingDetailSizeRow
struct ShoppingDetailSizeGridItem: View {

    let size: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(size)
                .font(.bodyLarge)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(Color.primary100)
                .frame(maxWidth: .infinity)
                .padding(.vertical, .spacing16) // 텍스트 위아래 여백 확보
                .overlay(
                    RoundedRectangle(cornerRadius: .spacing8)
                        .stroke(isSelected ? Color.primary100 : Color.gray100, lineWidth: 0.5)
                )
        }
    }

}

