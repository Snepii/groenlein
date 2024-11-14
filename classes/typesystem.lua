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
    },
    Outer = {
        Top = {
            Left = "otl",
            Middle = "otm",
            Right = "otr"
        },
        Middle = {
            Left = "oml",
            Right = "omr",
            Middle = "mm"
        },
        Bottom = {
            Left = "obl",
            Middle = "obm",
            Right = "obr"
        }
    }
}

return TypeSystem