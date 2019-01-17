using JuMP  # Need to say it whenever we use JuMP

using GLPKMathProgInterface # Loading the GLPK module for using its solver
using SCS
using CVXOPT
#define a set of interface type
Wifi=1;
Blue=2
LTE=3
T=[Wifi,Blue,LTE]
#setting capacity of interface
Cap=[500,100,20]
#
rate=[10,5,2]
#define a set of devices
N=10 #numbers of devices
#interface-device matrix
interface_devices=rand(0:1,N,length(T))

cost=ones(N,length(T))

for j=1:length(T)
    for i=1:N
        if j==Wifi
            cost[i,j]=5
        elseif j==Blue
            cost[i,j]=2
        else
            cost[i,j]=10
        end

    end
end
myModel = Model(solver=GLPKSolverLP())

#define activation interface of devices
@defVar(myModel, x[1:N,1:length(T)] >= 0) # Models x >=0

for i=1:N
    for j=1:length(T)
        @addConstraint(myModel,x[i,j]<=interface_devices[i,j])
    end
end
#define capacity Constraints
for j=1:length(T)
    @addConstraint(myModel,sum(x[:,j]*rate[j])<=Cap[j])
end
#constraint to ensure all devices will send data
for i=1:N
    @addConstraint(myModel,sum(x[i,:])>=1)
end
#calculate the cost

obj=0
for i=1:N
    for j=1:length(T)
        obj=obj+x[i,j]*cost[i,j]
    end
end

@setObjective(myModel, Min, obj) # Sets the objective to be minimized. For maximization use Max

println("The optimization problem to be solved is:")
print(myModel) # Shows the model constructed in a human-readable form

#SOLVE IT AND DISPLAY THE RESULTS
#--------------------------------
status = solve(myModel) # solves the model

println("Objective value: ", getObjectiveValue(myModel)) # getObjectiveValue(model_name) gives the optimum objective value
println("x = ", getValue(x))
# getValue(decision_variable) will give the optimum value of the associated decision variable
