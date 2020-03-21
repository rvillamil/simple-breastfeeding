//
//  StatisticsTableViewController.swift
//  rememberbreast
//
//  Created by Rodrigo Villamil Pérez on 20/7/18.
//  Copyright © 2018 Rodrigo Villamil Pérez. All rights reserved.
//

import UIKit
import CoreData

// https://www.ralfebert.de/ios-examples/uikit/uitableviewcontroller/
class StatisticsTableViewController: UITableViewController {

    // MARK: - Internal Constants
    let tableCellSelectedColor = UIView()
    
    // MARK: - Internal vars
    var breastFeedingStatics:[BreastFeedingStatic]?    = nil
    var breastFeedingStaticsStore                      = BreastFeedingStaticsStore()
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
        self.colors()
        self.l18n()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.breastFeedingStatics = breastFeedingStaticsStore.findAll()
        tableView.reloadData()
    }
    
    // workarround: https://stackoverflow.com/questions/43343775/how-to-set-localization-to-uitabbarcontroller
    override func awakeFromNib() {
        super.awakeFromNib()
        l18n()
    }
    
    // MARK: - My functions
    func configView() {
        // Display add and edit button
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(insertNewObject(_:)))
        navigationItem.leftBarButtonItem = addButton
       
        // Title big in navigation bar
        self.navigationController?.navigationBar.prefersLargeTitles=true
        
    }
    
    func l18n () {
        self.navigationItem.title = NSLocalizedString(
        "tbItemStatiticsTable.title", comment: "")
        
        self.tabBarController?.tabBar.items![1].title=NSLocalizedString(
            "tbItemStatiticsTable.title", comment: "")
    }
    
    func colors() {
        self.tableCellSelectedColor.backgroundColor = UIColor.rbTextChronometerStopped
    }

    @objc
    func insertNewObject(_ sender: Any) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return self.breastFeedingStatics!.count
    }
  
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "LabelCell", for: indexPath)
        
        // Selection cell backgroundcolor
        cell.selectedBackgroundView = self.tableCellSelectedColor
        
        let breastFeedingStatic = self.breastFeedingStatics![indexPath.row]
        //Con KVC obtenemos el contenido del atributo "name" de la task y lo añadimos a nuestra Cell
        let chestRight     = breastFeedingStatic.value(
            forKey: "chestRight") as? Bool
        let beginDateTime  = breastFeedingStatic.value(
            forKey: "beginDateTime") as? Date
        let duration       = breastFeedingStatic.value(
            forKey: "duration") as? Int
       
        cell.textLabel?.text = chestRight! ? NSLocalizedString(
            "right", comment: "") : NSLocalizedString(
                "left", comment: "")
        cell.detailTextLabel?.text = "\(SimpleDateFormatter.dateToString(beginDateTime!)) \(NSLocalizedString("during", comment: "")) \(SimpleDateFormatter.secondsToHHmmss(duration!))"

        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let beginDateTimeToDelete  = (self.breastFeedingStatics?[indexPath.row].beginDateTime)

            self.breastFeedingStatics?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.breastFeedingStaticsStore.delete ( beginDateTime: beginDateTimeToDelete!)
        }
    }
    /*
    
    override func tableView(_ tableView: UITableView,
                            willDisplayHeaderView view: UIView,
                            forSection section: Int){
        view.tintColor = self.tableHeaderBackgrndColor
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    */
    /*
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
    }
    */
    
    /*
     // Override to support rearranging the table view
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
