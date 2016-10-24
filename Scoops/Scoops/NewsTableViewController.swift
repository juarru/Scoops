//
//  NewsTableViewController.swift
//  Scoops
//
//  Created by Juan Arillo Ruiz on 24/10/16.
//  Copyright © 2016 Juan Arillo Ruiz. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    var client: MSClient = MSClient(applicationURL: URL(string: "http://jarilloapp.azurewebsites.net")!)
    var model: [String]? = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //addNewNews("Titulo 1", "Este es el título 1", "http://", "Juan Arillo", 27, 27)
        readAllNews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Insert news
    
    func addNewNews(_ title: String, _ text: String, _ photoUrl: String, _ author: String, _ latitude: Double, _ longitude: Double){
        
        let tableMS = client.table(withName: "News")
        
        tableMS.insert(["title" : title, "text" : text, "photoUrl" : photoUrl, "author" : author, "latitude" : latitude, "longitude" : longitude]) { (result, error) in
            
            if let _ = error {
                print (error)
                return
            }
            
            print(result)
            
        }
        
    }
    
    // MARK: - Read news
    
    func readAllNews(){
        
        let tableMS = client.table(withName: "News")
        
        let predicate = NSPredicate(format: "author == 'Juan Arillo'")
        
        tableMS.read(with: predicate) { (results, error) in
            
            if let _ = error {
                print (error)
                return
            }

            if let items = results {
                
                print(items)
                
            }
            
        }
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
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
