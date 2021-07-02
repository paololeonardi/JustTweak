import Foundation

public class TweakViewModel: ObservableObject {

    private let tweakManager: TweakManager

    @Published var sections = [Section]()

    struct Section {
        let title: String
        let tweaks: [Tweak]
    }

    class Tweak {
        var feature: String
        var variable: String
        var title: String
        var desc: String?
        var value: TweakValue

        init(feature: String, variable: String, value: TweakValue, title: String, description: String?) {
            self.feature = feature
            self.variable = variable
            self.value = value
            self.title = title
            self.desc = description
        }
    }

    private static func justTweakResourcesBundle() -> Bundle {
        let podBundle = Bundle(for: TweakViewController.self)
        let resourcesBundleURL = podBundle.url(forResource: "JustTweak", withExtension: "bundle")!
        let justTweakResourcesBundle = Bundle(url: resourcesBundleURL)!
        return justTweakResourcesBundle
    }

    private lazy var defaultGroupName: String! = {
        return NSLocalizedString("just_tweak_unnamed_tweaks_group_title",
                                 bundle: Self.justTweakResourcesBundle(),
                                 comment: "")
    }()

    public init(tweakManager: TweakManager) {
        self.tweakManager = tweakManager
        rebuildSections()
    }

    private func rebuildSections() {
        let allTweaks = tweakManager.displayableTweaks
        var allSections = [Section]()
        var allGroups: Set<String> = []
        for tweak in allTweaks {
            allGroups.insert(tweak.group ?? defaultGroupName)
        }

        for group in allGroups {
            var items = [Tweak]()
            for tweak in allTweaks {
                if tweak.group == group || (tweak.group == nil && group == defaultGroupName) {
                    let dto = Tweak(feature: tweak.feature,
                                    variable: tweak.variable,
                                    value: tweak.value,
                                    title: tweak.displayTitle,
                                    description: tweak.desc)
                    items.append(dto)
                }
            }
            if items.count > 0 {
                let section = Section(title: group, tweaks: items)
                allSections.append(section)
            }
        }
        sections = allSections.sorted { (lhs, rhs) -> Bool in
            return lhs.title < rhs.title
        }
    }

}
