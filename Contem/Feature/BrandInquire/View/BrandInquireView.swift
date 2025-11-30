import SwiftUI
import Combine


struct BrandInquireView: View {
    
    @StateObject private var viewModel: BrandInquireViewModel
    @State private var text: String = ""
    
    init(coordinator: AppCoordinator, userId: String) {
        _viewModel = StateObject(
            wrappedValue: BrandInquireViewModel(
                coordinator: coordinator,
                userId: userId
            )
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            ZStack {
                Text("문의하기")
                    .font(.headline)
                    .fontWeight(.bold)
                
                HStack {
                    Button(action: {
                        viewModel.input.dismissButtonTapped.send(())
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.primary100)
                            .padding(.leading, 16)
                            .padding(.vertical, 12)
                    }
                    
                    Spacer() 
                }
            }
            .frame(height: 50)
            
            Spacer()
            inputBarArea
        }
        
    }
    
    
    var inputBarArea: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 12) {
                HStack {
                    TextField("Message...", text: $text)
                        .padding(.vertical, 10)
                    
                    if !text.isEmpty {
                        Button(action: {
                            print("메세지 전송")
                            
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .foregroundStyle(Color.primary100)
                        }
                        .transition(.opacity.animation(.easeInOut(duration: 0.2)))
                    } else {
                        Button(action: {
                           print("이미지 가져오기")
                            
                        }) {
                            Image(systemName: "photo.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: CGFloat.spacing28, height: CGFloat.spacing28)
                                .foregroundStyle(Color.primary100)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .background(Color(uiColor: .systemGray6))
                .cornerRadius(24)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color(uiColor: .systemBackground))
    }
    
}
