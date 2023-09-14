import Pkg
Pkg.activate(".")
# Pkg.instantiate()

using DataFrames
using CSV
using Ipopt

# package development
using Revise
Revise.revise()
import PowerModelsDistribution as PMD



# office
# file_name = raw"C:\Users\vl\.julia\packages\OpenDSSDirect\5wwHs\examples\123Bus\IEEE123Master.dss"

# home
file_name = raw"C:\Users\jorge\AppData\Local\Programs\OpenDSS\IEEETestCases\123Bus\IEEE123Master.dss"



# approach 1
# network = PMD.parse_file(file_name; data_model=MATHEMATICAL)
# model = PMD.instantiate_mc_model(network, ACPUPowerModel, build_mc_pf) 
# result = PMD.optimize_model!(model, optimizer=Ipopt.Optimizer)
# update_data!(network, result["solution"])

# approach 2
data_eng = PMD.parse_file(file_name, transformations=[PMD.transform_loops!])
data_math = PMD.transform_data_model(data_eng;kron_reduce=false)
res = PMD.compute_mc_pf(data_math; explicit_neutral=true, max_iter=100)
result = PMD.transform_solution(res["solution"], data_math, make_si=true)


# get nodal voltages
nodes = [] 
volts = [] 
for (_, bus) in network["bus"]
    bn = bus["name"]
    for (i, terminal) in enumerate(bus["terminals"])
        # println("$bn.$terminal")
        if startswith(bn, "_") continue end
        push!(nodes, "$bn.$terminal")
        push!(volts, bus["vbase"] * bus["vm"][i] * 100)
    end                                                                                               
end

# write voltage to file
df = DataFrame(Node=nodes, volts=volts)
CSV.write("volts_PMD.csv", df)