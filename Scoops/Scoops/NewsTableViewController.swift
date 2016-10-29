//
//  NewsTableViewController.swift
//  Scoops
//
//  Created by Juan Arillo Ruiz on 24/10/16.
//  Copyright © 2016 Juan Arillo Ruiz. All rights reserved.
//

import UIKit

typealias NewsRecord = Dictionary<String, AnyObject>

class NewsTableViewController: UITableViewController {
    
    var client: MSClient = MSClient(applicationURL: URL(string: "https://jarilloapp.azurewebsites.net")!)
    var model: [Dictionary<String, AnyObject>]? = []

    override func viewDidLoad() {
        super.viewDidLoad()

        if let _ = client.currentUser {
            readAllNews()
        } else {
            doLoginInFacebook()
        }
        
    }
    
    func doLoginInFacebook(){
        
        client.login(withProvider: "facebook", parameters: nil, controller: self, animated: true) { (user, error) in
            if let _ = error {
                print(error)
                return
            }
            
            if let _ = user {
                self.readAllNews()
            }
        }
        
    }

    @IBAction func addNewNews(_ sender: AnyObject) {
    
        let alert = UIAlertController(title: "Nueva Noticia", message: "Escribe la noticia", preferredStyle: .alert)
        
        
        let actionOk = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            let titleField = alert.textFields![0] as UITextField
            let textField = alert.textFields![1] as UITextField
            let photoUrlField = alert.textFields![2] as UITextField
            let authorField = alert.textFields![3] as UITextField
            let latitudeField = alert.textFields![4] as UITextField
            let longitudeField = alert.textFields![5] as UITextField
            
            
            self.addNewNews(titleField.text!, textField.text!, photoUrlField.text!, authorField.text!, Double(latitudeField.text!)!, Double(longitudeField.text!)!)
            
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        alert.addTextField { (titleField) in
            
            titleField.placeholder = "Introduce un Título"
            
        }
        
        alert.addTextField {(textField) in
            textField.placeholder = "Introduce la noticia"
        }
        
        alert.addTextField {(photoUrlField) in
            photoUrlField.placeholder = "Introduce imagen"
        }
        
        alert.addTextField {(authorField) in
            authorField.placeholder = "Introduce el autor"
        }
        
        alert.addTextField {(latitudeField) in
            latitudeField.placeholder = "Introduce la latitud"
        }
        
        alert.addTextField {(longitudeField) in
            longitudeField.placeholder = "Introduce la longitud"
        }
        
        present(alert, animated: true, completion: nil)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Insert news
    
    func addNewNews(_ title: String, _ text: String, _ photoUrl: String, _ author: String, _ latitude: Double, _ longitude: Double){
        
        let tableMS = client.table(withName: "News")
        
        tableMS.insert(["title" : title, "text" : text, "photoUrl" : photoUrl, "author" : author, "latitude" : latitude, "longitude" : longitude, "state" : 0, "points" : 0, "counter": 0]) { (result, error) in
            
            if let _ = error {
                print (error)
                return
            }
            
            
            self.readAllNews()
            
            print(result)
            
        }
        
    }
    
    // MARK: - Delete news
    
    func deleteNews(_ item: NewsRecord) {
        
        let tableMS = client.table(withName: "News")
        
        tableMS.delete(item) { (result, error) in
            
            if let _ = error {
                print (error)
                return
            }
            
            // refrescamos la tabla
            
            self.readAllNews()
            
        }
        
    }
    
    
    // MARK: - Read news
    
    func readAllNews(){
        
        let tableMS = client.table(withName: "News")
        
        // let predicate = NSPredicate(format: "author == 'Juan Arillo'")
        
        tableMS.read { (results, error) in
            if let _ = error {
                print (error)
                return
            }
            
            if !((self.model?.isEmpty)!) {
                
                self.model?.removeAll()
                
            }
            
            if let items = results {
                
                //print(items)
                for item in items.items! {
                    self.model?.append(item as! [String : AnyObject])
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if (model?.isEmpty)! {
            return 0
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (model?.isEmpty)! {
            return 0
        }
        return (model?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELDA", for: indexPath)

        // Configure the cell...
        
        let item = model?[indexPath.row]
        
        cell.textLabel?.text = item?["title"] as! String?
        cell.detailTextLabel?.text = item?["author"] as! String?

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = model?[indexPath.row]
        
        performSegue(withIdentifier: "detailNews", sender: item)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            let item = self.model?[indexPath.row]
            self.deleteNews(item!)
            self.model?.remove(at: indexPath.row)
            tableView.endUpdates()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "detailNews" {
            let vc = segue.destination as? NewsDetailTableViewController
            
            vc?.client = client
            vc?.model = (sender as! NewsRecord)
        }
    }
 

}
