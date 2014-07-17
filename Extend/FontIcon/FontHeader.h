
#define fontList [NSArray arrayWithObjects:@"fontAwesome.otf",@"foundationIcons.ttf",@"ionIcons.ttf",@"zocialRegularWebfont.ttf",nil]

#define fontAwesome @"FontAwesome"
#define zocialRegularWebfont @"Zocial-Regular"
#define ionIcons @"Ionicons"
#define foundationIcons @"fontcustom"

#define iconFromFontAwesome( __name ) [[NSDictionary objectFromData:[NSData fromResource:@"fontAwesome.json"]] objectForKey:__name]
#define iconFromZocial( __name ) [[NSDictionary objectFromData:[NSData fromResource:@"zocialRegularWebfont.json"]] objectForKey:__name]
#define iconFromIon( __name ) [[NSDictionary objectFromData:[NSData fromResource:@"ionIcons.json"]] objectForKey:__name]
#define iconFromFoundation( __name ) [[NSDictionary objectFromData:[NSData fromResource:@"foundationIcons.json"]] objectForKey:__name]
