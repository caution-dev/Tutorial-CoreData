//
//  MemoViewController.swift
//  CautionMemo
//
//  Created by juhee on 20/07/2019.
//  Copyright © 2019 caution-dev. All rights reserved.
//

import UIKit
import CoreData

class MemoViewController: UIViewController {
    
    @IBOutlet weak var memoCountIem: UIBarButtonItem!
    @IBOutlet weak var memoTableView: UITableView!
    
    var folder: Folder!
    
    var memoRequestController: NSFetchedResultsController<Memo>!
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("error")
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    override func viewDidLoad() {
        navigationItem.title = folder.title
        memoRequestController.delegate = self
        setupFetchedResultController()
        memoTableView.reloadData()
    }
    
    func setupFetchedResultController() {
        do {
            try memoRequestController.performFetch()
        } catch {
            print("error")
        }
    }
    
    @IBAction func didTapAddMemo(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "새로운 메모", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "추가", style: .default, handler: { [weak self] action in
            guard let newMemo = alert.textFields?[0].text else { return }
            self?.addMemo(content: newMemo)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func addMemo(content: String) {
        let memo = Memo(context: managedObjectContext)
        memo.content = content
        memo.date = Date() as NSDate
        memo.folder = folder
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("error")
        }
    }
    
    private let cellIdentifier: String = "memo_cell"
    
}

extension MemoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoRequestController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let memo = memoRequestController.object(at: indexPath)
        cell.textLabel?.text = memo.content
        cell.detailTextLabel?.text = memo.date?.memoDate
        return cell
    }
    
}


extension MemoViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        memoTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            memoTableView.insertRows(at: [newIndexPath!], with: .fade)
        default:
            ()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        memoTableView.endUpdates()
        
        memoCountIem.title = "\(controller.fetchedObjects?.count ?? 0)개의 메모"
    }
    
}
