//
//  CoreDataDashboardViewController.swift
//  WKBoilerPlate
//
//  Created by Brian on 17/09/19.
//  Copyright © 2019 WeKan. All rights reserved.
//

import UIKit

class CoreDataMembersViewController: BaseViewController {
    @IBOutlet weak var usersTblView: UITableView!

    var viewModel: CoreDataMembersViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CoreDataMembersViewModel()
        viewModel.syncOfflineMembers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchAction(self)
        self.fetchUsersFromAPI()
    }

    /// Makes the API call to Get all users
    func fetchUsersFromAPI() {
        viewModel.getAllUsers(onSuccess: { (users) in
            if !self.viewModel.users.isEmpty {
                // If users are available, Save users to local DB and refresh the list view
                self.viewModel.saveAllUsersToLocalDB { saved in
                    if saved {
                        DispatchQueue.main.async {
                            self.fetchAction(self)
                        }
                    }
                }
            }
        }, onFailure: { errorMsg in
            self.showAPIError(message: errorMsg)
        })
    }

    // MARK: - Button Actions

    /// Button action for the create(+) button on navigation bar. This goes to create user screen to add new users
    @IBAction func createAction(_ sender: Any) {
        self.performSegue(withIdentifier: "UsersListToAddUser", sender: sender)
    }

    /// fetches all users frm loacl DB and lists on screen.
    @IBAction private func fetchAction(_ sender: Any) {
        viewModel.getAllUsersFromDB()
        self.usersTblView.reloadData()
    }
 }

extension CoreDataMembersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.usersDBObjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        self.loadData(atIndex: indexPath.row, onCell: cell)
        return cell
    }

    /**
     Loads user data in table view cell
     - Parameter index: index of the user to be loaded
     - Parameter cell: the cell to load user data
     */
    func loadData(atIndex index: Int, onCell cell: UITableViewCell ) {
        let user = viewModel.usersDBObjects[index]
        cell.textLabel?.text = "\(user.firstName?.capitalizingFirstLetter() ?? "") \(user.lastName?.capitalizingFirstLetter() ?? "")"
        cell.detailTextLabel?.text = user.email
    }
}
