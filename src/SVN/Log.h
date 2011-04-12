//
//  Log.h
//  iSubversion
//
//  Created by Satoshi Konno on 11/04/12.
//  Copyright 2011 Satoshi Konno. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Log : NSObject {
    
}
@property(assign) long int revision;
@property(retain) NSString *author;
@property(retain) NSString *date;
@property(retain) NSString *message;
@end
