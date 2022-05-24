//
//  AppTabBarController.swift
//  To-Do
//
//  Created by Mukul on 24/05/22.
//

import UIKit

enum Page {
    case Today,
         Tomorrow,
         Upcoming
}
var currentPage: Page?

class AppTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let fontAttributes = [NSAttributedString.Key.font: UIFont(name: "TrebuchetMS", size: 20)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes as [NSAttributedString.Key : Any], for: .normal)

    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch (item.tag) {
            case 1: currentPage = Page.Today
                break
            case 2: currentPage = Page.Tomorrow
                break
            case 3: currentPage = Page.Upcoming
                break
            default: currentPage = Page.Today
                break
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
