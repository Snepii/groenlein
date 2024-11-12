---
--- written by chatgpt
--- 

local io = require("io")
local os = require("os")

-- Correct URL of the published Google Sheet CSV
local url = "https://docs.google.com/spreadsheets/d/e/2PACX-1vQ3Db_BMXtp-qgt4xEBic50RhJC_wnylI2Tw6ujuoRfdwM2OC8ZxE9zcRplwMtpeQMaNZbVFNbjtuTe/pub?output=csv"

-- Function to fetch CSV data using curl
local function fetchCSVData()
    -- Execute the curl command to fetch the CSV and store it in a temporary file
    local command = string.format('curl -L "%s" -o temp.csv', url)
    local result = os.execute(command)
    
    if result then
        -- Read the downloaded CSV from the temporary file
        local file = io.open("temp.csv", "r")
        if file then
            local data = file:read("*all")  -- Read all contents of the CSV file
            file:close()
            return data
        else
            print("Failed to open the downloaded CSV file.")
            return nil
        end
    else
        print("Failed to fetch CSV data using curl.")
        return nil
    end
end

-- Function to parse CSV data
local function parseCSV(data)
    local rows = {}
    
    for line in data:gmatch("[^\r\n]+") do
        local row = {}
        
        for cell in line:gmatch('([^,]+)') do
            table.insert(row, cell)
        end
        
        table.insert(rows, row)
    end
    
    return rows
end

-- Function to update README.md
local function updateReadme(data)
    local file = io.open("README.md", "a")  -- Open README.md in append mode

    if file then
        file:write("\n")
        
        for _, row in ipairs(data) do
            if _ > 1 then
                file:write("- " .. table.concat(row, ", ") .. "\n")  -- Write each row as a list item
            end
        end
        
        file:close()
        print("README.md updated successfully!")
    else
        print("Failed to open README.md.")
    end
end

local updateScheduleFile = "updateschedule"

local function readUpdateSchedule()
    local file = io.open(updateScheduleFile, "r")
    local max = 80
    if file then
        local number = tonumber(file:read("*all"))
        file:close()

        if number <= 0 then return max end

        return number
    else
        return max
    end
end

-- Function to save the updated number back to the update schedule file
local function writeUpdateSchedule(number)
    local file = io.open(updateScheduleFile, "w")
    if file then
        file:write(number)
        file:close()
    else
        print("Failed to open 'updateschedule' file for writing.")
    end
end



function UpdateReadme()
    local currentSchedule = readUpdateSchedule()
    if currentSchedule == nil then
        error("updateview:UpdateReadme:currentSchedule is nil",2)
    end
    currentSchedule = currentSchedule - 1  -- Decrement the number
    print("update schedule: " .. currentSchedule .. " starts left")

    if currentSchedule == 0 then
        -- If the number reaches 0, update the README and reset the schedule
        
        local csvData = fetchCSVData()
        if csvData then
            local parsedData = parseCSV(csvData)
            updateReadme(parsedData)
        end
    end
    writeUpdateSchedule(currentSchedule)
end

UpdateReadme()
