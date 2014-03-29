//
//  GameGlobals.h
//  Strik
//
//  Created by Nils Wiersema on Mar 19, 2014.
//  Copyright (c) 2014 Strik. All rights reserved.
//

// DEV: override server host (uncomment to use)
#define SERVER_HOST @"192.168.178.20"
#define SERVER_PORT 13381

// Load balancer (default)
#define LOADBALANCER_HOST @"connect.strik.it"
#define LOADBALANCER_PORT 80

// Strik 'red'
#define PLAYER_ONE_COLOR [CCColor colorWithRed:34.0f/255.0f green:189.0f/255.0f blue:175.0f/255.0f]
#define PLAYER_ONE_LIGHT_COLOR [CCColor colorWithRed:145.0f/255.0f green:222.0f/255.0f blue:215.0f/255.0f]

// Strik 'green'
#define PLAYER_TWO_COLOR [CCColor colorWithRed:241.0f/255.0f green:75.0f/255.0f blue:106.0f/255.0f]
#define PLAYER_TWO_LIGHT_COLOR [CCColor colorWithRed:229.0f/255.0f green:168.0f/255.0f blue:179.0f/255.0f]

// Status colors
#define PLAYER_ONLINE_COLOR [CCColor colorWithRed:34.0f/255.0f green:189.0f/255.0f blue:60.0f/255.0f]
#define PLAYER_BUSY_COLOR [CCColor colorWithRed:241.0f/255.0f green:192.0f/255.0f blue:75.0f/255.0f]
#define PLAYER_OFFLINE_COLOR [CCColor colorWithRed:241.0f/255.0f green:75.0f/255.0f blue:75.0f/255.0f]

// Player names (emojis count for multiple chars0
#define MAX_NAME_LENGTH 32

// Music for scenes
#define MUSIC_BACKGROUND_MENU @"bg-piano"