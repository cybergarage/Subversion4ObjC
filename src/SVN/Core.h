//
//  Core.h
//  iSubversion
//
//  Created by Satoshi Konno on 10/09/10.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Core : NSObject {
}
@property(assign) const void *cObject;
- (id)init;
- (id)initWithCObject:(const void *)cObj;
@end
