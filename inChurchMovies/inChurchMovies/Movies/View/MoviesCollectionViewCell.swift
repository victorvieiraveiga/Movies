//
//  MoviesCollectionViewCell.swift
//  inChurchMovies
//
//  Created by Victor Vieira Veiga on 19/01/21.
//

import UIKit
import RealmSwift

class MoviesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageStar: UIImageView!
    
    let c = Constants()

    //Set elements of View Screen
    func loadingCellView (movie : [Movie], indexPath: Int, favoriteMovie: Bool) {
        
        if let title = movie[indexPath].title as? String {
            labelTitle.text = title
        }
            if favoriteMovie == true {
                imageStar.image = UIImage(systemName: "star.fill")
                imageStar.tintColor = UIColor.systemYellow
                
            } else {
                imageStar.image = UIImage(systemName: "star")
                imageStar.tintColor = UIColor.lightGray
            }
 

        
        //Method to get the image of movie
        if let moviePosterPath = movie[indexPath].poster_path as? String {
            
        let imageUrl = URL(string:c.BaseImageURL+moviePosterPath)!
        let imageRequest = URLRequest(url: imageUrl)
        let imageCache = URLCache.shared
        
        if let data = imageCache.cachedResponse(for: imageRequest)?.data, let image = UIImage(data: data) {
            DispatchQueue.main.async {
                    
                self.imageView.image = image
                         //cellSpinner.stopAnimating()
                     }
            
        }else {
            URLSession.shared.dataTask(with: imageRequest, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    imageCache.storeCachedResponse(cachedData, for: imageRequest)
                    
                    DispatchQueue.main.async {
                           
                        self.imageView.image = image
                    }
                }
            }).resume()
        }
        }
    }

}
