import Foundation
import SwiftUI

public struct TweakView: View {
    @ObservedObject var viewModel: TweakViewModel
    @State private var searchText = ""
    
    public init(tweakManager: TweakManager) {
        viewModel = TweakViewModel(tweakManager: tweakManager)
    }
    
    public var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.sections, id: \.title) { section in
                    Section(header: Text(section.title)) {
                        ForEach(section.tweaks, id: \.title) { tweak in
                            if let _ = tweak.value as? Bool {
                                ToogleCell(tweak: tweak, value: tweak.value.boolValue) { newValue in
                                    viewModel.update(tweak, with: newValue)
                                }
                            }
                            else {
                                TextCell(tweak: tweak, value: tweak.value.description) { newValue in
                                    if tweak.value is Bool, let newValue = Bool(newValue) {
                                        viewModel.update(tweak, with: newValue)
                                    }
                                    else if tweak.value is Double, let newValue = Double(newValue) {
                                        viewModel.update(tweak, with: newValue)
                                    }
                                    else {
                                        viewModel.update(tweak, with: newValue)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search Tweaks")
            .navigationTitle("Edit Configuration")
        }
    }

    private struct TweakName: View {
        let tweak: TweakViewModel.Tweak

        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(tweak.title)
                    .font(.body)
                Text(tweak.desc ?? "")
                    .font(.caption)
            }
        }
    }

    private struct ToogleCell: View {
        let tweak: TweakViewModel.Tweak
        @State var value: Bool
        let didCHange: ((Bool) -> Void)

        var body: some View {
            HStack {
                TweakName(tweak: tweak)
                    .layoutPriority(100)
                Spacer()
                Toggle(isOn: $value) {}
                .onChange(of: value) { _ in didCHange(value) }
            }
        }
    }

    private struct TextCell: View {
        let tweak: TweakViewModel.Tweak
        @State var value: String
        let didCHange: ((String) -> Void)

        var body: some View {
            HStack() {
                TweakName(tweak: tweak)
                    .layoutPriority(100)
                Spacer()
                TextField("", text: $value, onCommit: {
                    didCHange(value)
                })
                    .multilineTextAlignment(.trailing)
                    .frame(minWidth: 50)
            }
        }
    }
}
