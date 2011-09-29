//
//  Pool.h
//  iSubversion
//
//  Created by Satoshi Konno on 10/09/07.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <SVN/Core.h>

#include <svn_pools.h>

@interface Pool : Core {
	apr_pool_t *pool;
}
@property(assign) apr_pool_t *pool;
- (id)init;
- (id)initWithPool:(Pool *)aPool;
- (void)clear;
@end
