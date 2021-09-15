//
//  AppDelegate.swift
//  Copyright (c) 2016 Just Eat Holding Ltd. All rights reserved.
//

import JustTweak
import SwiftUI

@main
struct ExampleForJustTweak: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var showAlert = false

    private let tweakAccessor: GeneratedTweakAccessor

    init() {
        tweakAccessor = GeneratedTweakAccessor(with: Self.makeTweakManager())
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                #if os(OSX)
                sidebar
                #endif
                contentView
            }
            .stackNavigationViewStyle()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Hello"),
                    message: Text("Welcome to this Demo app!"),
                    dismissButton: .default(Text("Continue"))
                )
            }
        }
        .onChange(of: scenePhase) { newScenePhase in
            guard case .active = newScenePhase else { return }
            DispatchQueue.main.async {
                showAlert = tweakAccessor.shouldShowAlert
            }
        }
    }

    @ViewBuilder
    private var sidebar: some View {
        TweakView(tweakManager: tweakAccessor.tweakManager)
            .frame(minWidth: 350)
    }

    @ViewBuilder
    private var contentView: some View {
        let viewModel = ContentViewModel(tweakAccessor: tweakAccessor, tweakManager: tweakAccessor.tweakManager)
        ContentView(viewModel: viewModel)
    }

    static func makeTweakManager() -> TweakManager {
        var tweakProviders: [TweakProvider] = []

        // EphemeralTweakProvider
        #if CONFIGURATION_UI_TESTS
        let ephemeralTweakProvider_1 = NSMutableDictionary()
        tweakProviders.append(ephemeralTweakProvider_1)
        #endif

        // UserDefaultsTweakProvider
        #if DEBUG || CONFIGURATION_DEBUG
        let userDefaultsTweakProvider_1 = UserDefaultsTweakProvider(userDefaults: UserDefaults.standard)
        tweakProviders.append(userDefaultsTweakProvider_1)
        #endif

        // OptimizelyTweakProvider
        // let optimizelyTweakProvider = OptimizelyTweakProvider()
        // optimizelyTweakProvider.userId = UUID().uuidString
        // tweakProviders.append(optimizelyTweakProvider)

        // FirebaseTweakProvider
        // let firebaseTweakProvider = FirebaseTweakProvider()
        // tweakProviders.append(firebaseTweakProvider)

        // LocalTweakProvider
        #if DEBUG
        let jsonFileURL_1 = Bundle.main.url(forResource: "LocalTweaks_TopPriority_example", withExtension: "json")!
        let localTweakProvider_1 = LocalTweakProvider(jsonURL: jsonFileURL_1)
        tweakProviders.append(localTweakProvider_1)
        #endif

        // LocalTweakProvider
        let jsonFileURL_2 = Bundle.main.url(forResource: "LocalTweaks_example", withExtension: "json")!
        let localTweakProvider_2 = LocalTweakProvider(jsonURL: jsonFileURL_2)
        tweakProviders.append(localTweakProvider_2)

        let tweakManager = TweakManager(tweakProviders: tweakProviders)
        tweakManager.useCache = true
        return tweakManager
    }
}
