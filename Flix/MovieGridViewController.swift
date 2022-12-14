//
//  MovieGridViewController.swift
//  Flix
//
//  Created by Jiqing Jacobson on 9/18/22.
//

import UIKit

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {


    @IBOutlet weak var colletionView: UICollectionView!
    
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.colletionView.clipsToBounds = true
        
        colletionView.delegate = self
        colletionView.dataSource = self
        
        let layout = colletionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        // width of the phone = view.frame.size.width
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2 ) / 3
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/634649/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // as! is casting
                self.movies = dataDictionary["results"] as! [[String:Any]]
                self.colletionView.reloadData()
                print(self.movies)
                
            }
        }
        task.resume()
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        // URL is a type follow url rules
        let postUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af.setImage(withURL: postUrl!)

        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // prepare the next screen when you are leaving your screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // find the selected movie
        let cell = sender as! UICollectionViewCell
        let indexPath = colletionView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // pass the selected movie to the details view controller
        let gridDetailViewController = segue.destination as! MovieGridDetailsViewController
        gridDetailViewController.movie = movie
        
        colletionView.deselectItem(at: indexPath, animated: true)
    }
    

}
