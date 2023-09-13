import Pkg
Pkg.activate(".")
Pkg.instantiate()

using Ipopt

# package development
using Revise
Revise.revise()
using PowerModelsDistribution


file = raw"C:\Users\vl\.julia\packages\OpenDSSDirect\5wwHs\examples\123Bus\IEEE123Master.dss"
network = parse_file(file)

model = instantiate_mc_model(network, ACPUPowerModel, build_mc_pf) 
result = optimize_model!(model, optimizer=Ipopt.Optimizer)

# Perform a sparse update to the powermodels network data dictionary
update_data!(network, result["solution"])