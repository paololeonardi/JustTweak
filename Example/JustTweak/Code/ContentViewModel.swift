//
//  ContentViewModel.swift
//  Copyright © 2021 Just Eat. All rights reserved.
//

import SwiftUI
import JustTweak

class ContentViewModel: ObservableObject {

    let tweakAccessor: GeneratedTweakAccessor
    let tweakManager: TweakManager

    init(tweakAccessor: GeneratedTweakAccessor, tweakManager: TweakManager) {
        self.tweakAccessor = tweakAccessor
        self.tweakManager = tweakManager
        tweakManager.registerForConfigurationsUpdates(NSObject()) { [weak self] tweak in
            print("Tweak changed: \(tweak)")
            self?.objectWillChange.send()
        }
    }

    var tweakView: some View {
        TweakView(tweakManager: tweakManager)
            .stackNavigationViewStyle()
    }

    func setMeaningOfLife() {
        tweakAccessor.meaningOfLife = Bool.random() ? 42 : 108
    }

    func randomColor() -> Color {
        Color(red: Double.random(in: 0...1),
              green: Double.random(in: 0...1),
              blue: Double.random(in: 0...1),
              opacity: 1)
    }

}
