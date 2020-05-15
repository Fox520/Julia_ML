using CSV
using Statistics
using DataFrames
using StatsBase  # For standardization

file_path = "student-mat.csv"
df = CSV.read(file_path)
m = convert(Matrix, df)

school_vector = Array{String,1}(undef, size(m)[1])
sex_vector = Array{String,1}(undef, size(m)[1])
address_vector = Array{String,1}(undef, size(m)[1])
famsize_vector = Array{String,1}(undef, size(m)[1])
pstatus_vector = Array{String,1}(undef, size(m)[1])
mjob_vector = Array{String,1}(undef, size(m)[1])
fjob_vector = Array{String,1}(undef, size(m)[1])
reason_vector = Array{String,1}(undef, size(m)[1])
guardian_vector = Array{String,1}(undef, size(m)[1])
schoolsup_vector = Array{String,1}(undef, size(m)[1])
famsup_vector = Array{String,1}(undef, size(m)[1])
paid_vector = Array{String,1}(undef, size(m)[1])
activities_vector = Array{String,1}(undef, size(m)[1])
nursery_vector = Array{String,1}(undef, size(m)[1])
higher_vector = Array{String,1}(undef, size(m)[1])
internet_vector = Array{String,1}(undef, size(m)[1])
romantic_vector = Array{String,1}(undef, size(m)[1])

# Please make refactor me
for i in 1:size(m)[1]
    for j in 1:size(m)[2]
        if j == 1
            school_vector[i] = m[i,j]

        elseif j == 2
            sex_vector[i] = m[i,j]
        elseif j == 4
            address_vector[i] = m[i,j]
        elseif j == 5
            famsize_vector[i] = m[i,j]
        elseif j == 6
            pstatus_vector[i] = m[i,j]
        elseif j == 9
            mjob_vector[i] = m[i,j]
        elseif j == 10
            fjob_vector[i] = m[i,j]
        elseif j == 11
            reason_vector[i] = m[i,j]
        elseif j == 12
            guardian_vector[i] = m[i,j]
        elseif j == 16
            schoolsup_vector[i] = m[i,j]
        elseif j == 17
            famsup_vector[i] = m[i,j]
        elseif j == 18
            paid_vector[i] = m[i,j]
        elseif j == 19
            activities_vector[i] = m[i,j]
        elseif j == 20
            nursery_vector[i] = m[i,j]
        elseif j == 21
            higher_vector[i] = m[i,j]
        elseif j == 22
            internet_vector[i] = m[i,j]
        elseif j == 23
            romantic_vector[i] = m[i,j]
        end
        # println()
    end
    # mv = Array{String}(undef, length(m))
    # println(m[i,1])
end

function map_to_int(arr)
    # Dynamically map the strings to numbers
    unique_list = String[]
    for v in arr
        if v in unique_list
            continue
        else
            push!(unique_list, v)
        end
    end
    # println(unique_list)
    cleaned_list = Array{Int64, 1}(undef, length(arr))
    count = 1
    for i in unique_list
        for j in 1:length(arr)
            if arr[j] == i
                cleaned_list[j] = count
            end
        end
        count += 1
    end
    return cleaned_list

end

cleaned_school = map_to_int(school_vector)
cleaned_sex = map_to_int(sex_vector)
cleaned_address = map_to_int(address_vector)
cleaned_famsize = map_to_int(famsize_vector)

cleaned_pstatus = map_to_int(pstatus_vector)
cleaned_mjob = map_to_int(mjob_vector)
cleaned_fjob = map_to_int(fjob_vector)
cleaned_reason = map_to_int(reason_vector)

cleaned_guardian = map_to_int(guardian_vector)
cleaned_schoolsup = map_to_int(schoolsup_vector)
cleaned_famsup = map_to_int(famsup_vector)
cleaned_paid = map_to_int(paid_vector)

cleaned_activities = map_to_int(activities_vector)
cleaned_nursery = map_to_int(nursery_vector)
cleaned_higher = map_to_int(higher_vector)
cleaned_internet = map_to_int(internet_vector)

cleaned_romantic = map_to_int(romantic_vector)

# 2. Extract outcome and features
# 2.1 Create outcome vector
y = Array{Int64, 1}(undef, size(m)[1])
for i in 1:size(m)[1] # rows
    temp_total = 0
    for j in 31:size(m)[2] # From G1 to G3
        temp_total += m[i,j]
    end
    # Find average of grade and set value in outcome 1 if average is > 10 else 0
    if (temp_total/3) >= 10
        global y[i] = 1
    else
        global y[i] = 0
    end
end

println(y)

# 2.2 Update the changes to the matrix to the numerical equivalents
# TODO: Create vectors for the features then concatenate them. Below not functioning as expected

for i in 1:size(m)[1]
    for j in 1:size(m)[2]
        if j == 1
            m[i,j] = cleaned_school[i]
        elseif j == 2
            m[i,j] = cleaned_sex[i]
        elseif j == 4
            m[i,j] = cleaned_address[i]
        elseif j == 5
            m[i,j] = cleaned_famsize[i]
        elseif j == 6
            m[i,j] = cleaned_pstatus[i]
        elseif j == 9
            m[i,j] = cleaned_mjob[i]
        elseif j == 10
            m[i,j] = cleaned_fjob[i]
        elseif j == 11
            m[i,j] = cleaned_reason[i]
        elseif j == 12
            m[i,j] = cleaned_guardian[i]
        elseif j == 16
            m[i,j] = cleaned_schoolsup[i]
        elseif j == 17
            m[i,j] = cleaned_famsup[i]
        elseif j == 18
            m[i,j] = cleaned_paid[i]
        elseif j == 19
            m[i,j] = cleaned_activities[i]
        elseif j == 20
            m[i,j] = cleaned_nursery[i]
        elseif j == 21
            m[i,j] = cleaned_higher[i]
        elseif j == 22
            m[i,j] = cleaned_internet[i]
        elseif j == 23
            m[i,j] = cleaned_romantic[i]
        end
    end
end

# Remove G1, G2 and G3 from matrix by writing all except unwanted. Note: deleteat! won't work with 2 dims
x = Matrix{Float64}(undef, size(m)[1], size(m)[2]-3)

for i in 1:size(m)[1]
    for j in 1:size(m)[2]-3
        # Merge the outcome value as the last index
        if j == size(m)[2]-3
            x[i,j] = y[i]
            continue
        end
        x[i,j] = m[i,j]
    end
end

# Standardize x
m_fit = fit(ZScoreTransform, x, dims=2)
x = StatsBase.transform(m_fit, x)

# Split into testing and training
TEST_PERCENT = 0.8
# Calculate number of rows to use as test sample
testing_row_length = trunc(Int64, size(x)[1] * TEST_PERCENT)
training_x = x[1:testing_row_length-1, :]
testing_x = x[testing_row_length: size(x)[1], :]

training_y = y[1:testing_row_length-1, :]
testing_y = y[testing_row_length: size(y)[1], :]


# Concatenate a vector of 1 to feature matrix (training_x) to represent bias
training_x = hcat(training_x, ones(Int64, size(training_x)[1]))
testing_x = hcat(testing_x, ones(Int64, size(testing_x)[1]))

# hypothesis becomes h(X) = X × Θ (a matrix multiplication).
# hθ(x) = g((θT x))
function hypothesis(v_theta, X)
    z = transpose(v_theta) * X
    return 1/(1+exp(-z))
end
# t = zeros(size(training_x)[2])
# hypothesis(t,training_x[1, :])

function sum_and_square_theta(arr)
    # Exclude first element of theta
#     return sum(arr[2:size(arr)[1]]) ^ 2
    a = sum(arr) - arr[1]
    return a^2

end

function cost_function(X, Y, λ, theta)
    m = size(X)[1]
#     nfeatures = size(X)[1] - 1
#     theta = zeros(size(X)[2])
    cost = 0
    gradient = 0
    for i in 1:m
        x = X[i,:]
        y = Y[i]
        # cross entropy
        cost += (1/m)*(-y*log(hypothesis(theta, x)) - ((1-y) * log(1-hypothesis(theta, x))))
        cost += (λ/2m) * sum_and_square_theta(theta)
        gradient = ((1/m)*x) * (hypothesis(theta, x) - y) + (λ/m) * theta
#         println("Hypothesis: ",hypothesis(theta, x), ", Actual: ",y)
        # old
#         first_part = y * log(hypothesis(theta,x)) - (1-y) * log(1-hypothesis(theta, x))
#         second_part = (λ/2m) * sum_and_square_theta(theta)
#         cost += (1/m)*(first_part + second_part)
        # Update parameters for next iteration
        
#         grad = ((1/m)*x) * (hypothesis(theta, x) - y) + (λ/m) * theta
#         theta = theta - α * grad
    end
    
    return cost, gradient

    #
end


function gradient_descent(X, Y, theta, α, num_iterations, λ) # α -> learning rate
    tcost = 0
    m = size(X)[1]
    for i in 1:num_iterations
        cost, grad = cost_function(X, Y, λ, theta)
        theta = theta - (α*grad)
        tcost += cost
    end
    return theta, (tcost/num_iterations)
end

predicate_theta, cost = gradient_descent(training_x, training_y, zeros(size(training_x)[2]), 0.2, 200, 0.2)
println("Average cost:", cost)
for i in 1: 10
    pred = hypothesis(predicate_theta, testing_x[i, :])
    println("Predicted: ",pred, ", Actual: ",testing_y[i])
end

