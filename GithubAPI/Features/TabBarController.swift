//
//  TabBarController.swift
//  GithubAPI
//
//  Created by Bing Guo on 2023/1/8.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let home = UINavigationController(rootViewController: HomeViewController())
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))

        let following = UINavigationController(rootViewController: FollowingViewController())
        following.tabBarItem = UITabBarItem(title: "Following", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))

        viewControllers = [home, following]
    }
}
