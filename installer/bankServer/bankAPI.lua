-- Must be called bankAPI.lua
rednet.open("top")

-- Existing balance function
function balance(acc, atm, pin)
    file = fs.open("saves/".. acc, "r")
    if file ~= nil then
        local fileData = {}
        local line = file.readLine()
        repeat
            table.insert(fileData, line)
            line = file.readLine()
        until line == nil
        file.close()
        if fileData[2] == pin then
            return true, fileData[1]
        else
            return false, "Incorrect pin"
        end
    end
    return false, "Not real id"
end

-- Existing deposit function
function deposit(acc, amm, atm, pin)
    file = fs.open("saves/".. acc, "r")
    if file ~= nil then
        local fileData = {}
        local line = file.readLine()
        repeat
            table.insert(fileData, line)
            line = file.readLine()
        until line == nil
        file.close()
        if fileData[2] == pin then
            fs.delete("saves/".. acc)
            file = fs.open("saves/".. acc, "a")
            file.writeLine(tonumber(fileData[1]) + amm)
            file.writeLine(fileData[2])
            file.close()
            return true, amm
        else
            return false, "Incorrect pin"
        end
    end
    return false, "Not a real id"
end

-- Existing withdraw function
function withdraw(acc, amm, atm, pin)
    file = fs.open("saves/".. acc, "r")
    if file ~= nil then
        local fileData = {}
        local line = file.readLine()
        repeat
            table.insert(fileData, line)
            line = file.readLine()
        until line == nil
        file.close()
        if (tonumber(fileData[1]) - amm) >= 0 then
            if fileData[2] == pin then
                fs.delete("saves/".. acc)
                file = fs.open("saves/".. acc, "a")
                file.writeLine(tonumber(fileData[1]) - amm)
                file.writeLine(fileData[2])
                file.close()
                return true, amm
            else
                return false, "Incorrect pin"
            end
        else
            return false, "Balance too low"
        end
    end
    return false, "Not a real id"
end

-- Existing transfer function
function transfer(acc, acc2, amm, atm, pin)
    -- ... (Your existing code here)
end

-- Existing create function
function create(acc, atm, pin)
    file = fs.open("saves/".. acc, "r")
    if file == nil then
        file = fs.open("saves/".. acc, "a")
        file.writeLine(0)
        file.writeLine(pin)
        file.close()
        return true, acc
    else
        file.close()
        return false, "Already an account"
    end
end

-- New function to create business accounts
function createBusinessAccount(businessName, atm, pin)
    local file = fs.open("saves/business_".. businessName, "r")
    if file == nil then
        file = fs.open("saves/business_".. businessName, "a")
        file.writeLine(0)  -- Initial balance
        file.writeLine(pin)  -- PIN
        file.close()
        return true, businessName
    else
        file.close()
        return false, "Business account already exists"
    end
end

-- New function for PoS transactions
function posTransaction(businessName, amount, pin)
    local file = fs.open("saves/business_".. businessName, "r")
    if file ~= nil then
        local fileData = {}
        local line = file.readLine()
        repeat
            table.insert(fileData, line)
            line = file.readLine()
        until line == nil
        file.close()
        
        if fileData[2] == pin then
            fs.delete("saves/business_".. businessName)
            file = fs.open("saves/business_".. businessName, "a")
            file.writeLine(tonumber(fileData[1]) + amount)
            file.writeLine(fileData[2])
            file.close()
            return true, amount
        else
            return false, "Incorrect PIN"
        end
    else
        return false, "Invalid business account"
    end
end

function updateBalance(acc, newBalance, atm, pin)
    local file = fs.open("saves/".. acc, "r")
    if file ~= nil then
        local fileData = {}
        local line = file.readLine()
        repeat
            table.insert(fileData, line)
            line = file.readLine()
        until line == nil
        file.close()
        if fileData[2] == pin then
            fs.delete("saves/".. acc)
            file = fs.open("saves/".. acc, "a")
            file.writeLine(newBalance)
            file.writeLine(fileData[2])
            file.close()
            return true, "Balance updated successfully"
        else
            return false, "Incorrect PIN"
        end
    else
        return false, "Account does not exist"
    end
end

function pairDevice(account, pairingCode)
    local file = fs.open("saves/".. account, "r")
    if file ~= nil then
        local fileData = {}
        local line = file.readLine()
        repeat
            table.insert(fileData, line)
            line = file.readLine()
        until line == nil
        file.close()
        if fileData[3] == pairingCode then
            return true, "Sucessfully paired"
        else
            return false, "Incorrect pairing code"
        end
    else
        return false, "Account does not exist"
    end
end

function generatePairingCode(accountID)
    -- Your logic to generate a pairing code for the given account ID
    local pairingCode = math.random(100000, 999999)  -- Generating a random 6-digit number as an example
    return true, pairingCode
end

function createTransitAccount()
    local file = fs.open("saves/transit_account", "r")
    if file == nil then
        file = fs.open("saves/transit_account", "a")
        file.writeLine(0)  -- Initial balance
        --generate a random 4 digit pin
        local transitPin = math.random(1000, 9999)
        file.writeLine(transitPin)
        file.close()
        return "Transit Account successfully created. PIN: " .. transitPin
    else
        file.close()
        return "Transit Account already exists"
    end
end

-- Function to get the list of available transit accounts
function listTransitAccounts()
    local list = fs.list("saves/")
    local transitAccounts = {}
    for _, fileName in ipairs(list) do
        if string.find(fileName, "transit_") then
            table.insert(transitAccounts, string.sub(fileName, 9))
        end
    end
    return transitAccounts
end

-- Function to check balance of a specific transit account with disk ID
function checkTransitBalance(transitName, diskID)
    local fileName = "saves/transit_" .. transitName
    local file = fs.open(fileName, "r")
    if file ~= nil then
        local balance = file.readLine()
        local pin = file.readLine()
        local authDiskID = file.readLine()
        file.close()
        if authDiskID == diskID then
            return true, balance
        else
            return false, "Unauthorized disk"
        end
    else
        return false, "Account does not exist"
    end
end

function associateDiskWithTransitAccount(transitName, diskID)
    local status, resp = bankAPI.associateDiskWithTransitAccount(transitName, diskID)
    if status then
        print("Disk successfully associated with Transit Account: ", resp)
    else
        print("Failed to associate Disk with Transit Account: ", resp)
    end
end

function loadTransitAccounts()
    local file = fs.open("./saves/transit_acc", "r")
    local data = file.readAll()
    file.close()
    -- Parse data and populate transitAccounts
end

function updateTransitAccounts(id, company)
    -- Add to transitAccounts table
    transitAccounts[id] = company
    -- Update the file
    local file = fs.open("./saves/transit_acc", "w")
    for id, company in pairs(transitAccounts) do
        file.writeLine(id .. ", " .. company)
    end
    file.close()
end

function handleTicketSale(company, amount) -- if the company == 1 then id is 15 if id == 2 then id is 16
    if company == 1 then
        local status, resp = bankAPI.posTransaction("Bradley Railway Company", amount, pin)
        if status then
            print("Ticket sale successfully processed: ", resp)
        else
            print("Failed to process ticket sale: ", resp)
        end
    bankAPI.deposit(id, amount, ATM, pin)  -- Assuming ATM and pin are accessible
end
