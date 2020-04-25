//
//  Crypto.h
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 14/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Crypto : NSObject
+(NSData*)applyXOR:(NSData*)data forHash:(NSString*)hash;
@end

NS_ASSUME_NONNULL_END
