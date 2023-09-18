push!(LOAD_PATH,"../src/")

using Documenter
using SymbolTable

makedocs(
    sitename = "SymbolTable",
    format = Documenter.HTML(),
    modules = [SymbolTable]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
