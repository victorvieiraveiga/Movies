//
//  Constants.swift
//  inChurchMovies
//
//  Created by Victor Vieira Veiga on 19/01/21.
//

import Foundation

struct Constants {
    
     let baseURL = "https://api.themoviedb.org/3/"
     let apiKey = "?api_key=da49251803522d8d04033aed26182314"
     let moviePath = "movie/popular"
     let genrePath = "genre/movie/list"
     let BaseImageURL = "https://image.tmdb.org/t/p/w780"
     let backPlaceholder = URL(fileURLWithPath: "/Movs/Movs/Assets.xcassets/placeholder.imageset/placeholder.png")
     let BaseGenreURL = "https://api.themoviedb.org/3/genre/movie/list?api_key=3d3a97b3f7d3075c078e242196e44533&language=en-US"
    
    //Indentification collectionView
    let cel : String = "cell"
    
    //Indentification of View MovieDetalViewControler
    let movieDetail : String = "movieDetail"
}
