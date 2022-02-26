windowtint = {  
	'WINDOWTINT_PURE_BLACK',  
	'WINDOWTINT_DARKSMOKE',  
	'WINDOWTINT_LIGHTSMOKE',  
	'WINDOWTINT_STOCK',  
	'WINDOWTINT_LIMO',  
	'WINDOWTINT_GREEN'  
};

neonColor = {
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
    }
}

props = {
    windowTint = windowtint[math.random(#windowtint)],
    neonEnabled = {
        [1] = true,
        [2] = true,
        [3] = true,
        [4] = true
    },
    neonColor = neonColor[math.random(#neonColor)],
}

