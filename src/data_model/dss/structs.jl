# Defines data structures (defaults) for OpenDSS objects

"Struct to maintain current state in dss parser"
Base.@kwdef mutable struct DssCurrentState <: DssRawModel
    current_command::String = ""
    last_command::String = ""
    active_obj_type::String = ""
    active_obj_name::String = ""
    active_obj_field::String = ""
    current_file::Union{Missing,FilePaths.AbstractPath} = missing
    base_path::Union{Missing,FilePaths.AbstractPath} = missing
end

"OpenDSS option defaults"
Base.@kwdef mutable struct DssOptions <: DssDataObject
    var"%growth"::Float64 = 2.5
    var"%mean"::Float64 = 65.0
    var"%normal"::Float64 = 100.0
    var"%stddev"::Float64 = 9.0
    addtype::String = "generator"
    algorithm::String = "newton"
    allocationfactors::String = ""
    allowduplicates::Bool = false
    autobuslist::Vector{String} = String[]
    basefrequency::Float64 = 60.0
    bus::String = ""
    capkvar::Float64 = 600.0
    casename::String = ""
    capmarkercode::Int = 37
    capmarkersize::Int = 3
    cfactors::Float64 = 4.0
    circuit::String = ""
    cktmodel::String = "multiphase"
    class::String = ""
    controlmode::String = "static"
    datapath::String = ""
    defaultbasefrequency::Float64 = 60.0
    defaultdaily::String = "default"
    defaultyearly::String = "default"
    demandinterval::Bool = false
    diverbose::Bool = false
    dssvisualizationtool::String = ""
    earthmodel::String = "deri"
    editor::String = "notepad"
    element::String = ""
    emergvmaxpu::Float64 = 1.08
    emergvminpu::Float64 = 0.90
    frequency::Float64 = 60.0
    genkw::Float64 = 1000.0
    genmult::Float64 = 1.0
    h::String = ""
    harmonics::String = "all"
    hour::Float64 = 1.0
    keeplist::Vector{String} = String[]
    ldcurve::String = "nil"
    loadmodel::String = "admittance"
    loadmult::Float64 = 1.0
    log::Bool = false
    lossregs::Int = 13
    lossweight::Float64 = 1.0
    markercode::Int = 0
    markswitches::Bool = false
    markcapacitors::Bool = false
    markpvsystems::Bool = false
    markregulators::Bool = false
    markstorage::Bool = false
    marktransformers::Bool = false
    maxcontroliter::Int = 10
    maxiter::Int = 15
    miniterations::Int = 2
    mode::String = "snap"
    name::String = ""
    nodewidth::Int = 1
    normvmaxpu::Float64 = 1.05
    normvminpu::Float64 = 0.95
    numallociterations::Int = 2
    number::Int = 0
    object::String = ""
    overloadreport::Bool = false
    neglectloady::Bool = false
    pricecurve::String = ""
    pricesignal::Int = 25
    pvmarkercode::Int = 15
    pvmarkersize::Int = 1
    random::String = "uniform"
    recorder::Bool = false
    reduceoption::String = "default"
    registryupdate::Bool = true
    regmarkercode::Int = 47
    regmarkersize::Int = 1
    sampleenergymeters::Bool = false
    sec::Float64 = 0.0
    showexport::Bool = false
    stepsize::String = "1h"
    switchmarkercode::Int = 4
    terminal::String = ""
    time::Vector{Float64} = Float64[0.0, 0.0]
    tolerance::Float64 = 0.0001
    totaltime::Float64 = 0.0
    tracecontrol::Bool = false
    transmarkercode::Int = 35
    transmarkersize::Int = 1
    storemarkercode::Int = 9
    storemarkersize::Int = 1
    trapezoidal::Int = false
    type::String = ""
    ueregs::Int = 11
    ueweight::Float64 = 1.0
    voltagebases::Vector{Float64} = Float64[]
    voltexceptionreport::Bool = false
    year::Int = 0
    zonelock::Bool = false
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS buscoordinates"
struct DssBuscoords <: DssDataObject
    bus::String
    x::Float64
    y::Float64
end

DssSetbusxy = DssBuscoords


"Raw dss data structure"
Base.@kwdef struct OpenDssRawDataModel <: DssRawModel
    filename::Vector{String} = Vector{String}()
    current_state::DssCurrentState = DssCurrentState()
    options::Vector{Pair{String,String}} = Vector{Pair{String,String}}()
    linecode::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    linegeometry::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    linespacing::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    loadshape::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    xycurve::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    growthshape::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    tcc_curve::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    cndata::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    tsdata::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    wiredata::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    xfmrcode::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    spectrum::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    vsource::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    circuit::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    isource::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    fault::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    capacitor::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    line::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    reactor::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    transformer::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    gictransformer::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    gicline::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    load::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    generator::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    indmach012::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    storage::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    capcontrol::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    regcontrol::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    energymeter::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    monitor::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    pvsystem::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    relay::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    recloser::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    fuse::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    swtcontrol::Dict{String,Vector{Pair{String,String}}} = Dict{String,Vector{Pair{String,String}}}()
    buscoordinates::Vector{DssBuscoords} = Vector{DssBuscoords}()
end


"OpenDSS LineCode defaults"
Base.@kwdef mutable struct DssLinecode <: DssDataObject
    name::String = ""
    nphases::Int = 3
    r1::Float64 = 0.058
    x1::Float64 = 0.1206
    r0::Float64 = 0.1784
    x0::Float64 = 0.4047
    c1::Float64 = 3.4
    c0::Float64 = 1.6
    units::String = "none"
    rmatrix::Matrix{Float64} = Float64[0.09813333333333334 0.04013333333333333 0.04013333333333333; 0.04013333333333333 0.09813333333333334 0.04013333333333333; 0.04013333333333333 0.04013333333333333 0.09813333333333334]
    xmatrix::Matrix{Float64} = Float64[0.21530000000000002 0.0947 0.0947; 0.0947 0.21530000000000002 0.0947; 0.0947 0.0947 0.21530000000000002]
    cmatrix::Matrix{Float64} = Float64[2.8000000000000003 -0.6000000000000001 -0.6000000000000001; -0.6000000000000001 2.8000000000000003 -0.6000000000000001; -0.6000000000000001 -0.6000000000000001 2.8000000000000003]
    basefreq::Float64 = 60.0
    normamps::Float64 = 400.0
    emergamps::Float64 = 600.0
    faultrate::Float64 = 0.1
    pctperm::Float64 = 20.0
    repair::Float64 = 3.0
    kron::Bool = false
    rg::Float64 = 0.01805
    xg::Float64 = 0.155081
    rho::Float64 = 100.0
    neutral::Int = 3
    b1::Float64 = 1281.769
    b0::Float64 = 603.185
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS LineGeometry defaults"
Base.@kwdef mutable struct DssLinegeometry <: DssDataObject
    name::String = ""
    nconds::Int = 3
    nphases::Int = 3
    cond::Int = 1
    wire::String = ""
    x::Float64 = 0.0
    h::Float64 = 0.0
    units::String = "none"
    normamps::Float64 = 400.0
    emergamps::Float64 = 600.0
    reduce::Bool = false
    spacing::String = ""
    wires::Vector{String} = String[]
    cncable::String = ""
    tscable::String = ""
    cncables::Vector{String} = String[]
    tscables::Vector{String} = String[]
    fconds::Vector{Int} = collect(1:nconds)
    xs::Vector{Float64} = rand(nconds).*1e-100
    hs::Vector{Float64} = rand(nconds).*1e-100
    fx::Vector{Float64} = xs
    fh::Vector{Float64} = hs
    unitss::Vector{String} = fill("none", nconds)
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS LineSpacing defaults"
Base.@kwdef mutable struct DssLinespacing <: DssDataObject
    name::String = ""
    nconds::Int = 3
    nphases::Int = 3
    x::Vector{Float64} = rand(nconds).*1e-100
    h::Vector{Float64} = rand(nconds).*1e-100
    units::String = "ft"
    fx::Vector{Float64} = x
    fh::Vector{Float64} = h
    funits::Vector{String} = fill("ft", nconds)
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS LoadShape defaults"
Base.@kwdef mutable struct DssLoadshape <: DssDataObject
    name::String = ""
    npts::Int = 0
    interval::Float64 = 1.0
    minterval::Float64 = 1.0 / 60
    sinterval::Float64 = 1.0 / 60 / 60
    pmult::Vector{Float64} = Float64[]
    qmult::Vector{Float64} = Float64[]
    hour::Vector{Float64} = Float64[]
    mean::Float64 = 0.0
    stddev::Float64 = 0.0
    csvfile::String = ""
    sngfile::String = ""
    dblfile::String = ""
    pqcsvfile::String = ""
    action::String = ""
    useactual::Bool = false
    pmax::Float64 = 1.0
    qmax::Float64 = 1.0
    pbase::Float64 = 0.0
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS XYCurve defaults"
Base.@kwdef mutable struct DssXycurve <: DssDataObject
    name::String = ""
    npts::Int = 0
    points::Vector{Float64} = Float64[]
    yarray::Vector{Float64} = Float64[]
    xarray::Vector{Float64} = Float64[]
    csvfile::String = ""
    sngfile::String = ""
    dblfile::String = ""
    x::Float64 = 0.0
    y::Float64 = 0.0
    xshift::Int = 0
    yshift::Int = 0
    xscale::Float64 = 1.0
    yscale::Float64 = 1.0
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS GrowthShape defaults"
Base.@kwdef mutable struct DssGrowthshape <: DssDataObject
    name::String = ""
    npts::Int = 0
    year::Vector{Float64} = Float64[]
    mult::Vector{Float64} = Float64[]
    csvfile::String = ""
    sngfile::String = ""
    dblfile::String = ""
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS Tcc_curve defaults"
Base.@kwdef mutable struct DssTcc_curve <: DssDataObject
    name::String = ""
    npts::Int = 0
    c_array::Vector{Float64} = Float64[]
    t_array::Vector{Float64} = Float64[]
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS CNData defaults"
Base.@kwdef mutable struct DssCndata <: DssDataObject
    name::String = ""
    diacable::Float64 = 0.0
    diains::Float64 = 0.0
    diam::Float64 = 2.0
    diastrand::Float64 = 2.0
    emergamps::Float64 = 600.0
    epsr::Float64 = 2.3
    gmrac::Float64 = 0.7788
    gmrstrand::Float64 = 0.7788
    gmrunits::String = "none"
    inslayer::Float64 = 0.0
    k::Int = 2
    like::String = ""
    normamps::Float64 = 400.0
    rac::Float64 = 1.02
    radius::Float64 = 1.0
    radunits::String = "none"
    rdc::Float64 = 1.0
    rstrand::Float64 = 0.0
    runits::String = "none"
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS TSData defaults"
Base.@kwdef mutable struct DssTsdata <: DssDataObject
    name::String = ""
    diacable::Float64 = 0.0
    diains::Float64 = 0.0
    diam::Float64 = 2.0
    diashield::Float64 = 0.0
    emergamps::Float64 = 600.0
    epsr::Float64 = 2.3
    gmrac::Float64 = 0.7788
    gmrunits::String = "none"
    inslayer::Float64 = 0.0
    like::String = ""
    normamps::Float64 = 400.0
    rac::Float64 = 1.02
    radius::Float64 = 1.0
    radunits::String = "none"
    rdc::Float64 = 1.0
    runits::String = "none"
    tapelap::Float64 = 20.0
    tapelayer::Float64 = 0.0
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS WireData defaults"
Base.@kwdef mutable struct DssWiredata <: DssDataObject
    name::String = ""
    rdc::Float64 = 0.0
    rac::Float64 = 0.0
    runits::String = "none"
    gmrac::Float64 = 0.7788
    gmrunits::String = "none"
    radius::Float64 = 1.0
    radunits::String = "none"
    normamps::Float64 = 400.0
    emergamps::Float64 = 600.0
    diam::Float64 = 2.0
    capradius::Float64 = 1.0
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS XfmrCode defaults"
Base.@kwdef mutable struct DssXfmrcode <: DssDataObject
    name::String = ""
    phases::Int = 3
    windings::Int = 2
    wdg::Int = 1
    conn::ConnConfig = WYE
    kv::Float64 = 12.47
    kva::Float64 = 10.0
    tap::Float64 = 1.0
    var"%r"::Float64 = 0.2
    rneut::Float64 = 0.0
    xneut::Float64 = 0.0
    conns::Vector{ConnConfig} = zeros(ConnConfig,windings)
    kvs::Vector{Float64} = fill(12.47,windings)
    kvas::Vector{Float64} = fill(10.0,windings)
    taps::Vector{Float64} = fill(1.0,windings)
    var"%rs"::Vector{Float64} = fill(0.2,windings)
    xhl::Float64 = 7.0
    xlt::Float64 = 35.0
    xht::Float64 = 30.0
    xscarray::Vector{Float64} = Float64[]
    thermal::Float64 = 2.0
    n::Float64 = 0.8
    m::Float64 = 0.8
    flrise::Float64 = 65.0
    hsrise::Float64 = 15.0
    var"%loadloss"::Float64 = 0.4
    var"%noloadloss"::Float64 = 0.0
    var"%imag"::Float64 = 0.0
    ppm_antifloat::Float64 = 1.0
    normhkva::Float64 = 11.0
    emerghkva::Float64 = 15.0
    sub::Bool = false
    maxtap::Float64 = 1.1
    mintap::Float64 = 0.9
    numtaps::Int = 32
    subname::String = ""
    xrconst::Bool = false
    leadlag::String = "lag"
    wdgcurrents::Vector{String} = String[]
    core::String = ""
    rdcohms::Vector{Float64} = fill(0.17,windings)
    faultrate::Float64 = 0.1
    basefreq::Float64 = 60.0
    enabled::Status = ENABLED
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS Spectrum defaults"
Base.@kwdef mutable struct DssSpectrum <: DssDataObject
    name::String = ""
    numharm::Int = 0
    harmonic::Vector{Float64} = Float64[]
    var"%mag"::Vector{Float64} = Float64[]
    angle::Vector{Float64} = Float64[]
    csvfile::String = ""
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS VSource defaults"
Base.@kwdef mutable struct DssVsource <: DssEdgeObject
    name::String = ""
    bus1::String = ""
    bus2::String = ""
    basekv::Float64 = 115.0
    pu::Float64 = 1.0
    angle::Float64 = 0.0
    frequency::Float64 = 60.0
    phases::Int = 3
    mvasc3::Float64 = 2000.0
    mvasc1::Float64 = 2100.0
    x1r1::Float64 = 4.0
    x0r0::Float64 = 3.0
    isc3::Float64 = 10041.0
    isc1::Float64 = 10543.0
    r1::Float64 = 1.65
    x1::Float64 = 6.6
    r0::Float64 = 1.9
    x0::Float64 = 5.7
    scantype::String = "pos"
    sequence::String = "pos"
    spectrum::String = "defaultvsource"
    z1::Vector{Float64} = Float64[r1, x1]
    z2::Vector{Float64} = Float64[r1, x1]
    z0::Vector{Float64} = Float64[r0, x0]
    puz1::Vector{Float64} = Float64[0.0, 0.0]
    puz2::Vector{Float64} = puz1
    puz0::Vector{Float64} = puz1
    basemva::Float64 = 100.0
    basefreq::Float64 = 60.0
    like::String = ""
    enabled::Status = ENABLED
    rmatrix::Matrix{Float64} = zeros(Float64, phases, phases)
    xmatrix::Matrix{Float64} = zeros(Float64, phases, phases)
    r_self::Float64 = 1.73333
    r_mutual::Float64 = 0.0833
    x_self::Float64 = 6.35667
    x_mutual::Float64 = -0.03
    vmag::Float64 = 0.0
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS Circuit (VSource) defaults"
Base.@kwdef mutable struct DssCircuit <: DssDataObject
    name::String = ""
    bus1::String = ""
    bus2::String = ""
    basekv::Float64 = 115.0
    pu::Float64 = 1.0
    angle::Float64 = 0.0
    frequency::Float64 = 60.0
    phases::Int = 3
    mvasc3::Float64 = 2000.0
    mvasc1::Float64 = 2100.0
    x1r1::Float64 = 4.0
    x0r0::Float64 = 3.0
    isc3::Float64 = 10041.0
    isc1::Float64 = 10543.0
    r1::Float64 = 1.65
    x1::Float64 = 6.6
    r0::Float64 = 1.9
    x0::Float64 = 5.7
    scantype::String = "pos"
    sequence::String = "pos"
    spectrum::String = "defaultvsource"
    z1::Vector{Float64} = Float64[r1, x1]
    z2::Vector{Float64} = Float64[r1, x1]
    z0::Vector{Float64} = Float64[r0, x0]
    puz1::Vector{Float64} = Float64[0.0, 0.0]
    puz2::Vector{Float64} = puz1
    puz0::Vector{Float64} = puz1
    basemva::Float64 = 100.0
    basefreq::Float64 = 60.0
    like::String = ""
    enabled::Status = ENABLED
    rmatrix::Matrix{Float64} = zeros(Float64, phases, phases)
    xmatrix::Matrix{Float64} = zeros(Float64, phases, phases)
    r_self::Float64 = 1.73333
    r_mutual::Float64 = 0.0833
    x_self::Float64 = 6.35667
    x_mutual::Float64 = -0.03
    vmag::Float64 = 0.0
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS ISource defaults"
Base.@kwdef mutable struct DssIsource <: DssNodeObject
    name::String = ""
    phases::Int = 3
    bus1::String = ""
    amps::Float64 = 0.0
    angle::Float64 = 0.0
    frequency::Float64 = 60.0
    scantype::String = "pos"
    sequence::String = "pos"
    spectrum::String = "default"
    basefreq::Float64 = 60.0
    enabled::Status = ENABLED
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS Fault defaults"
Base.@kwdef mutable struct DssFault <: DssEdgeObject
    name::String = ""
    phases::Int = 1
    bus1::String = ""
    bus2::String = ""
    r::Float64 = 0.0001
    gmatrix::Matrix{Float64} = zeros(Float64, phases, phases)
    minamps::Float64 = 5.0
    ontime::Float64 = 0.0
    pctperm::Float64 = 0.0
    temporary::Bool = false
    var"%stddev"::Float64 = 0.0
    normamps::Float64 = 0.0
    emergamps::Float64 = 0.0
    basefreq::Float64 = 60.0
    faultrate::Float64 = 0.0
    repair::Float64 = 0.0
    enabled::Status = ENABLED
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS Capacitor defaults"
Base.@kwdef mutable struct DssCapacitor <: DssEdgeObject
    name::String = ""
    bus1::String = ""
    bus2::String = bus1
    phases::Int = 3
    kvar::Float64 = 1200.0
    kv::Float64 = 12.47
    conn::ConnConfig = WYE
    cmatrix::Matrix{Float64} = zeros(Float64, phases, phases)
    cuf::Vector{Float64} = zeros(Float64, phases)
    r::Vector{Float64} = zeros(Float64, phases)
    xl::Vector{Float64} = zeros(Float64, phases)
    harm::Vector{Float64} = zeros(Float64, phases)
    numsteps::Int = 1
    states::Vector{Bool} = zeros(Bool, phases)
    normamps::Float64 = 400.0
    emergamps::Float64 = 600.0
    faultrate::Float64 = 0.1
    pctperm::Float64 = 20.0
    basefreq::Float64 = 60.0
    enabled::Status = ENABLED
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS Line defaults"
Base.@kwdef mutable struct DssLine <: DssEdgeObject
    name::String = ""
    bus1::String = ""
    bus2::String = ""
    linecode::String = ""
    length::Float64 = 1.0
    phases::Int = 3
    r1::Float64 = 0.058
    x1::Float64 = 0.1206
    r0::Float64 = 0.1784
    x0::Float64 = 0.4047
    c1::Float64 = 3.4
    c0::Float64 = 1.6
    normamps::Float64 = 400.0
    emergamps::Float64 = 600.0
    faultrate::Float64 = 0.1
    pctperm::Float64 = 20.0
    repair::Float64 = 3.0
    basefreq::Float64 = 60.0
    rmatrix::Matrix{Float64} = Float64[0.09813333333333334 0.04013333333333333 0.04013333333333333; 0.04013333333333333 0.09813333333333334 0.04013333333333333; 0.04013333333333333 0.04013333333333333 0.09813333333333334]
    xmatrix::Matrix{Float64} = Float64[0.21530000000000002 0.0947 0.0947; 0.0947 0.21530000000000002 0.0947; 0.0947 0.0947 0.21530000000000002]
    cmatrix::Matrix{Float64} = Float64[2.8000000000000003 -0.6000000000000001 -0.6000000000000001; -0.6000000000000001 2.8000000000000003 -0.6000000000000001; -0.6000000000000001 -0.6000000000000001 2.8000000000000003]
    switch::Bool = false
    rg::Float64 = 0.01805
    xg::Float64 = 0.155081
    rho::Float64 = 100.0
    geometry::String = ""
    units::String = "none"
    spacing::String = ""
    wires::Vector{String} = String[]
    earthmodel::String = ""
    cncables::Vector{String} = String[]
    tscables::Vector{String} = String[]
    b1::Float64 = 1281.769
    b0::Float64 = 603.185
    seasons::Vector{String} = String[]
    ratings::Vector{String} = String[]
    enabled::Status = ENABLED
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS Reactor defaults"
Base.@kwdef mutable struct DssReactor <: DssEdgeObject
    name::String = ""
    phases::Int = 3
    bus1::String = ""
    bus2::String = bus1
    kv::Float64 = 12.47
    kvar::Float64 = 1200.0
    conn::ConnConfig = WYE
    parallel::Bool = false
    r::Float64 = 0.0
    rmatrix::Matrix{Float64} = zeros(Float64, phases, phases)
    rp::Float64 = 0.0
    x::Float64 = abs(kv*1e3)
    xmatrix::Matrix{Float64} = zeros(Float64, phases, phases)
    z::Vector{Float64} = Float64[r, x]
    z1::Vector{Float64} = Float64[r, x]
    z2::Vector{Float64} = Float64[0.0, 0.0]
    z0::Vector{Float64} = Float64[0.0, 0.0]
    gmatrix::Matrix{Float64} = zeros(Float64, phases, phases)
    bmatrix::Matrix{Float64} = zeros(Float64, phases, phases)
    rcurve::String = ""
    lcurve::String = ""
    lmh::Float64 = x / (2 * pi * 60.0) * 1e3
    normamps::Float64 = 400.0
    emergamps::Float64 = 600.0
    repair::Float64 = 3.0
    faultrate::Float64 = 0.1
    pctperm::Float64 = 20.0
    basefreq::Float64 = 60.0
    l::Float64 = x / 2π / basefreq
    enabled::Status = ENABLED
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS Transformer defaults"
Base.@kwdef mutable struct DssTransformer <: DssEdgeObject
    name::String = ""
    phases::Int = 3
    windings::Int = 2
    wdg::Int = 1
    bus::String = ""
    conn::ConnConfig = WYE
    kv::Float64 = 12.47
    kva::Float64 = 10.0
    tap::Float64 = 1.0
    var"%r"::Float64 = 0.2
    rneut::Float64 = 0.0
    xneut::Float64 = 0.0
    buses::Vector{String} = zeros(String,windings)
    conns::Vector{ConnConfig} = zeros(ConnConfig,windings)
    kvs::Vector{Float64} = fill(12.47,windings)
    kvas::Vector{Float64} = fill(10.0,windings)
    taps::Vector{Float64} = fill(1.0,windings)
    var"%rs"::Vector{Float64} = fill(0.2,windings)
    xhl::Float64 = 7.0
    xlt::Float64 = 35.0
    xht::Float64 = 30.0
    xscarray::Vector{Float64} = Float64[]
    thermal::Float64 = 2.0
    n::Float64 = 0.8
    m::Float64 = 0.8
    flrise::Float64 = 65.0
    hsrise::Float64 = 15.0
    var"%loadloss"::Float64 = 0.4
    var"%noloadloss"::Float64 = 0.0
    var"%imag"::Float64 = 0.0
    ppm_antifloat::Float64 = 1.0
    normhkva::Float64 = 11.0
    emerghkva::Float64 = 15.0
    sub::Bool = false
    maxtap::Float64 = 1.1
    mintap::Float64 = 0.9
    numtaps::Int = 32
    subname::String = ""
    bank::String = ""
    xfmrcode::String = ""
    xrconst::Bool = false
    leadlag::String = "lag"
    wdgcurrents::Vector{String} = String[]
    core::String = ""
    rdcohms::Vector{Float64} = fill(0.17,windings)
    faultrate::Float64 = 0.1
    basefreq::Float64 = 60.0
    enabled::Status = ENABLED
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS GICTransformer defaults"
Base.@kwdef mutable struct DssGictransformer <: DssEdgeObject
    name::String = ""
    basefreq::Float64 = 60.0
    bush::String = ""
    busnh::String = "$bush.0.0.0"
    busx::String = ""
    busnx::String = "$busx.0.0.0"
    emergamps::Float64 = 0.0
    enabled::Status = ENABLED
    phases::Int = 3
    r1::Float64 = 5.0
    r2::Float64 = 0.38088
    type::String = "gsu"
    mva::Float64 = 100.0
    kvll1::Float64 = 500.0
    kvll2::Float64 = 138.0
    var"%r1"::Float64 = 0.2
    var"%r2"::Float64 = 0.2
    k::Float64 = 2.2
    varcurve::String = ""
    like::String = ""
    normamps::Float64 = 0.0
    pctperm::Float64 = 0.0
    repair::Float64 = 0.0
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS GICLine defaults"
Base.@kwdef mutable struct DssGicline <: DssEdgeObject
    name::String = ""
    angle::Float64 = 0.0
    bus1::String = ""
    bus2::String = ""
    c::Float64 = 0.0
    ee::Float64 = 1.0
    en::Float64 = 1.0
    frequency::Float64 = 0.1
    lat1::Float64 = 33.613499
    lat2::Float64 = 33.547885
    lon1::Float64 = -87.373673
    lon2::Float64 = -86.074605
    phases::Int = 3
    r::Float64 = 1.0
    volts::Float64 = 113.32316
    x::Float64 = 0.0
    like::String = ""
    basefreq::Float64 = 60.0
    enabled::Status = ENABLED
    spectrum::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS Load defaults"
Base.@kwdef mutable struct DssLoad <: DssNodeObject
    name::String = ""
    phases::Int = 3
    bus1::String = ""
    kv::Float64 = 12.47
    kw::Float64 = 10.0
    pf::Float64 = 0.88
    model::LoadModel = POWER
    yearly::String = ""
    daily::String = ""
    duty::String = ""
    growth::String = ""
    conn::ConnConfig = WYE
    kvar::Float64 = 5.0
    rneut::Float64 = -1.0
    xneut::Float64 = 0.0
    status::String = "variable"
    class::Int = 1
    vminpu::Float64 = 0.95
    vmaxpu::Float64 = 1.05
    vminnorm::Float64 = 0.0
    vminemerg::Float64 = 0.0
    xfkva::Float64 = 0.0
    allocationfactor::Float64 = 0.5
    kva::Float64 = 11.36
    var"%mean"::Float64 = 0.5
    var"%stddev"::Float64 = 0.1
    cvrwatts::Float64 = 1.0
    cvrvars::Float64 = 2.0
    kwh::Float64 = 0.0
    kwhdays::Float64 = 30.0
    cfactor::Float64 = 4.0
    cvrcurve::String = ""
    numcust::Int = 1
    zipv::Vector{Float64} = Float64[]
    var"%seriesrl"::Float64 = 0.5
    relweight::Float64 = 1.0
    vlowpu::Float64 = 0.5
    puxharm::Float64 = 0.0
    xrharm::Float64 = 6.0
    spectrum::String = "default"
    basefreq::Float64 = 60.0
    enabled::Status = ENABLED
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS Generator defaults"
Base.@kwdef mutable struct DssGenerator <: DssNodeObject
    name::String = ""
    bus1::String = ""
    phases::Int = 3
    kv::Float64 = 12.47
    kw::Float64 = 100.0
    pf::Float64 = 0.80
    model::Int = 1
    yearly::String = ""
    daily::String = ""
    duty::String = ""
    dispmode::String = "default"
    dispvalue::Float64 = 0.0
    conn::ConnConfig = WYE
    kvar::Float64 = 60.0
    rneut::Float64 = 0.0
    xneut::Float64 = 0.0
    status::String = "variable"
    class::Int = 1
    vpu::Float64 = 1.0
    maxkvar::Float64 = 120.0
    minkvar::Float64 = -120.0
    pvfactor::Float64 = 0.1
    debugtrace::Bool = false
    vminpu::Float64 = 0.9
    vmaxpu::Float64 = 1.1
    forceon::Bool = false
    kva::Float64 = 120.0
    mva::Float64 = 0.001 * kva
    xd::Float64 = 1.0
    xdp::Float64 = 0.28
    xdpp::Float64 = 0.20
    h::Float64 = 1.0
    d::Float64 = 1.0
    usermodel::String = ""
    userdata::String = ""
    shaftmodel::String = ""
    shaftdata::String = ""
    dutystart::Float64 = 0.0
    balanced::Bool = false
    xrdp::Float64 = 20.0
    spectrum::String = "defaultgen"
    basefreq::Float64 = 60.0
    enabled::Status = ENABLED
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS IndMach012 defaults"
Base.@kwdef mutable struct DssIndmach012 <: DssNodeObject
    name::String = ""
    phases::Int = 3
    bus1::String = ""
    kv::Float64 = 12.47
    kw::Float64 = 1000.0
    pf::Float64 = 1.0
    conn::ConnConfig = DELTA
    kva::Float64 = 1200.0
    h::Float64 = 1.0
    d::Float64 = 1.0
    purs::Float64 = 0.0053
    puxs::Float64 = 0.106
    purr::Float64 = 0.007
    puxr::Float64 = 0.12
    puxm::Float64 = 4.0
    slip::Float64 = 0.007
    maxslip::Float64 = 0.1
    slipoption::String = "variable"
    spectrum::String = ""
    enabled::Status = ENABLED
    like::String = ""
    daily::String = ""
    yearly::String = ""
    duty::String = ""
    debugtrace::Bool = false
    basefreq::Float64 = 60.0
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS Storage defaults"
Base.@kwdef mutable struct DssStorage <: DssNodeObject
    name::String = ""
    phases::Int = 3
    bus1::String = ""
    var"%charge"::Float64 = 100.0
    var"%discharge"::Float64 = 100.0
    var"%effcharge"::Float64 = 90.0
    var"%effdischarge"::Float64 = 90.0
    var"%idlingkvar"::Float64 = 0.0
    var"%idlingkw"::Float64 = 0.0
    var"%r"::Float64 = 0.0
    var"%reserve"::Float64 = 20.0
    var"%stored"::Float64 = 100.0
    var"%x"::Float64 = 50.0
    basefreq::Float64 = 60.0
    chargetrigger::Float64 = 0.0
    class::Int = 0
    conn::ConnConfig = WYE
    daily::String = ""
    yearly::String = ""
    debugtrace::Bool = false
    dischargetrigger::Float64 = 0.0
    dispmode::String = "default"
    duty::String = ""
    dynadata::String = ""
    dynadll::String = "none"
    enabled::Status = ENABLED
    kv::Float64 = 12.47
    kva::Float64 = 50.0
    kvar::Float64 = 0.0
    kw::Float64 = 0.0
    kwhrated::Float64 = 50.0
    kwhstored::Float64 = 50.0
    kwrated::Float64 = 50.0
    like::String = ""
    model::Int = 1
    pf::Float64 = 1.0
    spectrum::String = "default"
    state::String = "idling"
    timecharging::Float64 = 2.0
    userdata::String = ""
    usermodel::String = "none"
    vmaxpu::Float64 = 1.1
    vminpu::Float64 = 0.9
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS CapControl defaults"
Base.@kwdef mutable struct DssCapcontrol <: DssControlObject
    name::String = ""
    element::String = ""
    capacitor::String = ""
    type::CapControlType = CAP_CURRENT
    ctphase::Int = 1
    ctratio::Float64 = 60.0
    deadtime::Float64 = 300.0
    delay::Float64 = 15.0
    delayoff::Float64 = 15.0
    eventlog::Bool = true
    offsetting::Float64 = 200.0
    onsetting::Float64 = 300.0
    ptphase::Int = 1
    ptratio::Float64 = 60.0
    terminal::Int = 1
    vbus::String = ""
    vmax::Float64 = 126.0
    vmin::Float64 = 115.0
    voltoverride::Bool = false
    pctminkvar::Float64 = 50.0
    enabled::Status = ENABLED
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS RegControl defaults"
Base.@kwdef mutable struct DssRegcontrol <: DssControlObject
    name::String = ""
    transformer::String = ""
    winding::Int = 1
    vreg::Float64 = 120.0
    band::Float64 = 3.0
    delay::Float64 = 15.0
    ptratio::Float64 = 60.0
    ctprim::Float64 = 300.0
    r::Float64 = 0.0
    x::Float64 = 0.0
    ptphase::Int = 1
    tapwinding::Int = winding
    bus::String = ""
    remoteptratio::Float64 = 60.0
    debugtrace::Bool = false
    eventlog::Bool = true
    inversetime::Bool = false
    maxtapchange::Int = 16
    revband::Float64 = 3.0
    revdelay::Float64 = 60.0
    reversible::Bool = false
    revneutral::Bool = false
    revr::Float64 = 0.0
    revthreshold::Float64 = 100.0
    revvreg::Float64 = 120.0
    revx::Float64 = 0.0
    tapdelay::Float64 = 2.0
    tapnum::Int = 0
    vlimit::Float64 = 0.0
    ldc_z::Vector{Float64} = Float64[0.0, 0.0]
    rev_z::Vector{Float64} = Float64[0.0, 0.0]
    cogen::Bool = false
    enabled::Status = ENABLED
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS EnergyMeter defaults"
Base.@kwdef mutable struct DssEnergymeter <: DssDataObject
    name::String = ""
    element::String = ""
    terminal::Int = 1
    action::String = ""
    clear::Bool = false
    save::Bool = false
    take = missing
    option::Vector{String} = String[]
    kwnorm::Float64 = 0.0
    kwemerg::Float64 = 0.0
    peakcurrent::Vector{Float64} = Float64[400, 400, 400]
    zonelist::Vector{String} = String[]
    localonly::Bool = false
    mask::Vector{Float64} = Float64[1, 1, 1]
    losses::Bool = true
    linelosses::Bool = true
    xfmrlosses::Bool = true
    seqlosses::Bool = true
    var"3phaselosses"::Bool = true
    vbaselosses::Bool = true
    basefreq::Float64 = 60.0
    enabled::Status = ENABLED
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS Monitor defaults"
Base.@kwdef mutable struct DssMonitor <: DssControlObject
    name::String = ""
    element::String = ""
    terminal::Int = 1
    mode::String = ""
    action::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS PVSystem defaults"
Base.@kwdef mutable struct DssPvsystem <: DssNodeObject
    name::String = ""
    phases::Int = 3
    bus1::String = ""
    kv::Float64 = 12.47
    irradiance::Float64 = 1.0
    pmpp::Float64 = 500.0
    var"%pmpp"::Float64 = 100.0
    temperature::Float64 = 25.0
    pf::Float64 = 1.0
    conn::ConnConfig = WYE
    kw::Float64 = 0.0
    kvar::Float64 = 0.0
    kva::Float64 = 500.0
    var"%cutin"::Float64 = 20.0
    var"%cutout"::Float64 = 20.0
    effcurve::String = ""
    var"p-tcurve"::String = ""
    var"%r"::Float64 = 0
    var"%x"::Float64 = 0.5
    model::Int = 1
    vminpu::Float64 = 0.9
    vmaxpu::Float64 = 1.1
    balanced::Bool = false
    limitcurrent::Bool = false
    yearly::String = ""
    daily::String = ""
    duty::String = ""
    tyearly::String = ""
    tdaily::String = ""
    tduty::String = ""
    class::Int = 1
    usermodel::String = ""
    userdata::String = ""
    debugtrace::Bool = false
    varfollowinverter::Bool = false
    dutystart::Float64 = 0.0
    wattpriority::Bool = false
    pfpriority::Bool = false
    var"%pminnovars"::Float64 = -1.0
    var"%pminkvarmax"::Float64 = -1.0
    kvarmax::Float64 = 500.0
    kvarmaxabs::Float64 = 500.0
    spectrum::String = "defaultpvsystem"
    basefreq::Float64 = 60.0
    enabled::Status = ENABLED
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS Recloser defaults"
Base.@kwdef mutable struct DssRecloser <: DssControlObject
    name::String = ""
    monitoredobj::String = ""
    monitoredterm::Int = 1
    switchedobj::String = ""
    switchedterm::Int = 1
    numfast::Int = 1
    phasefast::String = "a"
    phasedelayed::String = "d"
    groundfast::String = ""
    grounddelayed::String = ""
    phasetrip::Float64 = 1.0
    groundtrip::Float64 = 1.0
    phaseinst::Float64 = 0.0
    groundinst::Float64 = 0.0
    reset::Float64 = 15.0
    shots::Int = 4
    recloseintervals::Vector{Float64} = Float64[0.5, 2.0, 2.0]
    delay::Float64 = 0.0
    action::SwitchState = OPEN
    tdphfast::Float64 = 1.0
    tdgrfast::Float64 = 1.0
    tdphdelayed::Float64 = 1.0
    tdgrdelayed::Float64 = 1.0
    basefreq::Float64 = 60.0
    enabled::Status = ENABLED
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS Relay defaults"
Base.@kwdef mutable struct DssRelay <: DssControlObject
    name::String = ""
    monitoredobj::String = ""
    monitoredterm::Int = 1
    switchedobj::String = ""
    switchedterm::Int = 1
    type::String = ""
    phasecurve::String = ""
    groundcurve::String = ""
    phasetrip::Float64 = 1.0
    groundtrip::Float64 = 1.0
    tdphase::Float64 = 1.0
    tdground::Float64 = 1.0
    phaseinst::Float64 = 0.0
    groundinst::Float64 = 0.0
    reset::Float64 = 15.0
    shots::Int = 4
    recloseintervals::Vector{Float64} = Float64[0.5, 2.0, 2.0]
    delay::Float64 = 0.1
    overvoltcurve::String = ""
    undervoltcurve::String = ""
    kvbase::Float64 = 0.0
    var"47%pickup"::Float64 = 2.0
    var"46baseamps"::Float64 = 0.0
    var"46%pickup"::Float64 = 20.0
    var"46isqt"::Float64 = 1.0
    variable::String = ""
    overtrip::Float64 = 0.0
    undertrip::Float64 = 0.0
    breakertime::Float64 = 0.0
    action::SwitchState = OPEN
    basefreq::Float64 = 60.0
    enabled::Status = ENABLED
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS Fuse defaults"
Base.@kwdef mutable struct DssFuse <: DssControlObject
    name::String = ""
    monitoredobj::String = ""
    monitoredterm::Int = 1
    switchedobj::String = ""
    switchedterm::Int = 1
    fusecurve::String = ""
    ratedcurrent::Float64 = 1.0
    delay::Float64 = 0.0
    action::SwitchState = OPEN
    basefreq::Float64 = 60.0
    enabled::Status = ENABLED
    like::String = ""
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"OpenDSS SwtControl defaults"
Base.@kwdef mutable struct DssSwtcontrol <: DssControlObject
    name::String = ""
    action::SwitchState = OPEN
    basefreq::Float64 = 60.0
    delay::Float64 = 0.0
    enabled::Status = ENABLED
    like::String = ""
    lock::Dispatchable = YES
    normal::SwitchState = CLOSED
    reset::SwitchState = OPEN
    state::SwitchState = CLOSED
    switchedobj::String = ""
    switchedterm::Int = 1
    raw_dss::Vector{Pair{String,String}} = Pair{String,String}[]
end


"Parsed OpenDSS model struct"
Base.@kwdef mutable struct OpenDssDataModel <: DssModel
    filename::Vector{String} = Vector{String}()
    options::DssOptions = DssOptions()
    circuit::Dict{String,DssCircuit} = Dict{String,DssCircuit}()
    linecode::Dict{String,DssLinecode} = Dict{String,DssLinecode}()
    linegeometry::Dict{String,DssLinegeometry} = Dict{String,DssLinegeometry}()
    linespacing::Dict{String,DssLinespacing} = Dict{String,DssLinespacing}()
    loadshape::Dict{String,DssLoadshape} = Dict{String,DssLoadshape}()
    xycurve::Dict{String,DssXycurve} = Dict{String,DssXycurve}()
    growthshape::Dict{String,DssGrowthshape} = Dict{String,DssGrowthshape}()
    tcc_curve::Dict{String,DssTcc_curve} = Dict{String,DssTcc_curve}()
    cndata::Dict{String,DssCndata} = Dict{String,DssCndata}()
    tsdata::Dict{String,DssTsdata} = Dict{String,DssTsdata}()
    wiredata::Dict{String,DssWiredata} = Dict{String,DssWiredata}()
    xfmrcode::Dict{String,DssXfmrcode} = Dict{String,DssXfmrcode}()
    spectrum::Dict{String,DssSpectrum} = Dict{String,DssSpectrum}()
    vsource::Dict{String,DssVsource} = Dict{String,DssVsource}()
    isource::Dict{String,DssIsource} = Dict{String,DssIsource}()
    fault::Dict{String,DssFault} = Dict{String,DssFault}()
    capacitor::Dict{String,DssCapacitor} = Dict{String,DssCapacitor}()
    line::Dict{String,DssLine} = Dict{String,DssLine}()
    reactor::Dict{String,DssReactor} = Dict{String,DssReactor}()
    transformer::Dict{String,DssTransformer} = Dict{String,DssTransformer}()
    gictransformer::Dict{String,DssGictransformer} = Dict{String,DssGictransformer}()
    gicline::Dict{String,DssGicline} = Dict{String,DssGicline}()
    load::Dict{String,DssLoad} = Dict{String,DssLoad}()
    generator::Dict{String,DssGenerator} = Dict{String,DssGenerator}()
    indmach012::Dict{String,DssIndmach012} = Dict{String,DssIndmach012}()
    storage::Dict{String,DssStorage} = Dict{String,DssStorage}()
    capcontrol::Dict{String,DssCapcontrol} = Dict{String,DssCapcontrol}()
    regcontrol::Dict{String,DssRegcontrol} = Dict{String,DssRegcontrol}()
    energymeter::Dict{String,DssEnergymeter} = Dict{String,DssEnergymeter}()
    monitor::Dict{String,DssMonitor} = Dict{String,DssMonitor}()
    pvsystem::Dict{String,DssPvsystem} = Dict{String,DssPvsystem}()
    relay::Dict{String,DssRelay} = Dict{String,DssRelay}()
    recloser::Dict{String,DssRecloser} = Dict{String,DssRecloser}()
    fuse::Dict{String,DssFuse} = Dict{String,DssFuse}()
    swtcontrol::Dict{String,DssSwtcontrol} = Dict{String,DssSwtcontrol}()
    buscoordinates::Dict{String,DssBuscoords} = Dict{String,DssBuscoords}()
end

"Collect of objects that include 'mult' fields"
DssMultObjects = Union{DssLoadshape,DssXycurve,DssSpectrum,DssGrowthshape}

"Sub-collection of objects that are explicitly 'mult' types with intervals"
DssIntervalMultObjects = Union{DssXycurve,DssSpectrum}

"Collection of objects that inlude time series fields"
DssTimeSeriesObjects = Union{DssLoad,DssGenerator,DssStorage,DssPvsystem}


"Helper function to generate 'short' property names"
function _generate_short_property_names()::Dict{Type,Dict{String,String}}
    short_pn = Dict{Type,Dict{String,String}}()

    for fn in fieldnames(OpenDssDataModel)
        obj_type = fieldtype(OpenDssDataModel, fn)
        if obj_type <: Dict
            obj_type = obj_type.parameters[2]
        end
        short_pn[obj_type] = Dict{String,String}()

        indict = Set()
        obj_fields = string.(collect(fieldnames(obj_type)))
        for pn in obj_fields
            _pn = string(pn)
            while length(_pn) >= 1
                if _pn ∉ indict
                    short_pn[obj_type][_pn] = string(pn)
                elseif _pn ∈ obj_fields
                    short_pn[obj_type][_pn] = string(_pn)
                else
                    delete!(short_pn[obj_type], _pn)
                end
                push!(indict, _pn)
                _pn = _pn[1:end-1]
            end
        end
    end

    return short_pn
end


"const built at import of short property names"
const _dss_short_prop_names_map = _generate_short_property_names()
