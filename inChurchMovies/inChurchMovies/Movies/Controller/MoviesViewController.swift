//
//  MoviesViewController.swift
//  inChurchMovies
//
//  Created by Victor Vieira Veiga on 19/01/21.
//

import UIKit
import RealmSwift

class MoviesViewController: UIViewController, UICollectionViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var viewError: UIView!
    
    
    var movies  = [MovieModel]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var results = [Movie]()
    
    var movieDelegate = MovieManager()
    var c = Constants()
    
    //object for Manager persist data on realm
    let realm = try! Realm()
    var favorite : Results<Favorite>?
    let fav = Favorite()
    var favoriteMovie: Bool = false
    
    
    //Activity Indicator
    var spinner = UIActivityIndicatorView()
    //View which contains the loading text and the spinner
    var loadingView = UIView()
    // Text shown during load the TableView
    let loadingLabel = UILabel()
    
    var fetchingMore : Bool = false
    var  i: Int = 0
    var limit = 20
    let totalEnteries = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load favorites movies
        favorite = fav.getFavorite()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        movieDelegate.delegate = self
        
        //register nib to activit indicator of the infinite scroll
        let loadingNib = UINib(nibName: "LoadingCell", bundle: nil)
        collectionView.register(loadingNib, forCellWithReuseIdentifier: "loadingCell")
        
        
       self.setLoadingScreen()
        loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Load Movies
    func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000))  {
            
            self.movieDelegate.fetchMovie()
            //self.loadFavorites()
            self.collectionView.reloadData()
            self.removeLoadingScreen()
        }
    }

//MARK: -  Activity Indicator Methods
    private func setLoadingScreen() {

        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (collectionView.frame.width / 2) - (width / 2)
        let y = (collectionView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)

        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)

        // Sets spinner
        spinner.style = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()

        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)

        collectionView.addSubview(loadingView)

    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {

        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true

    }

    
//MARK: - Infinite Scroll Methods
 func scrollViewDidScroll(_ scrollView: UIScrollView) {
     let offsetY = scrollView.contentOffset.y
     let contentHeight = scrollView.contentSize.height


     if offsetY > contentHeight - scrollView.frame.height  {
         if !fetchingMore {
             if self.movies.count > 0 {
                 beginBatchFetch()

             }
         }

     }
 }
    func beginBatchFetch() {
        fetchingMore = true
        //print("beginBatchFetch!")
        self.collectionView.reloadSections(IndexSet(integer: 1))
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
        
        self.results.append(self.results[self.i])
        self.fetchingMore = false
        self.collectionView.reloadData()
        self.i = self.i + 1
            
        })
    }
}

//MARK: - Collection View DataSource Methods
extension MoviesViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return results.count
        } else if section == 1 && fetchingMore {
            return 1
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section ==  0 {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: c.cel, for: indexPath) as! MoviesCollectionViewCell
            
           //check if movie is favorite
            favoriteMovie = false
            for fav in favorite! {
                if results[indexPath.row].id == fav.idMovie {
                    favoriteMovie = true
                }
                if favoriteMovie {
                    break
                }
            }
            cell.loadingCellView(movie: results, indexPath: indexPath.row, favoriteMovie: favoriteMovie)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            cell.spinner.startAnimating()
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieSelect = results[indexPath.item]
        let storyboard  = UIStoryboard(name: "Main", bundle: nil)
        
        let controller = storyboard.instantiateViewController(identifier: C.movieDetail) as! MovieDetailViewController
        
        controller.movieSelectDetail = movieSelect
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    
    
        }
}

//MARK: - Call Api and Load movies
extension MoviesViewController : MovieManagerDelegate {
    func didUpdateMovie(_ movieManager: MovieManager, movie: [MovieModel]) {
        DispatchQueue.main.async {
            self.movies = movie
            self.results = movie[0].resultOrder
        }
    }
    
    func didFailWithError(error: Error) {
        viewError.isHidden = false
    }
    
    
}
