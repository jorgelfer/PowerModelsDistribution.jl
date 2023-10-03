# initialize the network
network = Dict()

# (1) name
network["name"] = "IEEE123"

# (2) data_model
network["data_model"] = "ENGINEERING"

# (3) settings
network["settings"] = Dict(
    "voltage_scale_factor" => 1000.0,                        # 
    "power_scale_factor" => 1000.0,
    "vbases_default" => Dict("150" => 2.4018, "610" => 0.2771), 
    "sbase_default" => 1000000.0,
    "base_frequency" => 60.0,
)

# (4) conductor ids
network["conductor_ids"] = ["1", "2", "3", "4"]

# (5) files
network["files"] = []

# (6) bus

for (_, bus) in Enetwork["bus"]
    println(keys(bus))
end

network["bus"] = Dict(
    "1" =>                      # dss name of the bus
    Dict(
    "terminals" => [1, 2, 3, 4],
    "grounded"  => [4],
    "rg"        => [0.0],
    "xg"        => [0.0],
    "status"        => "ENABLED",
    "time_series" => Dict(),
    ),
)

# (7) line

for (_, line) in Enetwork["line"]
    println(line["source_id"])
    println(keys(line))
end

# regular line
network["line"] = Dict(
    "l1" =>                      # dss name of the line
    Dict(
    "f_bus"         => "1",
    "t_bus"         => "2",
    "f_connections" => [2],
    "t_connections" => [2],
    "linecode"      => "10",
    "length"        => 53.34,
    "source_id"     => "line.l1",
    "status"        => "ENABLED",
    "time_series" => Dict(),
    ),
)

# switch
network["line"] = Dict(
    "sw6" =>                      # dss name of the line
    Dict(
    "f_bus"         => "1",
    "t_bus"         => "2",
    "f_connections" => [2],
    "t_connections" => [2],
    "linecode"      => "10",
    "length"        => 53.34,
    "source_id"     => "line.l1",
    "status"        => 1, 
    "f_bus"         => "61",
    "t_bus"         => "61s",
    "f_connections" => [1, 2, 3],
    "t_connections" => [1, 2, 3],
    # line code
        "rs"            => [0.001 0.0 0.0; 0.0 0.001 0.0; 0.0 0.0 0.001],
        "xs"            => [0.0 0.0 0.0; 0.0 0.0 0.0; 0.0 0.0 0.0],
        "g_fr"          => [0.0 0.0 0.0; 0.0 0.0 0.0; 0.0 0.0 0.0],
        "b_fr"          => [0.0 0.0 0.0; 0.0 0.0 0.0; 0.0 0.0 0.0],
        "g_to"          => [0.0 0.0 0.0; 0.0 0.0 0.0; 0.0 0.0 0.0],
        "b_to"          => [0.0 0.0 0.0; 0.0 0.0 0.0; 0.0 0.0 0.0],
        "cm_ub"         => [600.0, 600.0, 600.0],
    "length"        => 0.001,
    "source_id"     => "line.sw6",
    "status"        => "ENABLED",
    "time_series" => Dict(),
    ),
)

# (8) transformer

for (_, xfm) in Enetwork["transformer"]
    println(xfm["configuration"])
    println(keys(xfm))
end

# regulator
network["transformer"] = Dict(
    "reg4" =>                      # dss name of the line
    Dict(
    "bus"           => ["160", "160r"],
    "connections"   => [[1, 2, 3, 4], [1, 2, 3, 4]],
    "configuration" => ["WYE", "WYE"],
    # xfmcode
        "xsc"           => [0.0001],
        "rw"            => [5.0e-8, 5.0e-8],
    "cmag"          => 0.0,
    "noloadloss"    => 0.0,
    "tm_ub"         => [[1.1, 1.1, 1.1], [1.1, 1.1, 1.1]],
    "tm_lb"         => [[0.9, 0.9, 0.9], [0.9, 0.9, 0.9]],
    "tm_set"        => [[1.0, 1.0, 1.0], [1.0, 1.0, 1.0]],
    "tm_fix"        => Vector{Bool}[[1, 1, 1], [0, 0, 0]],
    "tm_step"       => [[0.03125, 0.03125, 0.03125], [0.03125, 0.03125, 0.03125]],
    "polarity"      => [1, 1],
    "vm_nom"        => [2.402, 2.402],
    "sm_nom"        => [2000.0, 2000.0],
    "sm_ub"         => 3000.0,
    "status"        => "ENABLED",
    "controls"      => Dict("ctprim"=>[[0.0, 0.0, 0.0], [300.0, 300.0, 300.0]], 
                            "x"=>[[0.0, 0.0, 0.0], [1.3, 2.6, 1.4]], 
                            "r"=>[[0.0, 0.0, 0.0], [0.6, 1.4, 0.2]], 
                            "ptratio"=>[[0.0, 0.0, 0.0], [20.0, 20.0, 20.0]], 
                            "band"=>[[0.0, 0.0, 0.0], [2.0, 2.0, 2.0]], 
                            "vreg"=>[[0.0, 0.0, 0.0], [124.0, 124.0, 124.0]]),
    "source_id"     => "transformer.reg4",
    "status"        => "ENABLED",
    "time_series" => Dict(),
    ),
)

# normal transformer 
network["transformer"] = Dict(
    "xfm1" =>                      # dss name of the line
    Dict(
    "bus"           => ["61s", "610"],
    "connections"   => [[1, 2, 3], [1, 2, 3]],
    "configuration" => ["DELTA", "DELTA"],
        "xsc"           => [0.0272],
        "rw"            => [0.00635, 0.00635],
    "cmag"          => 0.0,
    "noloadloss"    => 0.0,
    "tm_ub"         => [[1.1, 1.1, 1.1], [1.1, 1.1, 1.1]],
    "tm_lb"         => [[0.9, 0.9, 0.9], [0.9, 0.9, 0.9]],
    "tm_set"        => [[1.0, 1.0, 1.0], [1.0, 1.0, 1.0]],
    "tm_fix"        => [[1, 1, 1], [1, 1, 1]],
    "tm_step"       => [[0.03125, 0.03125, 0.03125], [0.03125, 0.03125, 0.03125]],
    "polarity"      => [1, 1],
    "vm_nom"        => [4.16, 0.48],
    "sm_nom"        => [150.0, 150.0],
    "sm_ub"         => 225.0,
    "source_id"     => "transformer.xfm1",
    "status"        => "ENABLED",
    "time_series" => Dict(),
    ),
)

# (9) shunt

for (s, sht) in Enetwork["shunt"]
    println(sht["model"])
    println(keys(sht))
end

network["shunt"] = Dict(
    "c83" =>                      # dss name of the line
    "bus"           => "83",
    "configuration" => "WYE",
    "connections"   => [1, 2, 3],
    "gs"            => [0.0 0.0 0.0; 0.0 0.0 0.0; 0.0 0.0 0.0],
    "bs"            => Real[0.0346709 0.0 0.0; 0.0 0.0346709 0.0; 0.0 0.0 0.0346709],
    "model"         => "CAPACITOR",
    "dispatchable"  => "NO",
    "source_id"     => "capacitor.c83",
    "status"        => "ENABLED",
    "time_series" => Dict(),
)

# (10) load
for (l, load) in Enetwork["load"]
    println(l)
    println(keys(load))
end

network["shunt"] = Dict(
    "s11a" =>                      # dss name of the line
    "bus"           => "11",
    "connections"   => [1, 4],
    "configuration" => "WYE",
    "model"         => "IMPEDANCE",
    "pd_nom"        => [40.0],
    "qd_nom"        => [20.0],
    "vm_nom"        => 2.4,
    "dispatchable"  => NO,
    "status"        => "ENABLED",
    "source_id"     => "load.s11a",
    "time_series" => Dict(),
)

# (11) linecode

# (12) voltage_source

