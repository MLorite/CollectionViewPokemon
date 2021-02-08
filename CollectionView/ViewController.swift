//
//  ViewController.swift
//  CollectionView
//
//  Created by Josi on 15/01/2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    
    
    var pokemons : [Pokemon?] = []
    var images : [UIImage?] = []
    let MAX_POKEMONS = 200 // Maximo 898 pokemons
    var connection = Connection()
    var totalPokemons = 0 //Contador del ActivityIndicator
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.isHidden = true

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        collectionView.collectionViewLayout = layout
        
        collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        pokemons = [Pokemon?](repeating: nil, count: MAX_POKEMONS)
        images = [UIImage?](repeating: nil, count: MAX_POKEMONS)
        
        for i in 1...MAX_POKEMONS{
            connection.getPokemon(withId: i) { [self] pokemon, id in
                if let pokemon = pokemon {
                    self.pokemons[id-1] = pokemon
                    if let image = pokemon.sprites?.front_default {
                        connection.getSprite(withURLString: image, id: id) { (image, id) in
                            self.totalPokemons += 1
                            print("Descarga imagen del pokemon \(i) + de un total de \(totalPokemons) pokemons")
                            if let image = image {
                                self.images[id-1] = image
                            }
                            if totalPokemons == MAX_POKEMONS {
                                DispatchQueue.main.async {
                                    self.collectionView.reloadData()
                                    collectionView.isHidden = false
                                    activityIndicator.isHidden = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func AddPokemon(_ sender: Any) {
        let newPokemon = Pokemon()
        newPokemon.id = pokemons.count
        newPokemon.name = "Poke \(pokemons.count)"
        let newImage = "👾".image()
        pokemons.append(newPokemon)
        images.append(newImage)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func Editing(_ sender: Any) {
        collectionView.isEditing.toggle()
        editBarButtonItem.title = collectionView.isEditing ? "Done" : "Edit"
        collectionView.backgroundColor = collectionView.isEditing ? UIColor.red : UIColor.white
    }
}

extension String {
    func image(pointSize: CGFloat = UIFont.systemFontSize) -> UIImage? {
        let nsString = self as NSString
        let font = UIFont.systemFont(ofSize: pointSize)

        let size = nsString.size(withAttributes: [.font: font])
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let rect = CGRect(origin: .zero, size: size)
        nsString.draw(in: rect, withAttributes: [.font: font])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if editBarButtonItem.title == "Done" {
            print("Borrar \(indexPath.row) + \(pokemons[indexPath.row]?.name)")
            pokemons.remove(at: indexPath.row)
            images.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
        } else {
            collectionView.deselectItem(at: indexPath, animated: true)
        
            print("You tapped me \(indexPath.row) + \(pokemons[indexPath.row]?.name)")
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
            vc?.pokemon = pokemons[indexPath.row]
            vc?.imagePokemon = images[indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.identifier, for: indexPath) as! MyCollectionViewCell
        
        //cell.configure(with: UIImage(named: "Image")!)
        cell.configure(with: images[indexPath.row] ?? UIImage(named: "Image")!)
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}



