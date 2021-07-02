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
                ForEach(viewModel.sections.indices) { index in
                    Section(header: Text(viewModel.sections[index].title)) {
                        ForEach(viewModel.sections[index].tweaks.indices) { tweakIndex in
                            if let _ = viewModel.sections[index].tweaks[tweakIndex].value as? Bool {
                                ToogleCell(tweak: viewModel.sections[index].tweaks[tweakIndex])
                            }
                            else {
                                TextCell(tweak: viewModel.sections[index].tweaks[tweakIndex])
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search Tweaks")
            .navigationTitle("Edit Configuration")
        }
    }
}

struct TweakName: View {
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

struct ToogleCell: View {
    let tweak: TweakViewModel.Tweak

    var body: some View {
        let boolBinding = Binding(
            get: { tweak.value as? Bool ?? false },
            set: { tweak.value = $0 }
        )

        HStack {
            TweakName(tweak: tweak)
                .layoutPriority(100)
            Spacer()
            Toggle(isOn: boolBinding) {}
        }
    }
}

struct TextCell: View {
    let tweak: TweakViewModel.Tweak

    var body: some View {
        let stringBinding = Binding(
            get: { tweak.value.description },
            set: { tweak.value = $0 }
        )

        HStack() {
            TweakName(tweak: tweak)
                .layoutPriority(100)
            Spacer()
            TextField("", text: stringBinding)
                .multilineTextAlignment(.trailing)
                .frame(minWidth: 50)
        }
    }
}
