//
//  Core.h
//  iSubversion
//
//  Created by Satoshi Konno on 10/09/10.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SVN/Pool.h"

@interface Core : NSObject {
	Pool	*pool;
}
@property(retain) Pool *pool;
- (id)init;
- (id)initWithPool:(Pool *)aPool;
@end
