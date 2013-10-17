//
//  BHFileUpload.m
//  Brainhoney
//
//  Created by mattneary on 10/1/13.
//  Copyright (c) 2013 mattneary. All rights reserved.
//

#import "BHFileUpload.h"
#import "AFNetworking.h"

@implementation BHFileUpload
- (NSString *)endpoint {
    // based on a user's settings, the endpoint to which to upload
    id devswitch = [[NSUserDefaults standardUserDefaults] valueForKey:@"devswitch"];
    return [devswitch intValue] ? @"https://bwhst.brainhoney.com/Content/Assignment.ashx" : @"https://bwhs.brainhoney.com/Content/Assignment.ashx";
}
- (void)uploadForStudent: (NSString *)cookie inClass: (NSString *)enrollment forItem: (NSString *)itemid {
    // prepare cached file
    NSURL *file = [NSURL fileURLWithPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"file_url"]];
    
    // allocate a request manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // set headers
    [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Accept"];
    
    // define parameters
    NSDictionary *parameters = @{@"enrollmentid": enrollment, @"actiontype": @"submit", @"itemid": itemid};
    
    // send the POST request
    [manager POST:self.endpoint parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // attach the file
        [formData appendPartWithFileURL:file name:@"attachment" error:nil];
    } success:^(AFHTTPRequestOperation *operation, NSString *responseObject) {
        [self.delegate uploadSucceeded:[responseObject isEqualToString:@"success"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
@end