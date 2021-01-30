//
//  MovieDetailViewController.swift
//  inChurchMovies
//
//  Created by Victor Vieira Veiga on 20/01/21.
//

import UIKit
import RealmSwift

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelRelease: UILabel!
    @IBOutlet weak var labelGenre: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var barButtonFavorite: UIBarButtonItem!

    
    //variable for store the url of the poster
    var imageBackUrl = URL(string: "")
    
    //array for store genre's movie
    var genre = [GenreData]()
    
    //store selected movie of list
    var movieSelectDetail : Movie?
    
    //instance of Constants
    let C = Constants()
    
    //instance of realm object
    let realm = try! Realm()
    
    //reference to favorite type
    var favoriteSelected: Favorite?

    let fav = Favorite()

    override func viewDidLoad() {
        super.viewDidLoad()
        
       getImage()
       getGenre()
       
        
       navigationBar.topItem?.title = movieSelectDetail?.title
        labelRelease.text = "Release Date: \(movieSelectDetail!.release_dateFormated)"
       labelDescription.text = movieSelectDetail?.overview
        
        disableFavoriteButton()
        
    }
    
    @IBAction func buttonFavoritePress(_ sender: UIBarButtonItem) {
        
        do {
            //Save favorite movie in realm database
            try realm.write {
                let favorite = Favorite()
                favorite.title = movieSelectDetail?.title
                favorite.date = String (movieSelectDetail!.release_dateFormated)
                favorite.idMovie = movieSelectDetail!.id
                favorite.overview = movieSelectDetail?.overview
                favorite.posterDropImage = movieSelectDetail?.poster_path
            
                realm.add(favorite)
                
                //Call message for user
                AlertMessage(title: "Movie Add to Favorite")
                
            }
        } catch  {
            //Call message for user
            AlertMessage(title: "Error. Favorite don't add.")
            print ("Error")
        }
        
        
   
    }
    
    //MARK: - Data Manipulation Methods
    //function to disable the button if it was favorite
    func disableFavoriteButton () {
        let favorite : Results<Favorite> = fav.getFavorite()
        
        for fav in favorite {
            if fav.idMovie == movieSelectDetail?.id {
                barButtonFavorite.isEnabled = false
            }
        }
    }
    
    //Get image of movie
    func getImage () {
        if let backdropPath = movieSelectDetail?.backdrop_path {
            imageBackUrl = URL(string: C.BaseImageURL+backdropPath)
        } else {
            imageBackUrl = C.backPlaceholder
        }
        
        let imageData = try? Data(contentsOf: imageBackUrl!)
          if let imageData = imageData {
            imageView.image = UIImage(data: imageData)
          } else {
            imageView.image = UIImage(named: "placeholder")
          }
    }
    
    //Get genre of movie
    private func getGenre() {
        var names = [String]()
        let url = URL(string: C.BaseGenreURL)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            guard let jsonData = data else {
                print("Error, no data")
                return
            }
            do {
                let json = try JSONDecoder().decode(Genre.self, from: jsonData)
                self.genre = json.genres
                for genre in self.genre {
                    for genreId in self.movieSelectDetail!.genre_ids {
                        if genreId == genre.id {
                            names.append(genre.name!)
                        }
                    }
                }
                DispatchQueue.main.async {
                    if names.indices.contains(1) {
                        self.labelGenre.text = "\(names[0]), \(names[1])"
                    } else {
                        self.labelGenre.text = "\(names[0])"
                    }
                }
            } catch {
                print(error)
            }
        }
        dataTask.resume()
    }
    
    func AlertMessage(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .cancel) { (action) in
            print ("Ok")
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
   
}
