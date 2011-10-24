//
//  Client.h
//  iSubversion
//
//  Created by Satoshi Konno on 10/09/06.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SVN/Pool.h>
#import <SVN/Auth.h>
#import <SVN/Notify.h>
#import <SVN/Progress.h>
#import <SVN/Status.h>
#import <SVN/Log.h>

#include <svn_client.h>

@protocol ClientDelegate<NSObject>
@optional
- (void)notify:(Notify *)notify object:(NSObject *)object;
- (void)progress:(Progress *)progress object:(NSObject *)object;
- (void)status:(Status *)status object:(NSObject *)object;
- (void)log:(Log *)log object:(NSObject *)object;
- (BOOL)doCancel;
@end

@interface Client : Pool {
}
@property(nonatomic, assign) svn_client_ctx_t *ctx;
@property(retain) Auth *auth;
@property(nonatomic, assign) id<ClientDelegate> delegate;
@property(retain) NSObject *delegateObject;
@property(retain) NSMutableArray *resultSet;
@property(retain) NSString *errorMessage;

- (id)init;
- (BOOL)list:(NSString *)url recurse:(BOOL)recurse;
- (BOOL)checkout:(NSString *)url path:(NSString *)path recurse:(BOOL)recurse;
- (BOOL)update:(NSString *)path recurse:(BOOL)recurse;
- (BOOL)add:(NSString *)path recurse:(BOOL)recurse;
- (BOOL)commit:(NSString *)path message:(NSString *)message recurse:(BOOL)recurse;
- (BOOL)remove:(NSString *)path force:(BOOL)force;
- (BOOL)mkdir:(NSString *)path;
- (BOOL)move:(NSString *)srcPath to:(NSString *)dstPath force:(BOOL)force;
- (BOOL)copy:(Enabled *)srcPath to:(NSString *)dstPath;
- (BOOL)status:(NSString *)path recurse:(BOOL)recurse update:(BOOL)update;
- (BOOL)revert:(NSString *)path recurse:(BOOL)recurse;
- (BOOL)resolved:(NSString *)path recurse:(BOOL)recurse;
- (BOOL)cleanup:(NSString *)path;
- (BOOL)unlock:(NSString *)path;
- (BOOL)log:(NSString *)path;

- (void)setAuthEnabled:(BOOL)flag;
- (BOOL)isAuthEnabled;

@end
