//
//  AirlineSelectView.m
//  Luggage Telep
//
//  Created by mac on 10/10/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "AirlineSelectView.h"

@implementation AirlineSelectView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;

    self.textLabel.font = [UIFont systemFontOfSize:self.textLabel.font.pointSize
                                            weight:selected ? UIFontWeightMedium : UIFontWeightLight];
}

@end
