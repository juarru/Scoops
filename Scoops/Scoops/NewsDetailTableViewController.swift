//
//  NewsDetailTableViewController.swift
//  Scoops
//
//  Created by Juan Arillo Ruiz on 27/10/16.
//  Copyright © 2016 Juan Arillo Ruiz. All rights reserved.
//

import UIKit

class NewsDetailTableViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var model: NewsRecord?
    var client: MSClient = MSClient(applicationURL: URL(string: "https://jarilloapp.azurewebsites.net")!)
    var container: AZSCloudBlobContainer?
    var blob : [AZSCloudBlockBlob] = []
    var bobClient: AZSCloudBlobClient?
    
    func setupAzureClient()  {
        
        do {
            let credentials = AZSStorageCredentials(accountName: "jarillostorage",
                                                    accountKey: "Zg2LYpooPxq+psVSKJSiNDC57aHPzXIl0AIxnwJ54s9NxcIHP+Ht0fZzyclEha9Tpk7cDuMs4t5/5Jh3JYO2IA==")
            let account = try AZSCloudStorageAccount(credentials: credentials, useHttps: true)
            
            bobClient = account.getBlobClient()
            
            
        } catch let error {
            print(error)
        }
        
    }
    
    
    @IBOutlet weak var tituloLbl: UILabel! {
        didSet {
            tituloLbl.text = model?["title"] as! String?
        }
    }
    
    @IBOutlet weak var autorLbl: UILabel!{
        didSet {
            autorLbl.text = model?["author"] as! String?
        }
    }
    
    @IBOutlet weak var fotoLbl: UILabel! {
        
        didSet {
            fotoLbl.text = model?["photoUrl"] as! String?
        }
        
    }
    
    @IBOutlet weak var latitudLbl: UILabel! {
        
        didSet {
            guard let latitude = model?["latitude"] as! Double? else {
                return
            }
            //latitudLbl.text = String(describing: model?["latitude"] as! Double?)
            latitudLbl.text = String(describing: latitude)
        }

    }
    
    @IBOutlet weak var longitudLbl: UILabel! {
        
        didSet {
            
            guard let longitude = model?["longitude"] as! Double? else {
                return
            }
            //longitudLbl.text = String(describing: model?["longitude"] as! Double?)
            longitudLbl.text = String(describing: longitude)
        }
        
    }
    
    @IBOutlet weak var noticiaLbl: UILabel!{
        
        didSet {
            noticiaLbl.text = model?["text"] as! String?
        }
        
    }
    
    @IBOutlet weak var estadoLbl: UILabel! {
        
        didSet {
            
            autorizarText()
            
        }
        
    }
    
    @IBOutlet weak var valoraLbl: UILabel! {
        
        didSet{
            guard let valora = model?["points"] as! Double? else {
                return
            }
            valoraLbl.text = String(describing: valora)
        }
        
    }
    
    @IBOutlet weak var valoraTxt: UITextField! {
        didSet{
            guard let valora = model?["points"] as! Double? else {
                return
            }
            valoraTxt.text = String(valora)
        }
    }

    @IBOutlet weak var tituloTxt: UITextField! {
        didSet {
            guard let titulo = model?["title"] as! String? else {
                return
            }
            tituloTxt.text = titulo
        }
    }
    
    @IBOutlet weak var autorTxt: UITextField! {
        didSet {
            guard let autor = model?["author"] as! String? else {
                return
            }
            autorTxt.text = autor
        }
    }
    
    @IBOutlet weak var fotoTxt: UITextField! {
        didSet {
            guard let foto = model?["photoUrl"] as! String? else {
                return
            }
            fotoTxt.text = foto
            
            
        }
    }
    
    @IBOutlet weak var latitudTxt: UITextField! {
        didSet {
            guard let latitud = model?["latitude"] as! Double? else {
                return
            }
            if let _ = client.currentUser {
                latitudTxt.text = String(latitud)
            }
            
        }
    }
    
    @IBOutlet weak var longitudTxt: UITextField! {
        didSet {
            guard let longitud = model?["longitude"] as! Double? else {
                return
            }
            longitudTxt.text = String(longitud)
        }
    }
    
    @IBOutlet weak var noticiaTxt: UITextField! {
        didSet {
            guard let noticia = model?["text"] as! String? else {
                return
            }
            
            noticiaTxt.text = noticia
            
        }
    }
    
    
    @IBOutlet weak var selectImage: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var selectImageBtn: UIButton!
    
    @IBAction func selectImageAction(_ sender: AnyObject) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated:true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAzureClient()
        
        imagePicker.delegate = self
        
        if let _ = client.currentUser {
            valoraTxt.isHidden = true
        } else {
            
            //doLoginInFacebook()
            tituloTxt.isHidden = true
            autorTxt.isHidden = true
            fotoTxt.isHidden = true
            latitudTxt.isHidden = true
            longitudTxt.isHidden = true
            noticiaTxt.isHidden = true
            estadoLbl.isHidden = true
            valoraLbl.isHidden = true
            autorizarBtn.isEnabled = false
        }
        
        //callCustomApi()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateEditNews(_ sender: AnyObject) {
        
        updateNews()
        
    }
    
    @IBOutlet weak var autorizarBtn: UIBarButtonItem!
    
    @IBAction func autorizar(_ sender: AnyObject) {
     
        
        authorizeNews()
        
        autorizarText()
        
    }
 
    @IBOutlet weak var uploadImgBtn: UIBarButtonItem!
    
    @IBAction func uploadImage(_ sender: AnyObject) {
        
        uploadBlob()
        
    }
    
    
    func updateNews(){
        let tableAz = client.table(withName: "News")
        
        // Habría que hacer un check de actualizaciones (validaciones)
        
        model!["title"] = tituloTxt.text as AnyObject?
        model!["author"] = autorTxt.text  as AnyObject?
        model!["photoUrl"] = fotoTxt.text as AnyObject?
        model!["latitude"] = latitudTxt.text as AnyObject?
        model!["longitude"] = longitudTxt.text as AnyObject?
        model!["text"] = noticiaTxt.text as AnyObject?
        model!["points"] = valoraTxt.text as AnyObject?
        
        tableAz.update(model!, completion: { (result, error) in
            if let _ = error {
                print(error)
                return
            }
            
            print(result)
            self.viewDidLoad()
        })
        
        
        
        
    }
    
    func uploadBlob() {
        
        let myContainer = AZSCloudBlobContainer.init(name: "jarillocontainer", client: bobClient!)
        
        let myBlob = myContainer.blockBlobReference(fromName: UUID().uuidString)
        
        let image = UIImage(named: "noimage.png")
        
        myBlob.upload(from: UIImageJPEGRepresentation(image!, 0.5)!, completionHandler: { (error) in
            
            if error != nil {
                print(error)
                return
            }
            
            print ("subido")
        })
        
        
        
    }
    
    func authorizeNews(){
        
        let tableAz = client.table(withName: "News")
        
        model!["state"] = true as AnyObject?
        
        tableAz.update(model!, completion: { (result, error) in
            if let _ = error {
                print(error)
                return
            }
            
            print(result)
            
        })
        
    }
    
    
    // MARK: - Auxiliar functions
    
    func autorizarText() {
        
        let state = model?["state"] as! Bool
        
        if state == false {
            estadoLbl.text = "NO PUBLICADA"
        } else {
            estadoLbl.text = "PUBLICADA"
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectImage.contentMode = .scaleAspectFit
            selectImage.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */
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
