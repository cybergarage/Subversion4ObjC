//
//  Client.h
//  iSubversion
//
//  Created by Satoshi Konno on 10/09/06.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <svn_client.h>

@interface Client : NSObject {
@private
	svn_client_ctx_t *ctx;
}

- (BOOL)checkout;

@end
