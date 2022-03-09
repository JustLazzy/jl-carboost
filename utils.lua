-- This is the vehicle modification stuff
WindowTint = {  
	'WINDOWTINT_PURE_BLACK',  
	'WINDOWTINT_DARKSMOKE',  
	'WINDOWTINT_LIGHTSMOKE',  
	'WINDOWTINT_STOCK',  
	'WINDOWTINT_LIMO',  
	'WINDOWTINT_GREEN'  
};

NeonColor = {
    -- white
    [1] = {
        222,
        222,
        255
    },
    -- Electric Blue	
    [2] = {
        3,
        83,
        255
    },
    -- Red
    [3] = {
        255,
        1,
        1
    },
    -- Hot Pink	
    [4] = {
        255,
        5,
        190
    },
    -- tomato
    [5] = {
        255,
        99,
        71
    },
    -- pale green	
    [6] = {
        152,
        251,
        152
    },
    -- 	slate blue
    [7] = {
        106,
        90,
        205
    },
    -- hot pink	
    [8] = {
        255,
        105,
        180
    },
    -- midnight blue	
    [9] = {
        25,
        25,
        112
    }
}

VehProp = {
    windowTint = WindowTint[math.random(#WindowTint)],
    neonEnabled = {
        [1] = true,
        [2] = true,
        [3] = true,
        [4] = true
    },
    neonColor = NeonColor[math.random(#NeonColor)],
}

