//
//  Connection.swift
//  CollectionView
//
//  Created by Josi on 15/01/2021.
//

import UIKit

class Connection {
    let baseURLString = "https://pokeapi.co/api/v2/"
    
    func getPokemon(withId id: Int, completion: @escaping(_ pokemon: Pokemon?, _ id: Int) -> Void ){
        guard let url = URL(string: "\(baseURLString)pokemon/\(id)") else {
            completion(nil,0)
            return
        }
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: url) { data, response, error in
            if error == nil, let data = data {
                let pokemon = Pokemon(withJSONData: data)
                completion(pokemon, id)
            } else {
                completion(nil, 0)
            }
        }
        task.resume()
    }
    
    func getSprite(withURLString urlString: String, id: Int, completion: @escaping(_ image: UIImage?, _ id: Int) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil, 0)
            return
        }
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: url) { data, response, error in
            if error == nil, let data = data {
                let image = UIImage(data: data)
                completion(image, id)
            } else {
                completion(nil, 0)
            }
        }
        task.resume()
    }
}
