import Pkg
Pkg.activate(".")
# Pkg.instantiate()

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

# office
# file_name = raw"C:\Users\vl\.julia\packages\OpenDSSDirect\5wwHs\examples\123Bus\IEEE123Master.dss"

# home
file_name = raw"C:\Users\jorge\AppData\Local\Programs\OpenDSS\IEEETestCases\123Bus\IEEE123Master.dss"

# approach 1
eng = PMD.parse_file(file_name; data_model=PMD.ENGINEERING)

# approach 2
model = PMD.instantiate_mc_model(eng, PMD.ACPUPowerModel, PMD.build_mc_pf) 
result = PMD.optimize_model!(model, optimizer=Ipopt.Optimizer)
PMD.update_data!(network, result["solution"])

# write dictionary as JSON
path = joinpath(@__DIR__, "network.json")
write(path, network)
