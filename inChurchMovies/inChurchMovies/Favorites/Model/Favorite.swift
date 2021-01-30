//
//  Favorite.swift
//  inChurchMovies
//
//  Created by Victor Vieira Veiga on 21/01/21.
//

import Foundation
import RealmSwift

class Favorite : Object {
    //model of favorite data object using Realm.
    @objc dynamic var idMovie: Int = 0
    @objc dynamic var title: String?
    @objc dynamic var overview : String?
    @objc dynamic var date : String?
    @objc dynamic var posterDropImage : String?
    
    //get movies favorited from Realm database
    func getFavorite() -> Results<Favorite>{
       
        let realm = try! Realm()
        var favorite : Results<Favorite>?
        favorite = realm.objects(Favorite.self)
        
        return favorite!
    }
}

