import UIKit
import Alamofire
import FirebaseAuth

class ViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        //MARK: setting up red tab bar...
        let tabHome = UINavigationController(rootViewController: MainScreenViewController())
        let tabHomeBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(systemName: "house.fill")
        )
        tabHome.tabBarItem = tabHomeBarItem
        tabHome.title = "Home"
            
        //MARK: setting up green tab bar...
        let tabDiscussion = UINavigationController(rootViewController: DiscussionViewController())
        let tabDiscussionBarItem = UITabBarItem(
            title: "Discussion",
            image: UIImage(systemName: "bubble.left.and.bubble.right")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(systemName: "bubble.left.and.bubble.right.fill")
        )
        tabDiscussion.tabBarItem = tabDiscussionBarItem
        tabDiscussion.title = "Discussion"
            
        //MARK: setting up blue tab bar...
        let tabProfile = UINavigationController(rootViewController: UserProfileViewController())
        let tabProfileBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(systemName: "person.fill")
        )
        tabProfile.tabBarItem = tabProfileBarItem
        tabProfile.title = "Profile"
        
        //MARK: setting up blue tab bar...
        let tabLeaderBoard = UINavigationController(rootViewController: LeaderboardViewController())
        let tabLeaderBoardBarItem = UITabBarItem(
            title: "LeaderBoard",
            image: UIImage(systemName: "star")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(systemName: "star.fill")
        )
        tabLeaderBoard.tabBarItem = tabLeaderBoardBarItem
        tabLeaderBoard.title = "LeaderBoard"
            
        //MARK: setting up this view controller as the Tab Bar Controller...
        self.viewControllers = [tabHome, tabDiscussion, tabProfile, tabLeaderBoard]
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
    }

}


