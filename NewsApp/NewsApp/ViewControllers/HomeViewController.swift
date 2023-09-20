//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Gökçe Pınar Yıldız on 9.09.2023.
//

import UIKit
import CoreData
import Firebase
import SideMenu

protocol MenuListControllerDelegate: AnyObject {
    func didSelectMenuItem(_ item: String)
}

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
let newSaved = NSEntityDescription.insertNewObject(forEntityName: "Saved", into: context)

class HomeViewController: UIViewController {
    
    var selectedCategory: String?
    var menu: SideMenuNavigationController?
    var newsList = [Article]()
    var viewModel = HomeViewModel()
    let userId = Auth.auth().currentUser?.uid


    @IBOutlet weak var newsSearchBar: UISearchBar!
    @IBOutlet weak var newsTableView: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedCategory = "general"
        fetchNewsForSelectedCategory()
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true
        
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        title = "News"
        view.backgroundColor = .systemBackground
        
        if let menuListController = menu?.viewControllers.first as? MenuListController {
                            menuListController.delegate = self
                        }
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsSearchBar.delegate = self
        viewModel.loadNews()
        viewModel.newsList
                    .subscribe(onNext: { [weak self] list in
                        self?.newsList = list
                        DispatchQueue.main.async {
                                    self?.newsTableView.reloadData()
                                }

                    })
                    .disposed(by: viewModel.disposeBag)
        
        }
    @IBAction func didTapMenu() {
        present(menu!,animated: true)
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {

    }
    
    override func viewWillAppear(_ animated: Bool) {
            viewModel.loadNews()
        }
      
    }
    

extension HomeViewController: UISearchBarDelegate {
    func searchBar( _ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(searchKey: searchText)
    }

    func searchBarCancelButtonClicked( _ searchBar: UISearchBar) {
        searchBar.text = nil
        viewModel.search(searchKey:" ")
        searchBar.resignFirstResponder()
    }
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource,CellProtocol {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = newsList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsTableViewCell
        
        cell.configure(with:article )
        
        cell.cellProtocol = self
        cell.indexPath = indexPath
        
        return cell
        
    }
    func detailBtnTapped(indexPath: IndexPath) {
        let article = newsList[indexPath.row]
        print("\(String(describing: article.title))tapped")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = newsList[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: article)
        
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

                let savedAction = UIContextualAction(style: .destructive, title: "Save"){ contextualAction, view, bool in
                    let news = self.newsList[indexPath.row]
                    newSaved.setValue(UUID(), forKey: "id")
                    newSaved.setValue(self.userId, forKey: "user_id")
                    newSaved.setValue(news.url!, forKey: "url")
                    do{
                            try context.save()
                        self.showAlert(title: "Success", message: "The article is saved")
                            print("Success")
                        }catch{
                            print("Error!!!")
                        }
                }
        savedAction.backgroundColor = .gray

                return UISwipeActionsConfiguration(actions: [savedAction])
            }
    
    func showAlert(title: String, message: String) {
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            if let article = sender as? Article,
               let toVC = segue.destination as? DetailViewController,
               let articleURL = URL(string: article.url!) {
                toVC.articleURL = articleURL
            }
        }
    }

}

class MenuListController: UITableViewController {

    var items = ["Business", "Entertainment", "General", "Health", "Science", "Sports", "Technology"]

    weak var delegate: MenuListControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .darkGray
        cell.cornerRadius = 5
        let selectedCell = tableView.cellForRow(at: indexPath)
            selectedCell?.backgroundColor = .gray
        return cell
    }

    override func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        delegate?.didSelectMenuItem(selectedItem)
        
    }


}

extension HomeViewController: MenuListControllerDelegate {
    func didSelectMenuItem( _ item: String) {
        selectedCategory = item
        fetchNewsForSelectedCategory()

        print("Selected item: \(item)")
        
        // Close sidemenu
        menu?.dismiss(animated: true, completion: nil)
    }
    func fetchNewsForSelectedCategory() {
        guard let selectedCategory = selectedCategory else {
            print("No selected category.")
            return
        }

        let apiKey = "4872c9cff16e456bb06734e84333b320" // API key
        let baseUrl = "https://newsapi.org/v2/top-headlines"
        let country = "us"
        
        var components = URLComponents(string: baseUrl)
        components?.queryItems = [
            URLQueryItem(name: "country", value: country),
            URLQueryItem(name: "category", value: selectedCategory),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        
        guard let url = components?.url else {
            print("URL could not be created.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Data could not be received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(NewsResponse.self, from: data)
                
                // Add data getting from API
                self?.newsList = response.articles ?? []
                
                DispatchQueue.main.async {
                    self?.newsTableView.reloadData() // update tableview
                }
            } catch {
                print("JSON converting error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }

}
