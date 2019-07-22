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
    var fetchedResultsController: NSFetchedResultsController<Memo>!
    
    lazy var managedObectContext: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("error")
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    override func viewDidLoad() {
        navigationItem.title = folder.title
        setupFetchedResultController()
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
        let memo = Memo(context: managedObectContext)
        memo.content = content
        memo.date = Date() as NSDate
        memo.folder = folder
        do {
            try managedObectContext.save()
        } catch {
            fatalError("save error")
        }
    }
    
    func removeMemo(memo: Memo) {
        do {
            managedObectContext.delete(memo)
            try managedObectContext.save()
        } catch {
            fatalError("save error")
        }
    }
    
    func setupFetchedResultController() {
        do {
            fetchedResultsController.delegate = self
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }
    
    private let cellIdentifier: String = "memo_cell"
    
}

extension MemoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section]
            else {
                return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let memo = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = memo.content
        cell.detailTextLabel?.text = memo.date?.memoDate
        return cell
    }
    
}


extension MemoViewController: UITableViewDelegate {
    
}

extension MemoViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        memoTableView.beginUpdates()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            memoTableView.insertSections(indexSet, with: .automatic)
        case .delete:
            memoTableView.deleteSections(indexSet, with: .automatic)
        default:
            break
        }
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            memoTableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            memoTableView.deleteRows(at: [indexPath!], with: .fade)
        default:
            ()
        }
    }
    
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        memoTableView.endUpdates()
        memoCountIem.title = "\(controller.fetchedObjects?.count ?? 0)개의 메모"
    }
}
