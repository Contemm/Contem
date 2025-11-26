import SwiftUI
import Combine

struct StyleView: View {
    
    // MARK: - ViewModel
    
    @ObservedObject private var viewModel: StyleViewModel

    // MARK: - Init

    init(viewModel: StyleViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: .zero) {
            FeedSearchBarView(viewModel: viewModel)
                .padding(.bottom, .spacing16)

            Rectangle()
                .fill(.gray100)
                .frame(height: 1)
                .padding(.bottom, .spacing8)

            HashtagScrollView(items: viewModel.output.hashtagItems)
                .padding(.bottom, .spacing16)

            Group {
                if viewModel.output.isLoading {
                    ProgressView()
                } else {
                    MasonryLayout(feeds: viewModel.output.feeds)
                        .environmentObject(viewModel)
                }
            }
        }
        .task {
            viewModel.input.viewOnTask.send(())
        }
    }
}
