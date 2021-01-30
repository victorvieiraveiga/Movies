//
//  FavoriteViewController.swift
//  inChurchMovies
//
//  Created by Victor Vieira Veiga on 21/01/21.
//

import UIKit
import RealmSwift

class FavoriteViewController: UIViewController {

    
    @IBOutlet weak var viewTable: UIView!
    @IBOutlet weak var viewNoSearch: UIView!
    @IBOutlet weak var viewNoFavorite: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var favorite : Results<Favorite>?
    let realm = try! Realm()
    let C = Constants()
    let fav = Favorite()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get Favorite Movies
        getFavorites()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 170
        
        navigationItem.title = "Favorite"
        self.view.window?.largeContentTitle = "changed label"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    
    func getFavorites() {
        favorite = fav.getFavorite()
        
        //Checks for favorite movies. If there is no flame warning screen
        if favorite?.count == 0 {
            viewTable.isHidden = true
            viewNoFavorite.isHidden = false
        }else {
            viewTable.isHidden = false
            viewNoFavorite.isHidden = true
        }
        
        tableView.reloadData()
    }
    

}

//MARK: - TableView DataSource Methods
extension FavoriteViewController : UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return favorite?.count ?? 1

    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: C.cel, for: indexPath) as! FavoriteTableViewCell
        let favoriteMovie = favorite?[indexPath.row]
        cell.configFavorite(favorite: favoriteMovie!)

        return cell

    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            deleteRow(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func deleteRow (indexPath: IndexPath) {
        if let itemForDeletion = self.favorite? [indexPath.row] {
        
        do {
            try realm.write{
                realm.delete(itemForDeletion)
            }
        } catch  {
            print ("Error deleting item \(error)")
        }
    }
    }
}


//MARK: - TableView Delegate Methods
extension FavoriteViewController : UITableViewDelegate {
    
}

//MARK: - Search Bar Methods

extension FavoriteViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        favorite = favorite?.filter("title CONTAINS[cd] %@", searchBar.text!)
        
        //If the searched movie does not exist, a warning will appear on the screen.
        if favorite?.count == 0 {
            viewTable.isHidden = true
            viewNoFavorite.isHidden = true
            viewNoSearch.isHidden = false
        } else {
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            getFavorites()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}



