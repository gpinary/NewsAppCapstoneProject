//
//  SavedViewController.swift
//  NewsApp
//
//  Created by Gökçe Pınar Yıldız on 14.09.2023.
//

import UIKit
import CoreData


let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Saved")

class SavedViewController: UIViewController {
    var savedList:[Any] = []

    @IBOutlet weak var savedTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        savedTableView.reloadData()
        savedTableView.dataSource = self
        savedTableView.delegate = self

    }
    override func viewWillAppear(_ animated: Bool) {
        request.returnsObjectsAsFaults = false
                do {
                    let results = try context.fetch(request)
                    savedList = results as? [NSManagedObject] ?? []
                    print("Saved list\(savedList)")
                    savedTableView.reloadData() // Update Tableview
                } catch {
                    print(error.localizedDescription)
                }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
               if segue.identifier == "goToSavedDetail" {
                   if let savedDetailViewVC = segue.destination as? SavedDetailViewController,
                      let newsURL = sender as? String {
                       savedDetailViewVC.newsURL = newsURL
                   }
               }
           }
}

extension SavedViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let saved = savedList[indexPath.row] as! NSManagedObject
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedCell") as! SavedTableViewCell
        if let savedURL = saved.value(forKey: "url") as? String {
                    cell.showSavedNews(url: savedURL) // call func showSavedNews(url:)
                }
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteSaved = UIContextualAction(style: .destructive, title: "Delete") { [weak self] contextualAction, view, bool in

                let saved = self?.savedList[indexPath.row] as? NSManagedObject

                if let saved = saved {
                    context.delete(saved)

                    do {
                        try context.save()
                        print("Saved item deleted succesfully")
                        self?.savedList.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    } catch {
                        print("Error when item is deleted: \(error.localizedDescription)")
                    }
                }
            }

            return UISwipeActionsConfiguration(actions: [deleteSaved])
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let saved = savedList[indexPath.row] as? NSManagedObject
            if let saved = saved,
               let savedURL = saved.value(forKey: "url") as? String {
                performSegue(withIdentifier: "goToSavedDetail", sender: savedURL)
            }
        }
}
