//
//  DynamicTableController.swift
//  GoogleAutocomplete
//
//  Created by   on 06/05/18.
//  Copyright © 2018  . All rights reserved.
//

import UIKit


class DynamicTableController: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    
    fileprivate let kCellIdentifier = "DynamicViewCell"
    
    let tempArray = ["lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum", "lorem ipsum hjfjhh lorem ipsum fh", "lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsumlorem ipsumlorem ipsumlorem ipsum", "bjhbeyfbryfbeuy udfbvkbvhfb aytftyagtsd vhvbhxbvhjxb uygvdfdfv vhfdvhdfhf fvhfkhjvbdhvbdhf", "gyugyugeghjfd lorem ipsum lorem ipsum wfhjsjfh gsvghvds lorem ipsum efgyfgjs lorem ipsum"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tblView.estimatedRowHeight = 44.0
        tblView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DynamicTableController: UITableViewDelegate {
    
}

extension DynamicTableController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath) as! DynamicViewCell
        cell.lblDynamic.text = tempArray[indexPath.row]
        
        if indexPath.row % 2 == 0 {
            cell.btnA.isHidden = true
            cell.btnC.isHidden = true
        }
//        else {
//            cell.btnD.isHidden = true
//        }
        return cell
    }
}
