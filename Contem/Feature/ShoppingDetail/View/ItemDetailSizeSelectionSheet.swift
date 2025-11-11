import SwiftUI

struct ItemDetailSizeSelectionSheet: View {
    let sizeInfos: [SizeInfo]
    let selectedSize: String?
    let onSizeSelected: (String) -> Void
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("사이즈 선택")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)

                Spacer()

                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .font(.system(size: 16))
                }
            }
            .padding(20)

            Divider()

            // Size List
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(sizeInfos, id: \.size) { sizeInfo in
                        ItemDetailSizeRow(
                            size: sizeInfo.size,
                            isSelected: selectedSize == sizeInfo.size
                        ) {
                            onSizeSelected(sizeInfo.size)
                        }
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

struct ItemDetailSizeRow: View {
    let size: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(size)
                    .font(.system(size: 16, weight: isSelected ? .bold : .regular))
                    .foregroundColor(.black)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.black)
                        .font(.system(size: 16, weight: .bold))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(isSelected ? Color.gray.opacity(0.1) : Color.white)
        }

        Divider()
    }
}

#Preview {
    ItemDetailSizeSelectionSheet(
        sizeInfos: SizeInfoParser.parse(DetailInfo.sample.value3),
        selectedSize: nil,
        onSizeSelected: { _ in },
        onDismiss: {}
    )
}
