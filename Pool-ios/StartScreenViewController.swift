//
//  StartScreenViewController.swift
//  Pool-ios
//
//  Created by Jesse Struck on 10/27/19.
//  Copyright © 2019 Jesse Struck. All rights reserved.
//

import UIKit

class StartScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        for subview in self.view.subviews {
            if (subview.restorationIdentifier == "leaderboard") {
                for l in GameManager.players {
                    print(l.name, l.score)
                }
                if let table = subview as? UITableView {
                    print(table)
                    table.dataSource = GameManager.leaderboard as? UITableViewDataSource
                    table.reloadData()
                    let cell = table.dequeueReusableCell(withIdentifier: "scoreCell")
                    cell?.textLabel?.text = GameManager.gameInstance.highScore()
                }
               
                subview
            }

        }
        // Do any additional setup after loading the view.
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
