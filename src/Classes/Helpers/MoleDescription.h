//
//  MoleDescription.h
//  Mole
//
//  Created by James Kong on 5/25/13.
//
//

#import <Foundation/Foundation.h>
#import "Sparrow.h"
@interface MoleDescription : SPSprite

- (id)initWithName:(NSString*)name description:(NSString*)description;

@property (nonatomic) NSString* name;
@property (nonatomic) NSString* myText;;
@end
