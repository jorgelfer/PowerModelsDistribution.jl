"""
"""
function transform_data_model(::Type{DssModel}, raw_dss::OpenDssRawDataModel)::OpenDssDataModel
    dss = OpenDssDataModel(;
        options = create_dss_object(DssOptions, raw_dss.options),
        filename = raw_dss.filename
    )

    for (pn, property) in raw_dss
        if isa(property, Dict{String,Vector{Pair{String,String}}})
            for (name, property_pairs) in property
                getproperty(dss, Symbol(pn))[name] = create_dss_object(valtype(fieldtype(typeof(dss), Symbol(pn))), property_pairs, dss, raw_dss)
            end
        elseif pn == "buscoordinates"
            setproperty!(dss, Symbol(pn), Dict{String,DssBuscoords}(buscoords.bus => buscoords for buscoords in property))
        elseif !isempty(property) && pn ∉ ["current_state", "filename", "options"]
            @info "missing parser for '$pn'"
        end
    end

    return dss
end


""
parse_dss(file::String)::OpenDssDataModel = transform_data_model(DssModel, parse_raw_dss(FilePaths.Path(file)))
parse_dss(path::FilePaths.AbstractPath)::OpenDssDataModel = transform_data_model(DssModel, parse_raw_dss(path))
parse_dss(io::IO)::OpenDssDataModel = transform_data_model(DssModel, parse_raw_dss(io))


"""
"""
function Base.setproperty!(@nospecialize(dss_obj::DssObject), property_name::String, property_value::String, data_type::Type)
    property_value = data_type == Bool && property_value ∈ ["y", "n", "yes", "no", "true", "false"] ? startswith(property_value, "y") || startswith(property_value, "t") ? "true" : "false" : property_value
    setproperty!(dss_obj, Symbol(property_name), _isa_rpn(property_value) ? _parse_rpn(data_type, property_value) : parse(data_type, property_value))
end


"""
"""
function _apply_property_pairs(dss_obj::T, property_pairs::Vector{Pair{String,String}})::T where T <: DssOptions
    for (pn, v) in filter(x->x.first != "__path__", property_pairs)
        pn = _infer_partial_property_name(pn, dss_obj)
        if Symbol(pn) ∉ propertynames(dss_obj) && pn != "__path__"
            @warn "$(T) has no field `$(pn)`, skipping..."
            continue
        end

        setproperty!(dss_obj, pn, v, fieldtype(typeof(dss_obj), Symbol(pn)))
    end

    dss_obj.raw_dss = filter(x->x.first != "__path__", property_pairs)

    return dss_obj
end


"""
"""
function _apply_property_pairs(dss_obj::T, property_pairs::Vector{Pair{String,String}}, dss::OpenDssDataModel, dss_raw::OpenDssRawDataModel)::T where T <: DssObject
    raw_fields = _get_raw_fields(property_pairs)

    obj_type = Symbol(lowercase(replace(replace(string(T), "Dss"=>""), "PowerModelsDistribution."=>"")))
    for (pn, v) in filter(x->x.first != "__path__", property_pairs)
        pn = _infer_partial_property_name(pn, dss_obj)
        if Symbol(pn) ∉ propertynames(dss_obj) && pn != "__path__"
            @warn "$(T) has no field `$(pn)`, skipping..."
            continue
        end
        if pn == "like"
            if v in keys(getproperty(dss, obj_type))
                like_dss_obj = getproperty(dss, obj_type)[v]
            elseif v in keys(getproperty(dss_raw, obj_type))
                like_dss_obj = create_dss_object(T, getproperty(dss_raw, obj_type)[v], dss, dss_raw)
            else
                @warn "$(obj_type).$(v) does not exist, can't apply 'like' on $(obj_type).$(getproperty(dss_obj, :name))"
                continue
            end
            merge!(dss_obj, like_dss_obj)
        end
        setproperty!(dss_obj, pn, v, fieldtype(typeof(dss_obj), Symbol(pn)))
    end

    dss_obj.raw_dss = filter(x->x.first != "__path__", property_pairs)

    :phases ∉ raw_fields && _get_implied_nphases!(dss_obj)

    return dss_obj
end


"""
"""
function _apply_property_pairs(dss_obj::T, property_pairs::Vector{Pair{String,String}}, dss::OpenDssDataModel, dss_raw::OpenDssRawDataModel)::T where T <: DssRegcontrol
    raw_fields = _get_raw_fields(property_pairs)

    obj_type = Symbol(lowercase(replace(replace(string(T), "Dss"=>""), "PowerModelsDistribution."=>"")))
    for (pn, v) in filter(x->x.first != "__path__", property_pairs)
        pn = _infer_partial_property_name(pn, dss_obj)
        if Symbol(pn) ∉ propertynames(dss_obj) && pn != "__path__"
            @warn "$(T) has no field `$(pn)`, skipping..."
            continue
        end
        if pn == "like"
            if v in keys(getproperty(dss, obj_type))
                like_dss_obj = getproperty(dss, obj_type)[v]
            elseif v in keys(getproperty(dss_raw, obj_type))
                like_dss_obj = create_dss_object(T, getproperty(dss_raw, obj_type)[v], dss, dss_raw)
            else
                @warn "$(obj_type).$(v) does not exist, can't apply 'like' on $(obj_type).$(getproperty(dss_obj, :name))"
                continue
            end
            merge!(dss_obj, like_dss_obj)
        end
        setproperty!(dss_obj, pn, v, fieldtype(typeof(dss_obj), Symbol(pn)))
    end

    dss_obj.raw_dss = filter(x->x.first != "__path__", property_pairs)

    :phases ∉ raw_fields && _get_implied_nphases!(dss_obj)

    if :tapwinding ∉ raw_fields && :winding ∈ raw_fields
        dss_obj.tapwinding = dss_obj.winding
    end

    return dss_obj
end


"""
"""
function _apply_property_pairs(dss_obj::T, property_pairs::Vector{Pair{String,String}}, dss::OpenDssDataModel, dss_raw::OpenDssRawDataModel)::T where T <: DssMultObjects
    obj_type = Symbol(lowercase(replace(replace(string(T), "Dss"=>""), "PowerModelsDistribution."=>"")))

    interval_leq_zero = false
    __path__ = ""

    for (pn, v) in property_pairs
        pn = _infer_partial_property_name(pn, dss_obj)
        if Symbol(pn) ∉ propertynames(dss_obj) && pn != "__path__"
            @warn "$(T) has no field `$(pn)`, skipping..."
            continue
        end

        if pn == "__path__"
            __path__ = v
        end

        if pn == "like"
            if v in keys(getproperty(dss, obj_type))
                like_dss_obj = getproperty(dss, obj_type)[v]
            elseif v in keys(getproperty(dss_raw, obj_type))
                like_dss_obj = create_dss_object(T, getproperty(dss_raw, obj_type)[v], dss, dss_raw)
            else
                @warn "$(obj_type).$(v) does not exist, can't apply 'like' on $(obj_type).$(getproperty(dss_obj, :name))"
                continue
            end
            merge!(dss_obj, like_dss_obj)
        end

        if pn ∈ ["csvfile", "sngfile", "dblfile", "pqcsvfile"]
            setproperty!(dss_obj, Symbol(pn), v)

            interval = typeof(dss_obj) <: DssIntervalMultObjects ? true : interval_leq_zero
            pn = typeof(dss_obj) <: DssSpectrum ? "pqcsvfile" : pn
            hour, mult, pmult, qmult = getproperty(PowerModelsDistribution, Symbol("_parse_$(pn)"))(joinpath(__path__, v); interval=interval)

            if typeof(dss_obj) <: DssLoadshape
                if !isempty(hour)
                    setproperty!(dss_obj, :hour, hour)
                end
                setproperty!(dss_obj, :pmult, pmult)
                setproperty!(dss_obj, :qmult, qmult)
            elseif typeof(dss_obj) <: DssGrowthshape
                if !isempty(hour)
                    setproperty!(dss_obj, :year, hour)
                end
                setproperty!(dss_obj, :mult, mult)
            elseif typeof(dss_obj) <: DssXycurve
                setproperty!(dss_obj, :xarray, hour)
                setproperty!(dss_obj, :yarray, mult)
            elseif typeof(dss_obj) <: DssSpectrum
                setproperty!(dss_obj, :harmonic, hour)
                setproperty!(dss_obj, Symbol("%mag"), pmult)
                setproperty!(dss_obj, :angle, qmult)
            end

        elseif pn ∈ ["mult", "pmult", "qmult", "xarray", "yarray", "points"] && occursin("=", v)
            _parse_file_inside_mult!(dss_obj, __path__, pn, v)
        else
            if pn != "__path__"
                setproperty!(dss_obj, pn, v, fieldtype(typeof(dss_obj), Symbol(pn)))
            end

            interval_leq_zero = pn ∈ ["interval", "minterval", "sinterval"] && getproperty(dss_obj, Symbol(pn)) <= 0 ? true : false
        end
    end

    dss_obj.raw_dss = filter(x->x.first != "__path__", property_pairs)

    return dss_obj
end


"""
"""
function _apply_property_pairs(dss_obj::T, property_pairs::Vector{Pair{String,String}}, dss::OpenDssDataModel, dss_raw::OpenDssRawDataModel)::T where T <: DssTimeSeriesObjects
    obj_type = Symbol(lowercase(replace(replace(string(T), "Dss"=>""), "PowerModelsDistribution."=>"")))

    __path__ = ""

    for (pn, v) in property_pairs
        pn = _infer_partial_property_name(pn, dss_obj)
        if Symbol(pn) ∉ propertynames(dss_obj) && pn != "__path__"
            @warn "$(T) has no field `$(pn)`, skipping..."
            continue
        end

        if pn == "__path__"
            __path__ = v
        end

        if pn == "like"
            if v in keys(getproperty(dss, obj_type))
                like_dss_obj = getproperty(dss, obj_type)[v]
            elseif v in keys(getproperty(dss_raw, obj_type))
                like_dss_obj = create_dss_object(T, getproperty(dss_raw, obj_type)[v], dss, dss_raw)
            else
                @warn "$(obj_type).$(v) does not exist, can't apply 'like' on $(obj_type).$(getproperty(dss_obj, :name))"
                continue
            end
            merge!(dss_obj, like_dss_obj)
        end

        if pn ∈ ["daily", "yearly", "duty", "growth", "tdaily", "tyearly", "tduty"] && occursin("=", v)
            _parse_file_inside_shape_ref!(dss_obj, dss, dss_raw, __path__, pn, v)
        else
            if pn != "__path__"
                setproperty!(dss_obj, pn, v, fieldtype(typeof(dss_obj), Symbol(pn)))
            end
        end
    end

    dss_obj.raw_dss = filter(x->x.first != "__path__", property_pairs)

    return dss_obj
end


"""
"""
function _apply_property_pairs(dss_obj::T, property_pairs::Vector{Pair{String,String}}, dss::OpenDssDataModel, dss_raw::OpenDssRawDataModel)::T where T <: Union{DssTransformer,DssXfmrcode}
    raw_fields = _get_raw_fields(property_pairs)

    obj_type = :transformer
    pn_map = Dict{Symbol,Symbol}(:bus=>:buses, :tap=>:taps, :conn=>:conns, :kv=>:kvs, :kva=>:kvas, Symbol("%r")=>Symbol("%rs"))
    pn_map = T <: DssXfmrcode ? filter(x->x.first!=:bus,pn_map) : pn_map

    windings_pair = filter(x->x.first=="windings", property_pairs)
    windings = isempty(windings_pair) ? 2 : parse(Int, first(windings_pair).second)
    for (pn_fr, pn_to) in pn_map
        setproperty!(dss_obj, pn_to, fill(getproperty(dss_obj, pn_fr), windings))
    end

    _wdg = windings
    for (pn, v) in filter(x->x.first != "__path__", property_pairs)
        if Symbol(pn) ∉ propertynames(dss_obj) && pn != "__path__"
            @warn "$(T) has no field `$(pn)`, skipping..."
            continue
        end

        if pn == "like"
            if v in keys(getproperty(dss, obj_type))
                like_dss_obj = getproperty(dss, obj_type)[v]
            elseif v in keys(getproperty(dss_raw, obj_type))
                like_dss_obj = create_dss_object(T, getproperty(dss_raw, obj_type)[v], dss, dss_raw)
            else
                @warn "$(obj_type).$(v) does not exist, can't apply 'like' on $(obj_type).$(getproperty(dss_obj, :name))"
                continue
            end
            merge!(dss_obj, like_dss_obj)
        elseif pn == "wdg"
            _wdg = parse(Int, v)
        elseif pn ∈ ["bus", "tap", "conn", "kv", "kva", "%r"]
            dtype = fieldtype(DssTransformer, Symbol(pn))
            getproperty(dss_obj, pn_map[Symbol(pn)])[_wdg] = _isa_rpn(v) ? _parse_rpn(dtype, v) : parse(dtype, v)
        end
        setproperty!(dss_obj, pn, v, fieldtype(typeof(dss_obj), Symbol(pn)))
    end

    :phases ∉ raw_fields && _get_implied_nphases!(dss_obj)

    dss_obj.raw_dss = filter(x->x.first != "__path__", property_pairs)

    return dss_obj
end


"""
"""
function _apply_property_pairs(dss_obj::T, property_pairs::Vector{Pair{String,String}}, dss::OpenDssDataModel, dss_raw::OpenDssRawDataModel)::T where T <: DssLinegeometry
    obj_type = :linegeometry
    pn_map = Dict{Symbol,Symbol}(:wire => :wires, :cncable => :cncables, :tscable => :tscables, :cond => :fconds, :x => :xs, :h => :hs, :units => :unitss)

    nconds_pair = filter(x->x.first=="nconds", property_pairs)
    nconds = isempty(nconds_pair) ? 3 : parse(Int, first(nconds_pair).second)
    for (pn_fr, pn_to) in pn_map
        setproperty!(dss_obj, pn_to, fill(getproperty(dss_obj, pn_fr), nconds))
    end

    _cond = 1
    for (pn, v) in filter(x->x.first != "__path__", property_pairs)
        if Symbol(pn) ∉ propertynames(dss_obj) && pn != "__path__"
            @warn "$(T) has no field `$(pn)`, skipping..."
            continue
        end

        if pn == "like"
            if v in keys(getproperty(dss, obj_type))
                like_dss_obj = getproperty(dss, obj_type)[v]
            elseif v in keys(getproperty(dss_raw, obj_type))
                like_dss_obj = create_dss_object(T, getproperty(dss_raw, obj_type)[v], dss, dss_raw)
            else
                @warn "$(obj_type).$(v) does not exist, can't apply 'like' on $(obj_type).$(getproperty(dss_obj, :name))"
                continue
            end
            merge!(dss_obj, like_dss_obj)
        elseif pn == "cond"
            _cond = parse(Int, v)
        elseif pn ∈ ["wire", "cncable", "tscable", "x", "h", "units"]
            dtype = fieldtype(DssLinegeometry, Symbol(pn))
            getproperty(dss_obj, pn_map[Symbol(pn)])[_cond] = _isa_rpn(v) ? _parse_rpn(dtype, v) : parse(dtype, v)
        end
        setproperty!(dss_obj, pn, v, fieldtype(typeof(dss_obj), Symbol(pn)))
    end

    for k in [:wires, :tscables, :cncables]
        if all(isempty(v) for v in getproperty(dss_obj, k))
            setproperty!(dss_obj, k, String[])
        end
    end

    setproperty!(dss_obj, :fx, getproperty(dss_obj, :xs))
    setproperty!(dss_obj, :fh, getproperty(dss_obj, :hs))

    dss_obj.raw_dss = filter(x->x.first != "__path__", property_pairs)

    return dss_obj
end


"""
"""
function _parse_csvfile(path::String; header::Bool=false, interval::Bool=false, npts::Union{Int,Missing}=missing)::NTuple{4, Vector{Float64}}
    d = open(path, "r") do io
        parse.(Float64, mapreduce(permutedims, vcat, split.(readlines(io)[(header ? 2 : 1):end], r",")))
    end

    if interval
        hour = d[:,1]
        mult = d[:,2]
    else
        hour = Float64[]
        mult = d[:,1]
    end

    return (hour, mult, mult, mult)
end


"""
"""
function _parse_pqcsvfile(path::String; header::Bool=false, interval::Bool=false, npts::Union{Int,Missing}=missing)::NTuple{4, Vector{Float64}}
    d = open(path, "r") do io
        parse.(Float64, mapreduce(permutedims, vcat, split.(readlines(io)[(header ? 2 : 1):end], r",")))
    end

    if interval
        hour = d[:,1]
        pmult = d[:,2]
        qmult = d[:,3]
    else
        hour = Float64[]
        pmult = d[:,1]
        qmult = d[:,2]
    end

    return hour, pmult, pmult, qmult
end


"""
"""
function _parse_sngfile(path::String; header::Bool=false, interval::Bool=false, npts::Union{Int,Missing}=missing)::NTuple{4, Vector{Float32}}
    hour = Float64[]
    mult = Float64[]

    open(path, "r") do io
        if ismissing(npts)
            data = Float32[]
            while true
                try
                    n = read(io, Float32)
                    push!(data, n)
                catch EOFError
                    break
                end
            end
        else
            data = Array{Float32, 1}(undef, interval ? npts * 2 : npts)

            try
                read!(io, data)
            catch EOFError
                error("Error reading binary file: likely npts is wrong")
            end
        end

        if interval
            data = reshape(data, 2, :)
            push!(hour, data[1, :]...)
            push!(mult, data[2, :]...)
        else
            push!(mult, data...)
        end
    end

    return hour, mult, mult, mult
end


"""
"""
function _parse_dblfile(path::String; header::Bool=false, interval::Bool=false, npts::Union{Int,Missing}=missing)::NTuple{4, Vector{Float64}}
    hour = Float64[]
    mult = Float64[]

    open(path, "r") do io
        if ismissing(npts)
            data = Float64[]
            while true
                try
                    n = read(io, Float64)
                    push!(data, n)
                catch EOFError
                    break
                end
            end
        else
            data = Array{Float64, 1}(undef, interval ? npts * 2 : npts)

            try
                read!(io, data)
            catch EOFError
                error("Error reading binary file: likely npts is wrong")
            end
        end

        if interval
            data = reshape(data, 2, :)
            push!(hour, data[1, :]...)
            push!(mult, data[2, :]...)
        else
            push!(mult, data...)
        end
    end

    return hour, mult, mult, mult
end


"""
"""
function _isa_dss_array(data::String)::Bool
    isa_array = false

    clean_data = strip(data)
    if !occursin("|", clean_data)
        if occursin(",", clean_data) ||
            (startswith(clean_data, "[") && endswith(clean_data, "]")) ||
            (startswith(clean_data, "\"") && endswith(clean_data, "\"")) ||
            (startswith(clean_data, "\'") && endswith(clean_data, "\'")) ||
            (startswith(clean_data, "(") && endswith(clean_data, ")")) ||
            (startswith(clean_data, "{") && endswith(clean_data, "}"))
            isa_array = true
        end
    end

    return isa_array
end


"""
"""
function _parse_file_inside_mult!(dss_obj::DssObject, __path__::String, pn::String, v::String)::Vector{Float64}
    _property_pairs = Pair{String,String}[]
    for _match in eachmatch(_dss_cmd_new_regex, v)
        push!(_property_pairs, _parse_match_element(_match, "",))
    end
    raw_fields = _get_raw_fields(_property_pairs)
    _properties = Dict{String,String}(_property_pairs)

    col = parse(Int, get(_properties, "col", "1"))
    _header = get(_properties, "header", "false")
    header = parse(Bool, startswith(_header, "y") || startswith(_header, "t") ? "true" : "false")
    interval = :pqcsvfile ∈ raw_fields ? col > 2 : col > 1
    col = col + (interval ? 0 : 1)

    if :csvfile ∈ raw_fields
        setproperty!(dss_obj, Symbol(pn), _parse_csvfile(joinpath(__path__, _properties["csvfile"]); interval=interval, header=header)[col])
    elseif :file ∈ raw_fields
        setproperty!(dss_obj, Symbol(pn), _parse_csvfile(joinpath(__path__, _properties["file"]); interval=interval, header=header)[col])
    elseif :pqcsvfile ∈ raw_fields
        setproperty!(dss_obj, Symbol(pn), _parse_pqcsvfile(joinpath(__path__, _properties["pqcsvfile"]); interval=interval, header=header)[col])
    elseif :sngfile ∈ raw_fields
        setproperty!(dss_obj, Symbol(pn), _parse_sngfile(joinpath(__path__, _properties["sngfile"]); interval=interval, header=header)[col])
    elseif :dblfile ∈ raw_fields
        setproperty!(dss_obj, Symbol(pn), _parse_dblfile(joinpath(__path__, _properties["dblfile"]); interval=interval, header=header)[col])
    end
end


"""
"""
function _parse_file_inside_shape_ref!(dss_obj::DssObject, dss::OpenDssDataModel, dss_raw::OpenDssRawDataModel, __path__::String, pn::String, v::String)::Vector{Float64}
    _property_pairs = Pair{String,String}[]
    for _match in eachmatch(_dss_cmd_new_regex, v)
        push!(_property_pairs, _parse_match_element(_match, "",))
    end
    raw_fields = _get_raw_fields(_property_pairs)
    _properties = Dict{String,String}(_property_pairs)

    col = parse(Int, get(_properties, "col", "1"))
    _header = get(_properties, "header", "false")
    header = parse(Bool, startswith(_header, "y") || startswith(_header, "t") ? "true" : "false")
    interval = :pqcsvfile ∈ raw_fields ? col > 2 : col > 1
    col = col + (interval ? 0 : 1)

    data = Float64[]
    if :csvfile ∈ raw_fields
        push!(data, Symbol(pn), _parse_csvfile(joinpath(__path__, _properties["csvfile"]); interval=interval, header=header)[col])
    elseif :file ∈ raw_fields
        push!(data, Symbol(pn), _parse_csvfile(joinpath(__path__, _properties["file"]); interval=interval, header=header)[col])
    elseif :pqcsvfile ∈ raw_fields
        push!(data, Symbol(pn), _parse_pqcsvfile(joinpath(__path__, _properties["pqcsvfile"]); interval=interval, header=header)[col])
    elseif :sngfile ∈ raw_fields
        push!(data, Symbol(pn), _parse_sngfile(joinpath(__path__, _properties["sngfile"]); interval=interval, header=header)[col])
    elseif :dblfile ∈ raw_fields
        push!(data, Symbol(pn), _parse_dblfile(joinpath(__path__, _properties["dblfile"]); interval=interval, header=header)[col])
    end
    loadshape = create_dss_object(
        DssLoadshape,
        [
            "name"=>"$(lowercase(string(dss_obj)[4:end]))_$(dss_obj.name)_$(pn)",
            "pmult"=>string(data),
        ],
        dss,
        dss_raw,
    )

    setproperty!(dss_obj, Symbol(pn), loadshape.name)

    dss.loadshape[loadshape.name] = loadshape
end


""
function _get_implied_nphases!(dss_obj::DssNodeObject; default::Int=dss_obj.phases)::Int
    dss_obj.phases = _get_implied_nphases(dss_obj.bus1; default=default)
end


""
function _get_implied_nphases!(dss_obj::DssEdgeObject; default::Int=dss_obj.phases)::Int
    dss_obj.phases = _get_implied_nphases(dss_obj.bus1, dss_obj.bus2; default=default)
end


""
function _get_implied_nphases!(::Union{DssControlObject,DssDataObject}; default::Int=0)::Int
    default
end


""
function _get_implied_nphases!(dss_obj::DssLinecode; default::Int=dss_obj.nphases)::Int
    dss_obj.nphases = default
end


""
function _get_implied_nphases!(dss_obj::DssTransformer; default::Int=dss_obj.phases)::Int
    dss_obj.phases = _get_implied_nphases(dss_obj.buses; default=default)
end


""
function _get_implied_nphases!(dss_obj::DssXfmrcode; default::Int=dss_obj.phases)::Int
    dss_obj.phases = default
end


""
function _get_implied_nphases!(dss_obj::DssGictransformer; default::Int=dss_obj.phases)::Int
    dss_obj.phases = _get_implied_nphases(dss_obj.bush, dss_obj.busx; default=default)
end
