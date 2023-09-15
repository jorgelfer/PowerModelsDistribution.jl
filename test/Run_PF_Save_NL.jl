import Pkg
Pkg.activate(".")
Pkg.instantiate()

using JSON
using Ipopt

# package development
using Revise
Revise.revise()
import PowerModelsDistribution as PMD

function write(filename::AbstractString, solution::AbstractDict)::Nothing
    open(filename, "w") do file
        return JSON.print(file, solution, 2)
    end
    return
end

mutable struct Bus
    uid::String
    name::String
    va::Float64                    # voltage angle in rad
    vm::Float64                    # voltage magnitude in pu
end

mutable struct Branch 
    uid::String
    name::String
    t_bus::String
    f_bus::String
end

# office
# file_name = raw"C:\Users\vl\.julia\packages\OpenDSSDirect\5wwHs\examples\123Bus\IEEE123Master.dss"

# home
file_name = raw"C:\Users\jorge\AppData\Local\Programs\OpenDSS\IEEETestCases\123Bus\IEEE123Master.dss"

# approach 1
network = PMD.parse_file(file_name; data_model=PMD.MATHEMATICAL)
model = PMD.instantiate_mc_model(network, PMD.ACPUPowerModel, PMD.build_mc_pf) 
result = PMD.optimize_model!(model, optimizer=Ipopt.Optimizer)
PMD.update_data!(network, result["solution"])


# select data to visualize
nodes = [] 
links = []
for (s, struc) in network
    if cmp(s, "branch") == 0
        for (br, branch) in struc
            branch = Dict(
                "uid" => br,
                "t_bus" => branch["t_bus"],
                "f_bus" => branch["f_bus"],
                "name" => branch["name"],
                "value" => rand(1:20),
            )
            push!(links, branch)
        end
    elseif cmp(s, "bus") == 0
        for (b, bus) in struc
            bus = Dict(
                "uid" => b,
                "name" => bus["name"],
                "voltage" => bus["vm"],
                "angle" => bus["va"],
            )
            push!(nodes, bus)
        end
    end
end
sub_net = Dict("nodes" => nodes, "links" => links)

# write dictionary as JSON
path = joinpath(@__DIR__, "network.json")
write(path, sub_net)
