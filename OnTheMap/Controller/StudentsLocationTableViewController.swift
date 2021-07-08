//
//  StudentsLocationTableViewController.swift
//  OnTheMap
//
//  Created by Ahmed AlKharraz on 03/07/2021.
//

import UIKit

class StudentsLocationTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            tableView.reloadData()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: "refresh"), object: nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.dataSource = self
        tableView.delegate = self
        
        _ = OTMClient.getStudentsLocation() { locations, error in
            OTMModel.studentsLocations = locations
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    
}

extension StudentsLocationTableViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OTMModel.studentsLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentsLocationCell")!
        
        let studentsLocations = OTMModel.studentsLocations[indexPath.row]
        
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.textLabel?.text = "\(studentsLocations.firstName) \(studentsLocations.lastName)"
        cell.detailTextLabel?.text = studentsLocations.mediaURL
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentsLocations = OTMModel.studentsLocations[indexPath.row]
        let urlString = studentsLocations.mediaURL
        if let url = URL(string: urlString)
        {
            UIApplication.shared.open(url, options: [:]) { (Bool) in
                return
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func refreshData() {
        _ = OTMClient.getStudentsLocation() { locations, error in
            OTMModel.studentsLocations = locations
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            print(error)
        }
    }
    
}
