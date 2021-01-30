//
//  FavoriteTableViewCell.swift
//  inChurchMovies
//
//  Created by Victor Vieira Veiga on 21/01/21.
//

import UIKit
import RealmSwift

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewFavorite: UIImageView!
    @IBOutlet weak var labelTitleMovie: UILabel!
    @IBOutlet weak var labelDateRelease: UILabel!
    @IBOutlet weak var labelOverView: UILabel!
    
    var imageBackUrl = URL(string: "")
    let C = Constants()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }


    func configFavorite (favorite: Favorite) {
        
        if let title =  favorite.title {
            labelTitleMovie.text = title
        }
        if let dateRelease = favorite.date {
            labelDateRelease.text = dateRelease
        }
        if let overview = favorite.overview {
            labelOverView.text = overview
        }
        
        if let backdropPath = favorite.posterDropImage {
            self.imageBackUrl = URL(string: C.BaseImageURL+backdropPath)
          } else {
            imageBackUrl = C.backPlaceholder
          }
          
          let imageData = try? Data(contentsOf: imageBackUrl!)
            if let imageData = imageData {
                imageViewFavorite.image = UIImage(data: imageData)
            } else {
                imageViewFavorite.image = UIImage(named: "placeholder")
            }
    }

}
