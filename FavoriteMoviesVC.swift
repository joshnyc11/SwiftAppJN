//
//  FavoriteMoviesVC.swift
//  JNCMP432Final
//
//  Created by LC.Student on 5/21/24.
//

import UIKit

class FavoriteMoviesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, LoadingFavoriteMoviesDelegate{
    
    
    
    
  //intially empty array of movies, that will add movies to the list 
    var favoriteMovies: [Movie] = []
    
    
    //tableview
    @IBOutlet weak var favoritesTableView : UITableView!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        
        favoritesTableView.reloadData()
        
        loadFavoriteMovies()
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
        
        
        
        var cellContent = cell.defaultContentConfiguration()
        cellContent.text =  favoriteMovies[indexPath.row].original_title
        cell.contentConfiguration = cellContent
        
        
        return cell
        
        
    }
    
   
    func documentsDirectory() -> URL {
      let paths = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask)
      return paths[0]
    }

  func dataFilePath() -> URL {
      return documentsDirectory().appendingPathComponent("Favorites.plist")
    }

   
    

   
    func loadFavoriteMovies() {
      
        
      let path = dataFilePath()
      // attempt to save data to a variable
        if let data = try? Data(contentsOf: path) {
            
            
            let decoder = PropertyListDecoder()
            do {
                // If successfull, decodes the data into an array of Movie objects
                favoriteMovies = try decoder.decode([Movie].self,from: data)
            } catch {
                print("Error decoding array favorite movies : \(error.localizedDescription)")
            }
        }
    }
    
        
    
   
   

}
