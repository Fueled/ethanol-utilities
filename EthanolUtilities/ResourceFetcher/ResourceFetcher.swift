//
//  ResourceFetcher.swift
//  SwiftTests
//
//  Created by Ravindra Soni on 31/08/2015.
//  Copyright © 2015 Fueled Inc. All rights reserved.
//

import Foundation

public typealias ResourceFetcherCompletionHandler =
  (success: Bool, hasMoreDataToLoad: Bool, objects: [AnyObject]?, resourceFetcher: AnyObject?, error: AnyObject?) -> Void

public typealias ExternalAPICompletionHandler =
  (success: Bool, objects: [AnyObject]?, error: AnyObject?) -> Void

public class ResourceFetcher: NSObject {
  
  static let defaultPageLimit = 20
  static let initialPage = 1
  
  private (set) public var allObjects = [AnyObject]()

  private (set) public var isLoading = false

  private var currentPage = ResourceFetcher.initialPage
  
  private var pageLimit = ResourceFetcher.defaultPageLimit
  
  private var advanceLoadedObjects: [AnyObject]?
  
  private var nextLoadBlock: ResourceFetcherCompletionHandler?
  
  // MARK: Initializers
  init(pageLimit: Int) {
    self.pageLimit = pageLimit
    super.init()
  }

  override convenience init () {
    self.init(pageLimit: ResourceFetcher.defaultPageLimit)
  }

  // MARK: Public Methods
	public func startFetchingProducts(completionHandler:ResourceFetcherCompletionHandler?) {
    if(isLoading) {
      if let completionHandler = completionHandler {
        completionHandler(success:false, hasMoreDataToLoad:true, objects:nil, resourceFetcher:nil, error:nil)
      }
      return
    }
    
    resetAllInfo()
    
    loadNextPages(ResourceFetcher.initialPage) {
		(success, hasMoreDataToLoad, objects, resourceFetcher, error) in
      let loadedObjects = objects!
      var moreDataToLoad = hasMoreDataToLoad
      if success {
        self.allObjects.removeAll()
        self.allObjects.append(loadedObjects)
        
        if hasMoreDataToLoad {
          self.fetchNextPage(false, completionHandler: nil)
        }
      }
      else {
        moreDataToLoad = false
      }
      
      if let completion = completionHandler {
        completion(success:success, hasMoreDataToLoad:moreDataToLoad, objects:objects, resourceFetcher:self, error:nil)
      }
    }
  }

  public func fetchNextPage(completionHandler:ResourceFetcherCompletionHandler? = nil) {
    fetchNextPage(true, completionHandler: completionHandler)
  }
  
  public func fetchPage(pageNumber:Int = 1, pageLimit: Int = ResourceFetcher.defaultPageLimit, completionHandler:ExternalAPICompletionHandler?) {
    assertionFailure("This method needs to be implemented in the subclass")
  }

  
  // MARK: Private Methods
  
  private func resetAllInfo() {
    currentPage = ResourceFetcher.initialPage
    advanceLoadedObjects = nil
  }

  private func fetchNextPage(userInitiated:Bool = false, completionHandler:ResourceFetcherCompletionHandler? = nil) {
    if userInitiated {
      /* If user initiated, check if there are advance loaded objects.
        If exists then send loaded objects back, and load next batch.
      */
      if let advanceLoadedObjects = advanceLoadedObjects {
        allObjects.append(advanceLoadedObjects)

        if let completionHandler = completionHandler {
          let hasMoreDataToLoad = advanceLoadedObjects.count >= self.pageLimit
          completionHandler(success: true, hasMoreDataToLoad: hasMoreDataToLoad, objects: advanceLoadedObjects, resourceFetcher: self, error: nil)
        }
        
        self.advanceLoadedObjects = nil
      }
      else {
        //Setting Next Block
        nextLoadBlock = completionHandler

        //Already Loading. So return. you'll get data in nextLoadBlock
        if isLoading {
          return
        }
      }
    }

    self.loadNextPages(1) { (success, hasMoreDataToLoad, objects, resourceFetcher, error) in
      if success {
        //Load complete. Checking Next Block
        if let nextLoadBlock = self.nextLoadBlock {
          if let objects = objects {
            self.allObjects.append(objects)
          }
          //Passing Next Block
          nextLoadBlock(success: success, hasMoreDataToLoad: hasMoreDataToLoad, objects: objects, resourceFetcher: self, error: nil)
          self.nextLoadBlock = nil
          
          if hasMoreDataToLoad {
            self.fetchNextPage(false, completionHandler: nil)
          }
          
        }
        else {
          //no Next Block. Save to advance
          self.advanceLoadedObjects = objects
        }
      }
      else {
        if let nextLoadBlock = self.nextLoadBlock {
          //Call Failed. Passing saved nextLoadBlock");
          nextLoadBlock(success: success, hasMoreDataToLoad: hasMoreDataToLoad, objects: objects, resourceFetcher: self, error: error)
          self.nextLoadBlock = nil
        }
      }
    }
  }

  private func loadNextPages(numberOfPages:Int = 1, completionHandler:ResourceFetcherCompletionHandler? = nil) {
    isLoading = true
    
    print("xxxx Fetching Page \(self.currentPage)")
    
    self.fetchPage(self.currentPage, pageLimit: self.pageLimit * numberOfPages) {
      (success, objects, error) in
      var moreDataToLoad = true
      if success {
        if objects?.count >= self.pageLimit { /** excellent use of optional :) :thumbsup: */
          moreDataToLoad = true
        } /** Indentation? -> Refer Style guide please :P */
        else {
          moreDataToLoad = false
        }
        //incremented currentPage
        self.currentPage += numberOfPages
      }
      
      //Loading Finished
      self.isLoading = false
      
      if let completionHandler = completionHandler {
        completionHandler(success: success, hasMoreDataToLoad: moreDataToLoad, objects: objects, resourceFetcher: self, error: error)
      }
      
    }
  }

}