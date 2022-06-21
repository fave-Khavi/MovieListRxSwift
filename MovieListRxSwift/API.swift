//
//  API.swift
//  MovieListRxSwift
//
//  Created by khavishini suresh on 17/06/2022.
//

import Foundation
import Alamofire

//Getting API
class API {

    fileprivate var baseUrl = ""
    typealias moviesCallBack = (_ movies:Movies?, _ status:Bool, _ message:String) ->Void
    var callBack:moviesCallBack?
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
        
    }
    
    func getMovies(endPoint: String) {
        AF.request(self.baseUrl + endPoint)
            .response { (responseData) in
                guard let data = responseData.data else {
                    self.callBack?(nil, false, "")
                    print("Error")
                    return
                }
                do {
                    let movies = try JSONDecoder().decode(Movies.self, from: data)
                    self.callBack?(movies, true, "")
                } catch {
                    self.callBack?(nil, false, error.localizedDescription)
                    print(String(describing: error))
                }
            }
    }
    
    func completionHandler(callBack:@escaping moviesCallBack) {
        self.callBack = callBack
    }
}
