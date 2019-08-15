//
//  YelpSearchViewModel.swift
//  SearchWithYelpAPI
//
//  Created by Krishna  on 8/13/19.
//  Copyright © 2019 Krishna . All rights reserved.
//

import Foundation

class YelpSearchViewModel {
    
    var yelpSearchdata : YelpSearchModel?
    var business :[Business] = []
    let yelpSearchAPI = YelpSearchAPI()
    var businessResponse = 0
    
    func getSearchResults(location:String?, searchText: String?, offset: Int?, completion: @escaping (Error?) -> Void)  {
        yelpSearchAPI.getDataFromApi(location: location, searchTerm: searchText, offset: offset){ result in
            switch result {
            case .success(let response):
                self.yelpSearchdata = response
                self.businessResponse += response.businesses.count
                self.business.append(contentsOf: response.businesses)
                self.business = self.business.sorted(by: { Float($0.rating) > Float($1.rating) })
                //self.business.s

                completion(nil)
            case .failure(let error):
                // Any failute throw the error to completion
                completion(error)
            }
        }
    }
    
    
    
    
    var totalNumberOfPtsInSearchArea : Int {
        return self.business.count
    }
    
    var totalNumberOfPtsWithRatting : Int {
        
        let ptswithRatting =  self.business.compactMap{ $0.rating }.filter({$0 > 0})
        return ptswithRatting.count
    }
    
    var averageRattingforPtsInArea : Float {
        
        let sumofRatting = self.business.compactMap{$0.rating}.reduce(0, +)
        print(sumofRatting )
       // _ = self.yelpSearchdata?.total ?? 0
        let average: Float = Float(sumofRatting ) / Float(self.business.count)
        //Float(self.totalNumberOfPtsWithRatting)
        print(average)
        return average
    }

    var totalNumberOfreviews : Int {
        let totalReviews = self.business.compactMap{$0.reviewCount}.reduce(0, +)
        return totalReviews
    }
    
   
    var numOfSections : Int {
        // As there are only sections keepting this static
        return 1
    }
    
    var numberOfRows : Int? {
        return self.business.count
    }
    
    func business(at index: Int) -> Business? {
        
        if self.business.indices.contains(index) {
            return self.business[index]
        }
        return nil
        
    }
    
}
