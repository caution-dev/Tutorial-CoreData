//
//  FolderViewController.swift
//  CautionMemo
//
//  Created by juhee on 20/07/2019.
//  Copyright © 2019 caution-dev. All rights reserved.
//


import UIKit
import CoreData


class FolderViewController: UIViewController {
    
    @IBOutlet weak var folderTableView: UITableView!
    
//    var folders: [(title: String, memos: [String])] = [("Core Data", ["Core Data Stack", "NSManagedObject"])]
    var folders: [Folder] = []
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("error")
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    override func viewDidLoad() {
        let fetchRequest = NSFetchRequest<Folder>(entityName: "Folder")
        do {
            let fetchedFolder = try managedObjectContext.fetch(fetchRequest)
            folders = fetchedFolder
            folderTableView.reloadData()
        } catch {
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        do {
            try managedObjectContext.save()
        } catch {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UITableViewCell,
            let memoViewController = segue.destination as? MemoViewController,
            let row = folderTableView.indexPath(for: cell)?.row {
            let folder = folders[row]
            
            let fetchRequest: NSFetchRequest<Memo> = Memo.fetchRequest()
            let predicate = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Memo.folder), folder])
            fetchRequest.predicate = predicate
            
            let dateSort: NSSortDescriptor = NSSortDescriptor(key: #keyPath(Memo.date), ascending: false)
            fetchRequest.sortDescriptors = [dateSort]
            
            let fetcheRequestController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            memoViewController.folder = folder
            memoViewController.memoRequestController = fetcheRequestController
        }
    }
    
    @IBAction func addFolder(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "새로운 폴더", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "추가", style: .default, handler: { [weak self] action in
            guard let title = alert.textFields?[0].text else { return }
            self?.addFolder(title: title)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func addFolder(title: String) {
        let folder = NSEntityDescription.insertNewObject(forEntityName: "Folder", into: managedObjectContext) as! Folder
        folder.title = title
        folders.append(folder)
        folderTableView.reloadData()
    }
    
    private let cellIdentifier: String = "folder_cell"
}

extension FolderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = folders[indexPath.row].title
//        cell.detailTextLabel?.text = "\(folders[indexPath.row].memos.count)"
        return cell
    }
    
    
}


extension FolderViewController: UITableViewDelegate {
    
}
