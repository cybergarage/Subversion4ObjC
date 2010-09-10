//
//  Client.h
//  iSubversion
//
//  Created by Satoshi Konno on 10/09/06.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SVN/Core.h>
#import <SVN/Auth.h>
#import <SVN/Fs.h>

#include <svn_client.h>

@interface Client : Core {
@private
	svn_client_ctx_t *ctx;
@public
	Auth *auth;
	Fs *fs;
}

@property(nonatomic, assign) svn_client_ctx_t *ctx;
@property(retain) Auth *auth;
@property(retain) Fs *fs;

- (id)initWithPool:(Pool *)aPool;
- (BOOL)checkout;

@end
