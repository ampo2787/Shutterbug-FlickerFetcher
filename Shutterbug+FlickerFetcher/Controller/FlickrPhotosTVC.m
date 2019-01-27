//
//  FlickrPhotosTVC.m
//  Shutterbug+FlickerFetcher
//
//  Created by JihoonPark on 20/11/2018.
//  Copyright © 2018 JihoonPark. All rights reserved.
//

#import "FlickrPhotosTVC.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface FlickrPhotosTVC ()

@end

@implementation FlickrPhotosTVC

#pragma mark - private method
- (void)setPhotos:(NSArray *)photos{
    _photos = photos;
    [self.tableView reloadData];
}

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.photos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"Flickr Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    
    NSDictionary *photo = self.photos[indexPath.row];
    [cell.textLabel setText:[photo valueForKey:FLICKR_PHOTO_TITLE]];
    [cell.detailTextLabel setText:[photo valueForKey:FLICKR_PHOTO_DESCRIPTION]];
    
    return cell;
}

- (void)prepareImageViewController:(ImageViewController *)ivc toDisplayPhto:(NSDictionary *)photo{
    ivc.imageURL = [FlickrFetcher URLforPhoto:photo format:(FlickrPhotoFormatLarge)];
    ivc.title = [photo valueForKey:FLICKR_PHOTO_TITLE];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([sender isKindOfClass:[UITableViewCell class]]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if(indexPath){
            if([segue.identifier isEqualToString:@"Display Photo"]){
                if([segue.destinationViewController isKindOfClass:[UINavigationController class]]){
                    id detail = nil;
                    detail = [((UINavigationController *)segue.destinationViewController).viewControllers firstObject];
                    [self prepareImageViewController:detail toDisplayPhto:self.photos[indexPath.row]];
                }
                else{
                    [self prepareImageViewController:segue.destinationViewController toDisplayPhto:self.photos[indexPath.row]];
                }
            }
        }
    }
}

@end
