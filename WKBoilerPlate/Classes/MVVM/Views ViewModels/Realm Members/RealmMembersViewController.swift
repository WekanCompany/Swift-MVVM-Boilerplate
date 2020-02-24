//
//  RealmDashboardViewController.swift
//  WKBoilerPlate
//
//  Created by Brian on 17/09/19.
//  Copyright © 2019 WeKan. All rights reserved.
//

import RealmSwift
import UIKit

class RealmMembersViewController: BaseViewController {
    @IBOutlet private weak var usersTblView: UITableView!
    var viewModel: RealmMembersViewModel!
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RealmMembersViewModel()
        self.setupTableViewUpdates()
        self.fetchAction()
        self.fetchUsersFromAPI()
    }

    /// Function to fetch all users from API
    func fetchUsersFromAPI() {
        viewModel.getAllUsers(onSuccess: { _ in
            DispatchQueue.main.async {
                self.fetchAction()
            }
        }, onFailure: { errorMsg in
            self.showAPIError(message: errorMsg)
        })
    }

    /// Function to update Any changes in data to the UI
    func setupTableViewUpdates() {
        // Set results notification block
        self.notificationToken = viewModel.userRealms?.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self.usersTblView.reloadData()
            case .update(_, let deletedObjs, let insertedObjs, let modifiedObjs):
                // Query results have changed, so apply them to the TableView
                self.usersTblView.beginUpdates()
                self.usersTblView.insertRows(at: insertedObjs.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.usersTblView.deleteRows(at: deletedObjs.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.usersTblView.reloadRows(at: modifiedObjs.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.usersTblView.endUpdates()
            case .error(let err):
                // An error occurred while opening the Realm file on the background worker thread
                print(err)
                //fatalError("\(err)")
            }
        }
    }

    // MARK: - Button Actions

    @IBAction private func createAction(_ sender: Any) {
        viewModel.createData()
        self.usersTblView.reloadData()
    }

    func fetchAction() {
        viewModel.getAllUsersFromDB()
        self.usersTblView.reloadData()
    }
}

extension RealmMembersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userRealms?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        viewModel.loadData(atIndex: indexPath.row, onCell: cell)
        return cell
    }
}
