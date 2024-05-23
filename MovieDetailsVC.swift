

//
//  MovieDetailsVC.swift
//  JNCMP432Final
//
//  Created by LC.Student on 5/20/24.
//
import UIKit
class MovieDetailsVC: UIViewController {

    
    
    //add a movie to the favorites list
    weak var delegate: FavoriteMovieDelegate?
    
    
    //object of Movie struct
    var movieInfo: Movie?
    
    
    
    
    //outlets
    @IBOutlet weak var movieImageView : UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var releaseLabel : UILabel!
    @IBOutlet weak var overviewLabel : UILabel!
    
    
    //triggers the delegate method that adds a movie to favorite
    @IBAction func addToFavoritesButtonTapped(sender: Any){
        
        if let movie = movieInfo{
            
            delegate?.addFavoriteMovie(favoriteMovie:movie)
            
        }
        navigationController?.popViewController(animated: true)
      
    }
    
    //triggers delegate method that removes movie from favorites
    @IBAction func removeFromFavoritesButtonTapped(sender: Any){
        
        if let movie = movieInfo{
            
            delegate?.removeFavoriteMovie(favoriteMovie: movie)
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //setting the text of the labels
        
        titleLabel.text = movieInfo?.original_title
        releaseLabel.text = movieInfo?.release_date
        overviewLabel.text = movieInfo?.overview
        
        
        let imageURL = "https://image.tmdb.org/t/p/w500/" + movieInfo!.poster_path
        
        movieImageView.downloadImage(from: imageURL)
        
        
    }
    
   
   
}
extension UIImageView {
    
    //download an image, and set to the UIImageView
func downloadImage(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
   
    contentMode = mode
    
    //create dataTask to download URL contents
    URLSession.shared.dataTask(with: url) { data, response, error in
        
        //if successful response (status code 200) cast response as HTTP
        guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            
                
            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
            let data = data, error == nil,
            let image = UIImage(data: data)
            else { return }
        
        DispatchQueue.main.async() { [weak self] in
            self?.image = image
        }
    }.resume()
}
    
    
func downloadImage(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
    guard let url = URL(string: link) else { return }
    downloadImage(from: url, contentMode: mode)
}
    
  
    
}




