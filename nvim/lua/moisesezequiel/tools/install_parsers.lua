local M = {}

M.default_parsers = {
    "c",
    "cpp",
    "lua",
    "python",
    "rust",
    "bash",
    "json",
    "yaml",
    "toml",
    "vim",
    "query",
    "markdown",
    "markdown_inline",
    "javascript",
    "typescript",
    "tsx",
    "go",
}

local specs = {
    c = { repo = "https://github.com/tree-sitter/tree-sitter-c.git", subdir = "." },
    cpp = { repo = "https://github.com/tree-sitter/tree-sitter-cpp.git", subdir = "." },
    lua = { repo = "https://github.com/tree-sitter-grammars/tree-sitter-lua.git", subdir = "." },
    python = { repo = "https://github.com/tree-sitter/tree-sitter-python.git", subdir = "." },
    rust = { repo = "https://github.com/tree-sitter/tree-sitter-rust.git", subdir = "." },
    bash = { repo = "https://github.com/tree-sitter/tree-sitter-bash.git", subdir = "." },
    json = { repo = "https://github.com/tree-sitter/tree-sitter-json.git", subdir = "." },
    yaml = { repo = "https://github.com/tree-sitter-grammars/tree-sitter-yaml.git", subdir = "." },
    toml = { repo = "https://github.com/tree-sitter/tree-sitter-toml.git", subdir = "." },
    vim = { repo = "https://github.com/tree-sitter-grammars/tree-sitter-vim.git", subdir = "." },
    query = { repo = "https://github.com/tree-sitter-grammars/tree-sitter-query.git", subdir = "." },
    markdown = { repo = "https://github.com/tree-sitter-grammars/tree-sitter-markdown.git", subdir = "tree-sitter-markdown" },
    markdown_inline = { repo = "https://github.com/tree-sitter-grammars/tree-sitter-markdown.git", subdir = "tree-sitter-markdown-inline" },
    javascript = { repo = "https://github.com/tree-sitter/tree-sitter-javascript.git", subdir = "." },
    typescript = { repo = "https://github.com/tree-sitter/tree-sitter-typescript.git", subdir = "typescript" },
    tsx = { repo = "https://github.com/tree-sitter/tree-sitter-typescript.git", subdir = "tsx" },
    go = { repo = "https://github.com/tree-sitter/tree-sitter-go.git", subdir = "." },
}

local function run(cmd, args, cwd)
    local res = vim.system(vim.list_extend({ cmd }, args), { cwd = cwd, text = true }):wait()
    if res.code ~= 0 then
        error((res.stderr ~= "" and res.stderr) or (res.stdout ~= "" and res.stdout) or ("command failed: " .. cmd))
    end
end

local function pick_compiler(cxx)
    local cands = cxx and { "clang++", "g++", "c++" } or { "clang", "gcc", "cc" }
    for _, c in ipairs(cands) do
        if vim.fn.executable(c) == 1 then
            return c, {}
        end
    end
    if vim.fn.executable("zig") == 1 then
        return "zig", cxx and { "c++" } or { "cc" }
    end
    return nil, nil
end

local function repo_dir(cache_dir, repo)
    return cache_dir .. "/" .. repo:gsub("^https://github.com/", ""):gsub("%.git$", ""):gsub("/", "__")
end

local function ensure_repo(cache_dir, spec)
    local dir = repo_dir(cache_dir, spec.repo)
    if vim.fn.isdirectory(dir) == 0 then
        run("git", { "clone", "--depth=1", spec.repo, dir }, nil)
    else
        run("git", { "-C", dir, "pull", "--ff-only" }, nil)
    end
    return dir
end

function M.install(requested)
    requested = requested or vim.deepcopy(M.default_parsers)
    local data = vim.fn.stdpath("data")
    local parser_dir = data .. "/site/parser"
    local cache_dir = data .. "/ts-grammar-src"
    local sys = vim.uv.os_uname().sysname
    local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
    local ext = is_windows and "dll" or (sys == "Darwin" and "dylib" or "so")

    vim.fn.mkdir(parser_dir, "p")
    vim.fn.mkdir(cache_dir, "p")

    for _, lang in ipairs(requested) do
        local spec = specs[lang]
        if spec then
            local root = ensure_repo(cache_dir, spec)
            local src_root = (spec.subdir == "." and root) or (root .. "/" .. spec.subdir)
            local src_dir = src_root .. "/src"
            local parser_c = src_dir .. "/parser.c"
            local scanner_c = src_dir .. "/scanner.c"
            local scanner_cc = src_dir .. "/scanner.cc"
            local scanner_cpp = src_dir .. "/scanner.cpp"

            if vim.fn.filereadable(parser_c) == 0 then
                error("missing parser.c for " .. lang .. " in " .. src_dir)
            end

            local sources = { parser_c }
            local uses_cxx = false
            if vim.fn.filereadable(scanner_cc) == 1 then
                table.insert(sources, scanner_cc)
                uses_cxx = true
            elseif vim.fn.filereadable(scanner_cpp) == 1 then
                table.insert(sources, scanner_cpp)
                uses_cxx = true
            elseif vim.fn.filereadable(scanner_c) == 1 then
                table.insert(sources, scanner_c)
            end

            local compiler, prefix = pick_compiler(uses_cxx)
            if not compiler then
                error("no compiler found (need clang/gcc/cc or zig)")
            end

            local out = parser_dir .. "/" .. lang .. "." .. ext
            local args = vim.deepcopy(prefix)
            vim.list_extend(args, { "-O2", "-shared", "-o", out, "-I", src_dir })
            if not is_windows then
                table.insert(args, "-fPIC")
            end
            vim.list_extend(args, sources)

            run(compiler, args, src_root)
            vim.notify("installed parser: " .. lang .. " -> " .. out, vim.log.levels.INFO)
        else
            vim.notify("unknown parser key: " .. lang, vim.log.levels.WARN)
        end
    end
end

return M
