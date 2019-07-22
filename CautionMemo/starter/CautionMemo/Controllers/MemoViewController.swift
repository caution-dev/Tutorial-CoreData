//
//  MemoViewController.swift
//  CautionMemo
//
//  Created by juhee on 20/07/2019.
//  Copyright © 2019 caution-dev. All rights reserved.
//

import UIKit


class MemoViewController: UIViewController {
    
    @IBOutlet weak var memoCountIem: UIBarButtonItem!
    @IBOutlet weak var memoTableView: UITableView!
    
    var folder: (title: String, memos: [String])!
    
    override func viewDidLoad() {
        navigationItem.title = folder.title
        memoCountIem.title = "\(folder.memos.count)개의 메모"
    }
    
    @IBAction func didTapAddMemo(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "새로운 메모", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "추가", style: .default, handler: { [weak self] action in
            guard let newMemo = alert.textFields?[0].text else { return }
            self?.addMemo(memo: newMemo)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func addMemo(memo: String) {
        folder.memos.append(memo)
        memoTableView.reloadData()
        memoCountIem.title = "\(folder.memos.count)개의 메모"
    }
    
    private let cellIdentifier: String = "memo_cell"
    
}

extension MemoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folder.memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = folder.memos[indexPath.row]
        return cell
    }
    
}


extension MemoViewController: UITableViewDelegate {
    
}
