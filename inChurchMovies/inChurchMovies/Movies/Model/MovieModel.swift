//
//  MoviesModel.swift
//  inChurchMovies
//
//  Created by Victor Vieira Veiga on 19/01/21.
//

import Foundation

struct MovieModel: Codable {
    var page: Int
    var total_results: Int
    var total_pages: Int
    var results: [Movie]
    
    //computed property to sort the results by votes
    var resultOrder : [Movie] {
        return results.sorted() {$0.vote_average > $1.vote_average }
    }
}

struct Movie: Codable {
    var vote_count: Int
    var id: Int
    var video: Bool
    var vote_average: Double
    var title: String
    var popularity: Double
    var poster_path: String
    var original_language: String
    var original_title: String
    var genre_ids: [Int]
    var backdrop_path: String?
    var adult: Bool
    var overview: String
    var release_date: String
    
    
    //computed propert for convert date to format dd/mm/yyyy
    var release_dateFormated: String {
        let dateFormatter = DateFormatter()
        
        //convert string to date
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:release_date)!
        
        //Format date to brasilian pattern
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
}

struct Genre: Codable {
    var genres: [GenreData]
}

struct GenreData: Codable {
    var id: Int
    var name: String?
}
