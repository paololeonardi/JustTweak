import Foundation
import SwiftUI

public struct TweakView: View {
    @ObservedObject var viewModel: TweakViewModel
    
    public init(tweakManager: TweakManager) {
        viewModel = TweakViewModel(tweakManager: tweakManager)
    }
    
    public var body: some View {
        List {
            ForEach(viewModel.filteredSections, id: \.title) { section in
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
        .searchable(text: $viewModel.searchText, placeholder: "Search Tweaks")
        .navigationBarTitle("Edit Configuration")
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

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
fileprivate struct SearchableModifier: ViewModifier {
    let text: Binding<String>
    let prompt: LocalizedStringKey

    func body(content: Content) -> some View {
        content
            .searchable(text: text, placeholder: prompt)
    }
}

extension View {

    @ViewBuilder
    func searchable(text: Binding<String>, placeholder: LocalizedStringKey) -> some View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            modifier(SearchableModifier(text: text, prompt: placeholder))
        } else {
            self
        }
    }
}
