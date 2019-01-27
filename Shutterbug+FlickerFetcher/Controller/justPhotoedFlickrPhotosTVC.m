//
//  justPhotoedFlickrPhotosTVC.m
//  Shutterbug+FlickerFetcher
//
//  Created by JihoonPark on 21/11/2018.
//  Copyright © 2018 JihoonPark. All rights reserved.
//

#import "justPhotoedFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@interface justPhotoedFlickrPhotosTVC ()

@end

@implementation justPhotoedFlickrPhotosTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchPhotos];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(IBAction)fetchPhotos{
    [self.refreshControl beginRefreshing];
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSData * jsonResults = [NSData dataWithContentsOfURL:url];
        NSDictionary * propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
        NSLog(@"Flickr result = %@", propertyListResults);
        
        NSArray *photos = [[propertyListResults valueForKey:@"photos"]valueForKey:@"photo"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = photos;
        });
    });
}

@end
