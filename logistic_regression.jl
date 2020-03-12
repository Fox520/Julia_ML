using CSV
using Statistics
using DataFrames

file_path = "student-mat.csv"
df = CSV.read(file_path)
m = convert(Matrix, df)

# 1. Clean the data
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
# println(cleaned_activities)
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

# 2.2 Extracting features whilst excluding G1 - G3
features = Matrix{Int64}(undef, size(m)[1], size(m)[2])
# TODO: Create vectors for the features then concatenate them. Below not functioning as expected
do_not_extract = Int64[1, 2, 4, 5, 6, 9, 10, 11, 12, 16, 17, 18, 19, 20, 21, 22, 23]
found_j = false
for i in 1:size(m)[1]
    for j in 1:size(m)[2]
        # ignore the defined already collected columns
        if j in do_not_extract
            global found_j = true
            continue
        end
        if found_j == true
            features[i,j-1] = m[i,j]
        else
            features[i,j] = m[i,j]
        end
    end
end

println(features)
        

# println(df[:, :sex])
# Make sense of data
# how many rows and the labels to show
# println(df[:, [:sex,:age]])
# Symbol[:school, :sex, :age, :address, :famsize, :Pstatus, :Medu, :Fedu, :Mjob, :Fjob, :reason, :guardian, :traveltime, :studytime, :failures, :schoolsup, :famsup, :paid, :activities, :nursery, :higher, :internet, :romantic, :famrel, :freetime, :goout, :Dalc, :Walc, :health, :absences, :G1, :G2, :G3]
# println(summary(df))
# println(size(df))

# Data cleaning

# Returns sex array with M mapped to 1 F to 0
# function clean_sex(cols) # note: cols is an array
#     # cols is array
#     temp = fill(0, size(cols))
#     for i in 1:length(cols)
#         if cols[i] == "M"
#             temp[i] = 1
#         end
#     end
#     return temp
# end

# function clean_guardian(cols) # note: cols is an array
#     # cols is array
#     temp = fill(0, size(cols))
#     for i in 1:length(cols)
#         if cols[i] == "father"
#             temp[i] = 1
#         elseif cols[i] == "mother"
#             temp[i] = 0
#         elseif cols[i] == "other"
#             temp[i] = -1
#         else
#             temp[i] = -2
#         end
#     end
#     return temp
# end

# # let's clean sex
# sex_df = select(df, :sex)
# mod_sex = aggregate(sex_df, clean_sex)
# # integrate sex cols
# without_sex = select(df, Not(:sex)) # drop column :sex from df
# a = convert(Matrix, mod_sex)
# println(length(a))
# println(a)
# temp_sex = fill(0, size(1, length(a)))
# println(temp_sex) # -> [0]
# for i in 1:length(temp_sex)
#     temp_sex[i] = a[i]
# end
# println(temp_sex) # -> [0]
# # ERROR: LoadError: DimensionMismatch("length of new column (1) must match the number of rows in data frame (395)")
# df = insertcols!(without_sex, 2, sex=temp_sex)

# # let's clean guardian
# # guardian_df = select(df, :guardian)
# # mod_guardian = aggregate(guardian_df, clean_guardian)
# # # integrate guardian cols
# # without_guardian = select(df, Not(:guardian))
# # df = insertcols!(without_guardian, 12, guardian=mod_guardian)
# # println(df[:, :sex])

# println(describe(df))
