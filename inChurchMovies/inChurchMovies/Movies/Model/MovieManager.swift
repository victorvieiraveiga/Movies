//
//  MovieManager.swift
//  inChurchMovies
//
//  Created by Victor Vieira Veiga on 19/01/21.
//

import Foundation


protocol MovieManagerDelegate {
    func didUpdateMovie (_ movieManager : MovieManager, movie: [MovieModel])
    func didFailWithError(error: Error)
}

private let sessionConfiguration: URLSessionConfiguration = {
    let config = URLSessionConfiguration.default
    config.allowsCellularAccess = true
    config.timeoutIntervalForRequest = 20.0
    config.httpMaximumConnectionsPerHost = 10
    return config
}()

let C = Constants ()

struct MovieManager {
    let movieUrl = C.baseURL + C.moviePath + C.apiKey
    var isPaginating : Bool = false
    var delegate: MovieManagerDelegate?
    
     func fetchMovie () {
        performRequest(with: movieUrl)
    }
    
     func performRequest (with movieUrl: String) {
        
 
        //1. Create a URL
        //Adding the url inside the URL object
        guard let url = URL(string: movieUrl) else {print ("Error url")
            return}
            
            //2. Create a URLSession
            let session = URLSession(configuration: sessionConfiguration)
        
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error! )
                    return
                }
                if let safeData = data {
                    if let movies = self.parseJson(safeData) {
                        self.delegate?.didUpdateMovie(self, movie: [movies])
                        
                   }
                }
            }
            //4. Start the task
            task.resume()
    }
    
    func parseJson (_ movieData: Data) -> MovieModel? {
        let decoder = JSONDecoder()
        
        do {
            let decoderData = try decoder.decode(MovieModel.self, from: movieData)
            
            let page = decoderData.page
            let total_results = decoderData.total_results
            let total_pages = decoderData.total_pages
            let results = decoderData.results
            
            let movie = MovieModel(page: page, total_results: total_results, total_pages: total_pages, results: results)
            
            return movie
    
    } catch  {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
