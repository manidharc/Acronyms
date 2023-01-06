//
//  AcronymsViewModel.swift
//  Acronyms
//
//  Created by Manidhar Gupta Chittanuri on 1/6/23.
//

import Foundation

let basicAPI = "http://www.nactem.ac.uk/software/acromine/dictionary.py?"

class AcronymsViewModel {
    
    func getFullForms(searchKey: String, completionHandler: @escaping (Result<[AcronymsSFFeed], Error>) -> Void) {
        
        if Reachability.isConnectedToNetwork() {
            guard let url = URL(string: basicAPI+"sf=\(searchKey)") else {
                return
            }
            let urlReq = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
                if error != nil {
                    if let errorDet = error {
                        completionHandler(.failure(errorDet))
                    }
                    
                } else {
                    guard let data = data else {
                        return
                    }
                    let decoder = JSONDecoder()
                    guard let acronymsInfo = try? decoder.decode([AcronymsSFFeed].self, from: data) else {
                        return
                    }
                    completionHandler(.success(acronymsInfo))
                }
                
            }.resume()
        } else {
            let error = NSError(domain: "com.acronym.test",
                                code: 0,
                                userInfo: [NSLocalizedDescriptionKey: "Please check your network connection and try again"])
            completionHandler(.failure(error))
        }
    }
}
