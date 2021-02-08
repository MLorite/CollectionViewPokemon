//
//  DetailViewController.swift
//  CollectionView
//
//  Created by Josi on 15/01/2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imagenView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemon : Pokemon?
    var imagePokemon : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let poke = pokemon, let image = imagePokemon {
            self.nameLabel.text = poke.name
            self.imagenView.image = image
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
