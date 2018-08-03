//
//  ListPredictionViewController.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 8/3/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import UIKit
import RealmSwift

class ListPredictionViewController: UITableViewController {
    var predictions = List<PredictionModel>()
    var notificationToken: NotificationToken?
    var realm: Realm!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRealm()
        setupUI()
    }

    func setupUI() {
        title = "My Predictions"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func setupRealm() {
        realm = try! Realm()

        // Notify us when Realm changes
        notificationToken = realm.observe { _, _ in
            print("Notified of new prediction model")
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return dbPredictions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let prediction: PredictionModel = dbPredictions[indexPath.row]
        cell.textLabel?.text = "\(prediction.id) prediction"
        return cell
    }

    private var dbPredictions: Results<PredictionModel> {
        return realm.objects(PredictionModel.self)
    }
}
