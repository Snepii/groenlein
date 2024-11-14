local TypeSystem = {}

TypeSystem.Types = {
    Ground = {
        Grass = "grass",
        Rock = "rock",
        Dirt = "dirt"
    }
}

TypeSystem.Variants = {
    Default = "undef",
    Top = {
        Left = "tl",
        Middle = "tm",
        Right = "tr"
    },
    Middle = {
        Left = "ml",
        Middle = "mm",
        Right = "mr"
    },
    Bottom = {
        Left = "bl",
        Middle = "bm",
        Right = "br"
    }
}

return TypeSystem