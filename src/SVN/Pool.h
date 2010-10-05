//
//  Pool.h
//  iSubversion
//
//  Created by Satoshi Konno on 10/09/07.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <svn_pools.h>

@interface Pool : NSObject {
	apr_pool_t *pool;
}
@property(assign) apr_pool_t *pool;
+ (Pool *)sharedInstance;
-(id)init;
- (id)initWithPool:(Pool *)aPool;
@end
