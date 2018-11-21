//
//  SPItemListVC.swift
//  D2SP
//
//  Created by bo wang on 2018/11/19.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import UIKit
import ChameleonFramework
import SVProgressHUD

class SPItemListVC: YGBaseViewCtrl {

    private static let SPItemListModeKey = "SPItemListMode"

    var query: SPItemQuery!

    private var pageVC: UIPageViewController!
    private var vcs: [Int: SPItemListContainer] = [:]

    @IBOutlet private weak var segmentView: DDSegmentScrollView!
    @IBOutlet private weak var changModeButtonItem: UIBarButtonItem!
    @IBOutlet private weak var emptyLabel: UILabel!

    private var filterUnits: [SPItemFilterUnit] = []
    private var items: [[SPItem]] = []

    private var currentIndex: Int = 0 {
        didSet {
            segmentView.currentIndex = UInt(currentIndex)
        }
    }

    private lazy var mode: SPItemListMode = SPItemListMode.init(rawValue: UserDefaults.standard.integer(forKey: "SPItemListMode")) ?? .table

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    private func initUI() {
        segmentView.barTintColor = UIColor.flatNavyBlue()
        updateTitle()
        update(mode: mode)
        loadData()
    }

    private func updateTitle() {
        navigationItem.title = query.queryTitle
    }

    private func update(mode: SPItemListMode) {
        
        self.mode = mode

        UserDefaults.standard.set(mode.rawValue, forKey: SPItemListVC.SPItemListModeKey)

        vcs.forEach({ $0.value.update(mode: mode) })

        UIView.animate(withDuration: 0.2) {
            let imgName = mode != .table ? "icon_three_rectangle" : "icon_four_rectangle"
            self.changModeButtonItem.image = UIImage.init(named: imgName)
        }
    }

    private func updateData() {
        query.filter(filterUnits)
        items = query.displayItems()
        emptyLabel.isHidden = items.count > 0

        DispatchQueue.main.async {
            self.updateTitle()
            let titles = self.query.displayTitles()!
            let countes = self.items.map { $0.count }
            let curTitles = (0..<titles.count).map({ (i) -> String in
                return i < countes.count ? "\(titles[i]) \(countes[i])" : titles[i]
            })
            self.segmentView.titles = curTitles
            self.segmentView.currentIndex = 0
            self.vcs.removeAll()
            if let vc = self.viewController(at: 0) {
                self.pageVC.setViewControllers([vc], direction: .reverse, animated: false, completion: nil)
            }
        }
    }

    private func loadData() {
        let hud = DDProgressHUD.showAnimatedLoading(in: view)
        query.asyncUpdateItems { [weak self] (suc, result) in
            hud?.hide(animated: true)
            if suc {
                self?.updateData()
            } else {
                SVProgressHUD.showError(withStatus: "发生了一个错误")
            }
        }
    }

    private func viewController(at index: Int) -> UIViewController? {
        guard index >= 0, index < items.count else { return nil }
        if let vc = vcs[index] { return vc }
        if let vc = SPItemListContainer.sb.create() {
            vc.update(mode: mode, data: items[index])

            var inset = UIEdgeInsets.zero
            inset.top += segmentView.bounds.height
            inset.top += UIApplication.shared.statusBarFrame.height
            inset.top += 44
            if is_infinity_display {
                inset.bottom += 44
            }
            vc.safeInset = inset
            vcs[index] = vc
            return vc
        }
        return nil
    }

    private func indexOf(_ vc: UIViewController) -> Int? {
        return vcs.first(where: { $1 === vc })?.key
    }

    @IBAction func changeDisplayMode(_ item: UIBarButtonItem)  {
        update(mode: mode == .table ? .grid : .table)
    }

    @IBAction func changeFilter(_ btn: UIButton) {
        let filter = SPItemFilter.init()
        filter.delegate = self
        filter.setupTypes([.input, .hero, .rarity, .event])

        if let navi = SPFilterNaviCtrl.sb.create() {
            navi.filter = filter
            navigationController?.present(navi, animated: true, completion: nil)
        }
    }

    @IBAction func segmentIndexChanged(_ segmentView: DDSegmentScrollView) {
        if let vc = viewController(at: Int(segmentView.currentIndex)) {
            let lastIndex = Int(segmentView.lastIndex)
            let curIndex = Int(segmentView.currentIndex)
            pageVC.setViewControllers([vc], direction: lastIndex > curIndex ? .reverse : .forward, animated: true, completion: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.spItemListVC.spItemListPageVCSegueID.identifier {
            pageVC = (segue.destination as! UIPageViewController)
            pageVC.delegate = self
            pageVC.dataSource = self
        }
    }
}

extension SPItemListVC: SPItemFilterDelegate {
    func filter(_ filter: SPBaseFilter!, didCompleted units: [SPFilterUnit]!) {
        filterUnits = units as! [SPItemFilterUnit]
        updateData()
    }
}

extension SPItemListVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = indexOf(viewController) {
            return self.viewController(at: index + 1)
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = indexOf(viewController) {
            return self.viewController(at: index - 1)
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let vc = pageViewController.viewControllers?.first, let index = indexOf(vc) {
            currentIndex = index
        }
    }
}
