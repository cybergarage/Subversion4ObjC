//
//  Auth.h
//  iSubversion
//
//  Created by Satoshi Konno on 10/09/10.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SVN/Pool.h>

#include <svn_auth.h>

@interface AuthCred : NSObject {
}
@property(retain) NSString *user;
@property(retain) NSString *password;
@property(retain) NSString *realm;
- (id)init;
-(BOOL)hasUser;
-(BOOL)hasPassword;
@end

@protocol AuthDelegate
- (BOOL)simplePrompt:(AuthCred *)authCred object:(NSObject *)object;
- (BOOL)usernamePrompt:(AuthCred *)authCred object:(NSObject *)object;
@end

@interface Auth : Pool {
}

@property(nonatomic, assign) apr_array_header_t *providers;
@property(nonatomic, assign) id<AuthDelegate> delegate;
@property(assign) NSObject *delegateObject;

- (id)init;

@end

