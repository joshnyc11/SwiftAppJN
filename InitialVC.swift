//
//  ViewController.swift
//  JNCMP432Final
//
//  Created by LC.Student on 5/20/24.
//

import UIKit

class InitialVC: UIViewController {
    
    // This view controller holds the three buttons TopRated, Now Playing ,
    

  
    
    
    //set default values for url, then update as desired
    var apiKey = "b0206b75cd8a25b0c20f5d7c2e0665b1"
    //"MY_API_KEY"
    var language = "en-US"
    var page = 1
    var region = "United%20States"
    
    //opens up now playing view controller
    @IBAction func toNowPlaying () {
        
        
    }
        //opens up top rated view controller
    @IBAction func toTopRated (){
        
        
    }

    
    //this method chooses the buttons for you
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? MovieListVC{
            
            if segue.identifier == "nowPlayingSegue" {
                
                destination.urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=\(language)&page=\(page)"
                
                
            } else{
                
                destination.urlString = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)&language=\(language)&page=\(page)&region=\(region)"
                
            }
            
            
            
            
        }
        
        
        
    }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
        }
        
        
   
    }
    

//will be called in the MovieList class, but it sets the favorite movies.
protocol FavoriteMovieDelegate: AnyObject{
    
    func addFavoriteMovie(favoriteMovie: Movie)
    
    func removeFavoriteMovie(favoriteMovie: Movie)
}

//Need to save and load files from the movieListVC and FavoriteMoviesVC
protocol LoadingFavoriteMoviesDelegate: AnyObject{
    
    
   func documentsDirectory() -> URL
     
   func dataFilePath() -> URL
      
   func loadFavoriteMovies()
    
    
}


