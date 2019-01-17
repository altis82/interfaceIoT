using JuMP  # Need to say it whenever we use JuMP

using GLPKMathProgInterface # Loading the GLPK module for using its solver



myModel = Model(solver=GLPKSolverLP())

@defVar(myModel, x >= 0) # Models x >=0

@defVar(myModel, y >= 0) # Models y >= 0

@setObjective(myModel, Min, x + y) # Sets the objective to be minimized. For maximization use Max

@addConstraint(myModel, x + y <= 1) # Adds the constraint x + y <= 1

println("The optimization problem to be solved is:")
print(myModel) # Shows the model constructed in a human-readable form

#SOLVE IT AND DISPLAY THE RESULTS
#--------------------------------
status = solve(myModel) # solves the model

println("Objective value: ", getObjectiveValue(myModel)) # getObjectiveValue(model_name) gives the optimum objective value
println("x = ", getValue(x)) # getValue(decision_variable) will give the optimum value of the associated decision variable
println("y = ", getValue(y))
