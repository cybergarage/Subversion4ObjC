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
#import <SVN/Progress.h>

#include <svn_client.h>

@protocol ClientDelegate<NSObject>
@optional
- (void)notify:(Notify *)notify object:(NSObject *)object;
- (void)progress:(Progress *)progress object:(NSObject *)object;
- (BOOL)doCancel;
@end

@interface Client : Core {
@private
	svn_client_ctx_t *ctx;
@public
	Auth *auth;
	Fs *fs;
	id<ClientDelegate> delegate;
	NSObject *delegateObject;
	NSArray *lists;
	NSString *errorMessage;
}

@property(nonatomic, assign) svn_client_ctx_t *ctx;
@property(retain) Auth *auth;
@property(retain) Fs *fs;
@property(nonatomic, assign) id<ClientDelegate> delegate;
@property(retain) NSObject *delegateObject;
@property(retain) NSArray *lists;
@property(retain) NSString *errorMessage;

- (id)init;
- (id)initWithPool:(Pool *)aPool;
- (BOOL)list:(NSString *)url recurse:(BOOL)recurse;
- (BOOL)checkout:(NSString *)url path:(NSString *)path recurse:(BOOL)recurse;
- (BOOL)update:(NSString *)path recurse:(BOOL)recurse;
@end
