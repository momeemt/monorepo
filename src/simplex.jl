@enum Comparison le eq ge

struct Constraint
    left::Dict{String,Int}
    right::Int
    cmp::Comparison
end

struct LP
    is_maximization::Bool
    objective_function::Dict{String,Int}
    constraints::Vector{Constraint}
    variable_constraints::Vector{Constraint}
    variables::Vector{String}
end

struct DictExpr
    constant::Int
    nonbasic_vars::Dict{String,Int}
end

struct Dictionary
    basic_variables::Vector{String}
    nonbasic_variables::Vector{String}
    objective_function::DictExpr
    basic_vars_expr::Vector{DictExpr}
end

function Base.show(io::IO, c::Constraint)
    sorted_keys = sort(collect(keys(c.left)))
    terms = ["($(c.left[k])) * $k" for k in sorted_keys]
    equation = join(terms, " + ")
    cmp_str = c.cmp == le ? " <= " : c.cmp == eq ? " = " : " >= "
    println(io, "$equation $cmp_str $(c.right)")
end

function Base.show(io::IO, lp::LP)
    sorted_keys = sort(collect(keys(lp.objective_function)))
    obj_terms = ["($(lp.objective_function[k])) * $k" for k in sorted_keys]
    obj_str = join(obj_terms, " + ")
    constraints_str = join([string(c) for c in lp.constraints], "\n")
    variables_str = join([string(v) for v in lp.variables], "\n")
    println(
        io,
        "Objective Function:\n$obj_str\n\nConstraints:\n$constraints_str\n\nVariables:\n$variables_str",
    )
end

function Base.show(io::IO, expr::DictExpr)
    sorted_keys = sort(collect(keys(expr.nonbasic_vars)))
    terms = ["($(expr.nonbasic_vars[k])) * $k" for k in sorted_keys]
    equation = join(terms, " - ")
    print(io, "$(expr.constant) + $equation")
end

function Base.show(io::IO, dict::Dictionary)
    println(io, "Basic Variables: ", join(dict.basic_variables, ", "))
    println(io, "Non-Basic Variables: ", join(dict.nonbasic_variables, ", "))
    print(io, "Objective Function: ")
    show(io, dict.objective_function)
    println(io)
    for (i, expr) in enumerate(dict.basic_vars_expr)
        println(io, "$(dict.basic_variables[i]) = ", expr)
    end
end

function to_canonical_form_lp(lp::LP)::LP
    result_constraints = deepcopy(lp.constraints)
    objective_function = deepcopy(lp.objective_function)
    result_variables = deepcopy(lp.variables)
    rest_variables = deepcopy(lp.variables)

    for vc in lp.variable_constraints
        var = first(keys(vc.left))
        rest_variables = setdiff(rest_variables, [var])
        if vc.cmp == ge
            continue
        end
        new_var = "$(var)'"

        for constraint in result_constraints
            if haskey(constraint.left, var)
                coeff = constraint.left[var]
                constraint.left[new_var] = -coeff
                delete!(constraint.left, var)
                result_variables = setdiff(result_variables, [var])
                result_variables = union(result_variables, [new_var])
            end
        end

        if haskey(objective_function, var)
            coeff = objective_function[var]
            objective_function[new_var] = -coeff
            delete!(objective_function, var)
        end
    end

    for var in rest_variables
        new_var1 = "$(var)'"
        new_var2 = "$(var)''"
        for constraint in result_constraints
            if haskey(constraint.left, var)
                coeff = constraint.left[var]
                constraint.left[new_var1] = coeff
                constraint.left[new_var2] = -coeff
                delete!(constraint.left, var)
                result_variables = setdiff(result_variables, [var])
                result_variables = union(result_variables, [new_var1])
                result_variables = union(result_variables, [new_var2])
            end
        end
        if haskey(objective_function, var)
            coeff = objective_function[var]
            objective_function[new_var1] = coeff
            objective_function[new_var2] = -coeff
            delete!(objective_function, var)
        end
    end

    if !lp.is_maximization
        objective_function = Dict(k => -v for (k, v) in objective_function)
    end

    result = LP(true, objective_function, [], result_constraints, result_variables)

    for constraint in result_constraints
        if constraint.cmp == eq
            constraint1 = Constraint(constraint.left, constraint.right, le)
            constraint2 = Constraint(
                Dict(k => -v for (k, v) in constraint.left),
                -constraint.right,
                le,
            )
            append!(result.constraints, [constraint1, constraint2])
        elseif constraint.cmp == ge
            new_constraint = Constraint(
                Dict(k => -v for (k, v) in constraint.left),
                -constraint.right,
                le,
            )
            append!(result.constraints, [new_constraint])
        else
            append!(result.constraints, [constraint])
        end
    end
    return result
end

function to_dictionary(lp::LP)::Dictionary
    basic_variables = Vector{String}()
    nonbasic_variables = deepcopy(lp.variables)
    basic_vars_expr = Vector{DictExpr}()

    for (i, constraint) in enumerate(lp.constraints)
        basic_var = "x$(i + length(nonbasic_variables))"
        push!(basic_variables, basic_var)
        push!(basic_vars_expr, DictExpr(constraint.right, constraint.left))
    end

    obj_expr = DictExpr(0, lp.objective_function)
    return Dictionary(basic_variables, nonbasic_variables, obj_expr, basic_vars_expr)
end

lp = LP(
    false,
    Dict("x1" => -2, "x2" => 1, "x3" => -5, "x4" => 3),
    [
        Constraint(Dict("x1" => 1, "x2" => -2, "x3" => -4, "x4" => 1), -6, eq),
        Constraint(Dict("x1" => -3, "x2" => 2, "x3" => -2, "x4" => -4), -1, le),
        Constraint(Dict("x1" => 5, "x2" => -2, "x3" => 0, "x4" => 7), 9, ge),
    ],
    [
        Constraint(Dict("x1" => 1), 0, ge),
        Constraint(Dict("x3" => 1), 0, le),
        Constraint(Dict("x4" => 1), 0, ge),
    ],
    ["x1", "x2", "x3", "x4"],
)

lp2 = LP(
    true,
    Dict("x1" => 1, "x2" => 1, "x3" => 2),
    [
        Constraint(Dict("x1" => -3, "x2" => 2, "x3" => -2), 1, le),
        Constraint(Dict("x2" => 1, "x3" => 1), 3, le),
        Constraint(Dict("x1" => 2, "x3" => 1), 2, le),
    ],
    [
        Constraint(Dict("x1" => 1), 0, ge),
        Constraint(Dict("x2" => 1), 0, ge),
        Constraint(Dict("x3" => 1), 0, ge),
    ],
    ["x1", "x2", "x3"],
)

println(to_dictionary(lp2))
