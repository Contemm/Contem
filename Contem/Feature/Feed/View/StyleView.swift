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
                .frame(height: 100)
                .padding(.bottom, .spacing16)

            Group {
                if viewModel.output.isLoading {
                    withAnimation {
                        ProgressView()
                    }
                } else {
                    withAnimation {
                        MasonryLayout(feeds: viewModel.output.feeds, refreshAction: {
                            await viewModel.refreshFeeds()
                        })
                            .environmentObject(viewModel)
                    }
                   
                }
            }
        }
        .task {
            viewModel.input.viewOnTask.send(())
        }
    }
}

