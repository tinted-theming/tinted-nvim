-- Minimal tinted8 palette fixture for tests.
return {
    variant = "dark",
    palette = {
        black = { normal = "#000000", bright = "#111111" },
        gray = { dim = "#222222", normal = "#333333", bright = "#444444" },
        white = { dim = "#666666", normal = "#555555", bright = "#777777" },
        red = { normal = "#880000", bright = "#cc0000" },
        orange = { normal = "#884400", bright = "#cc6600" },
        yellow = { normal = "#888800", bright = "#cccc00" },
        green = { normal = "#008800", bright = "#00cc00" },
        cyan = { normal = "#008888", bright = "#00cccc" },
        blue = { normal = "#000088", bright = "#0000cc" },
        magenta = { normal = "#880088", bright = "#cc00cc" },
        brown = { normal = "#884400" },
    },
    ui = {
        global = {
            background = { normal = "#000000" },
            foreground = { normal = "#555555" },
        },
        cursor = {
            background = { normal = "#555555" },
            foreground = { normal = "#000000" },
        },
        gutter = { foreground = "#222222" },
        border = { normal = "#333333" },
        chrome = {
            background = { normal = "#222222", dark = "#111111" },
            foreground = { normal = "#555555", dark = "#444444" },
        },
        selection = { background = "#111111" },
        highlight = {
            line = { background = "#111111" },
            text = { background = "#222222" },
            search = { background = "#111111", foreground = "#888800" },
        },
        status = {
            error = "#880000",
            warning = "#884400",
            info = "#888800",
            success = "#008800",
        },
    },
    syntax = {
        comment = "#333333",
        string = { default = "#008800", regexp = "#008800", other = "#008800" },
        constant = {
            default = "#884400",
            character = { default = "#880000", escape = "#008888" },
            language = "#884400",
            numeric = { default = "#884400", float = "#884400" },
        },
        entity = {
            name = {
                class = "#888800",
                type = "#888800",
                ["function"] = { default = "#000088", constructor = "#000088" },
                label = "#888800",
                namespace = "#880000",
                tag = "#888800",
            },
            other = { ["attribute-name"] = "#888800" },
        },
        keyword = {
            default = "#880088",
            control = { default = "#880088", import = "#000088", flow = "#888800" },
            operator = "#880088",
            declaration = "#880088",
        },
        storage = { type = "#880088", modifier = "#888800" },
        variable = {
            default = "#555555",
            parameter = "#555555",
            other = { property = "#555555" },
        },
        punctuation = { separator = "#884400", section = "#884400" },
        markup = {
            default = "#555555",
            heading = "#000088",
            raw = "#884400",
            link = "#884400",
            list = "#888800",
            inserted = "#008800",
            deleted = "#880000",
        },
        meta = { preprocessor = "#888800" },
    },
}
