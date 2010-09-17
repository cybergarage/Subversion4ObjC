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
#import <SVN/Notify.h>

#include <svn_client.h>

@protocol ClientDelegate
- (BOOL)notify:(Notify *)notify object:(NSObject *)object;
@end

@interface Client : Core {
@private
	svn_client_ctx_t *ctx;
@public
	Auth *auth;
	Fs *fs;
	id<ClientDelegate> delegate;
	NSObject *delegateObject;
}

@property(nonatomic, assign) svn_client_ctx_t *ctx;
@property(retain) Auth *auth;
@property(retain) Fs *fs;
@property(nonatomic, assign) id<ClientDelegate> delegate;
@property(retain) NSObject *delegateObject;

- (id)init;
- (id)initWithPool:(Pool *)aPool;
- (BOOL)checkout;
- (BOOL)ls:(NSString *)url;

@end
