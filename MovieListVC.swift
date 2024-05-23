//
//  MovieListVC.swift
//  JNCMP432Final
//
//  Created by LC.Student on 5/20/24.
//

import UIKit

class MovieListVC: UIViewController,  UITableViewDelegate , UITableViewDataSource, LoadingFavoriteMoviesDelegate, FavoriteMovieDelegate  {
    
    

    
    //object of the request response struct
    var myMovie: requestResponse?
    
    //empty array to be populated with movie information
    var myMovies = [Movie]()
    
    var urlString = ""
    
    //empty array to keep track of favorite movies
    
    
   
    
    var favoriteMovies = [Movie]()
    
    @IBOutlet weak var movieTableView : UITableView!
    
    
    
    let reuseIdentifier = "myCell"
    
    
    
    //method that gets the json data and decodes it
    func fetchMovieData(completion: @escaping(requestResponse) -> Void){
        
        
        
        
        guard let url = URL(string: urlString)
                
                
                
            
    
        else {return}
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error{
                
                print("Error loading movies:  \(error.localizedDescription)")
            }
            
            guard let jsonData = data
            else {return}
            
            let decoder = JSONDecoder()
            
            
            do {
                let decodedData = try decoder.decode(requestResponse.self, from: jsonData)
                
                
                
                self.myMovie = decodedData
                self.myMovies = self.myMovie!.results
                
                
              
                //updates happen here
                DispatchQueue.main.async {
                    
                    //reloads data to reflect any new information
                    self.movieTableView.reloadData()
                    
                    
                    
                    completion(decodedData)
                }
                
                
                
            } catch {
                
                
                print("Error decoding data.")
            }
            
            
        }
        
        dataTask.resume()
    }
    
    
    
    
    
    override func viewDidLoad() {
        
        
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        
        
        fetchMovieData { anyMovie in
            
            //don't need to run any code here.
        }
        
        
        
        print("Documents folder is \(documentsDirectory())")
        print("Data file path is \(dataFilePath())")
        
        loadFavoriteMovies()
        
        super.viewDidLoad()
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return number of elements in array
        return myMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = movieTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        
        
        var cellContent = cell.defaultContentConfiguration()
        cellContent.text =  myMovies[indexPath.row].original_title
        cell.contentConfiguration = cellContent
        
        
        // displays a checkmark if movie is in favorite movies
                if favoriteMovies.contains(where: { $0.id == myMovies[indexPath.row].id }) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
                
               
        
        return cell
        
    }
    
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
        performSegue(withIdentifier: "movieDetailsSegue", sender: indexPath.row)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            if segue.identifier == "movieDetailsSegue",
               
               let destination = segue.destination as? MovieDetailsVC,
               
               let selectedIndex = sender as? Int {
                
                destination.movieInfo = myMovies[selectedIndex]
                destination.delegate = self
                
            }
        
              else if segue.identifier == "movieListToFavoritesSegue",
                      
                      let destination = segue.destination as? FavoriteMoviesVC {
                destination.favoriteMovies = favoriteMovies
            }
        }
    
    
    func addFavoriteMovie(favoriteMovie newMovie : Movie) {
        
            if !favoriteMovies.contains(where: { $0.id == newMovie.id }) {
                favoriteMovies.append(newMovie)
            }
            movieTableView.reloadData()
        
        saveFavoriteMovies ()
        
        }
    
    func removeFavoriteMovie(favoriteMovie removeMovie: Movie) {
        
        if let index = favoriteMovies.firstIndex(where: { $0.id == removeMovie.id }) {
            
            favoriteMovies.remove(at: index)
            
            
        }
        movieTableView.reloadData()
        
        saveFavoriteMovies ()
     
        
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
    
    
    
    //saves the movies
   func saveFavoriteMovies (){
        
        let encoder = PropertyListEncoder()
        
        do {
            
            //tries to encode favoriteMoviesArray
            let data = try encoder.encode(favoriteMovies)
            // write data to file if error free
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch { // we catch any errors if they occur
            print("Error encoding favorite movies array: \(error.localizedDescription)")
        }
        
    }
    
    //loads the movies 
    func loadFavoriteMovies() {
      
        
      let path = dataFilePath()
      // attempt to save data to a variable
        if let data = try? Data(contentsOf: path) {
            
            let decoder = PropertyListDecoder()
            do {
                
                favoriteMovies = try decoder.decode([Movie].self,from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
    
    

   
   
}
