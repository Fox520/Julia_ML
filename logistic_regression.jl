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
outcome_vector = Array{Float64, 1}(undef, size(m)[1])
for i in 1:size(m)[1] # rows
    temp_total = 0
    for j in 31:size(m)[2] # From G1 to G3
        temp_total += m[i,j]
    end
    # Find average of grade and set value in outcome 1 if average is > 10 else 0
    if (temp_total/3) > 10
        global outcome_vector[i] = 1 #1.0 conversions to integer aren't working as expected
    else
        global outcome_vector[i] = 0 #0.0
    end
end

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

# Remove G1, G2 and G3 from matrix by writing all except unwanted
new_matrix = Matrix{Int64}(undef, size(m)[1], size(m)[2]-2)
for i in 1:size(m)[1]
    for j in 1:size(m)[2]-2
        # Merge the outcome value as the last index
        if j == size(m)[2]-2
            new_matrix[i,j] = outcome_vector[i]
            continue
        end
        new_matrix[i,j] = m[i,j]
    end
end

# Standadize
# To avoid InexactError: Int64(Int64, -0.3780405275933236) convert matrix to float type
new_matrix = convert(Array{Float64, 2}, new_matrix)
m_fit = fit(ZScoreTransform, new_matrix, dims=2)

matrix_standardized = StatsBase.transform(m_fit, new_matrix)

# Split into testing and training
TEST_PERCENT = 0.8
# Calculate number of rows to use as test sample
testing_row_length = trunc(Int64, size(matrix_standardized)[1] * TEST_PERCENT)
testing_matrix = matrix_standardized[1:testing_row_length]
training_matrix = matrix_standardized[testing_row_length: size(matrix_standardized)[1]]

