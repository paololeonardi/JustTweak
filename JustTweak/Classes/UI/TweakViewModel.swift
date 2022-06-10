import Foundation

public class TweakViewModel: ObservableObject {

    private let tweakManager: TweakManager

    private var sections = [Section]()
    @Published private(set) var filteredSections = [Section]()
    @Published var searchText: String = "" {
        didSet {
            filterContent(for: searchText)
        }
    }

    public init(tweakManager: TweakManager) {
        self.tweakManager = tweakManager
        reloadSections()
    }

    private static func justTweakResourcesBundle() -> Bundle {
        let podBundle = Bundle(for: TweakViewModel.self)
        let resourcesBundleURL = podBundle.url(forResource: "JustTweak", withExtension: "bundle")!
        let justTweakResourcesBundle = Bundle(url: resourcesBundleURL)!
        return justTweakResourcesBundle
    }

    private lazy var defaultGroupName: String! = {
        return NSLocalizedString("just_tweak_unnamed_tweaks_group_title",
                                 bundle: Self.justTweakResourcesBundle(),
                                 comment: "")
    }()

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

    func filterContent(for searchText: String) {
        guard searchText.isEmpty == false else {
            filteredSections = sections
            return
        }
        filteredSections = [Section]()
        for section in sections {
            var filteredTweaks = [Tweak]()
            for tweak in section.tweaks {
                if tweak.title.lowercased().contains(searchText.lowercased()) {
                    filteredTweaks.append(tweak)
                }
            }
            if filteredTweaks.count > 0 {
                let filteredSection = Section(title: section.title, tweaks: filteredTweaks)
                filteredSections.append(filteredSection)
            }
        }
    }

    func update(_ tweak: Tweak, with value: TweakValue) {
        let feature = tweak.feature
        let variable = tweak.variable
        tweakManager.set(value, feature: feature, variable: variable)
    }

    func reloadSections() {
        rebuildSections()
        filteredSections = sections
    }
}

extension TweakViewModel {

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

}
