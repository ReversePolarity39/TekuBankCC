--Bank server program--
--Must be startup program--
--Must be a directory called saves on the computer--
print("Startup script is running.")
term.clear()
rednet.open("top")
if os.loadAPI("bankAPI.lua") then
    print("Successfully loaded bankAPI.")
else
    print("Failed to load bankAPI.")
    return
end

term.setCursorPos(1, 1)

-- Open the control tab
shell.openTab("control.lua")

-- Open the account management tab
shell.openTab("accountManagement.lua")

while true do
    local ret, msg, pro = rednet.receive("banking")
    if not msg then
        print("Received a nil message.")
    end
    print("Received a message: ", table.concat(msg, " & "))
    -- make log file thing
    print(" ")
    printError(os.date())
    --write date and time at start of each log
    for k, v in pairs(msg) do
        write(v)
        write(" & ")
        --write v to file
    end
    if msg[1] == "bal" then
        local succ, resp = bankAPI.balance(msg[2], msg[3], msg[4])
        local msgR = {"balR", succ, resp}
        rednet.send(ret, msgR, "banking")
    elseif msg[1] == "dep" then
        local succ, resp = bankAPI.deposit(msg[2], msg[3], msg[4], msg[5])
        local msgR = {"depR", succ, resp}
        rednet.send(ret, msgR, "banking")
    elseif msg[1] == "wit" then
        local succ, resp = bankAPI.withdraw(msg[2], msg[3], msg[4], msg[5])
        local msgR = {"witR", succ, resp}
        rednet.send(ret, msgR, "banking")
    elseif msg[1] == "tra" then
        local succ, resp = bankAPI.transfer(msg[2], msg[3], msg[4], msg[5], msg[6])
        local msgR = {"traR", succ, resp}
        rednet.send(ret, msgR, "banking")
    -- Add business account handling
    elseif msg[1] == "bus" then
        local succ, resp = bankAPI.createBusinessAccount(msg[2], msg[3], msg[4])
        local msgR = {"busR", succ, resp}
        rednet.send(ret, msgR, "banking")
    -- Add PoS handling
    elseif msg[1] == "pos" then
        local succ, resp = bankAPI.handlePoS(msg[2], msg[3], msg[4], msg[5])
        local msgR = {"posR", succ, resp}
        rednet.send(ret, msgR, "banking")
    elseif msg[1] == "pair" then
        print("Received pair request for account: ", msg[2], " with code: ", msg[3])
        local succ,resp = bankAPI.pairDevice(msg[2], msg[3])
        local msgR = {"pairR", succ, resp}
        if succ then
            print("Pairing successful: ", resp)
        else
            print("Pairing failed: ", resp)
        end
        rednet.send(ret, msgR, "banking")
    elseif msg[1] == "create_transit_account" then
        local transitName = msg[2]
        local diskID = msg[3]
        local status, resp = bankAPI.createTransitAccount(transitName, diskID)
        local msgR = {"create_transit_accountR", status, resp}
        rednet.send(ret, msgR, "banking")
        print("Transit account operation: ", resp)
    elseif msg[1] == "list_transit_accounts" then
        local accounts = bankAPI.listTransitAccounts()
        local msgR = {"list_transit_accountsR", accounts}
        rednet.send(ret, msgR, "banking")
    elseif msg[1] == "check_transit_balance" then
        local transitName = msg[2]
        local diskID = msg[3]
        local status, balance = bankAPI.checkTransitBalance(transitName, diskID)
        local msgR = {"check_transit_balanceR", status, balance}
        rednet.send(ret, msgR, "banking")
    elseif msg[1] == "associate_disk" then
        local transitName = msg[2]
        local diskID = msg[3]
        associateDiskWithTransitAccount(transitName, diskID)
        local msgR = {"associate_diskR", status, resp}
        rednet.send(ret, msgR, "banking")
        print("Disk association operation: ", resp)
    if messageType == "validateAccountRequest" then
        local isValid = validateAccount(message[2])
        rednet.send(senderID, { "validateAccountResponse", isValid }, "validateAccountResponse")
    end
        
    elseif msg[1] == "ticket_sale" then
    -- First, validate the transaction by checking the account and deducting the ticket price
    local succ, resp = bankAPI.withdraw(msg[2], msg[3], msg[4], msg[5])
    if succ then
        -- Transfer the deducted amount to the business account with ID 0
        local transfer_succ, transfer_resp = bankAPI.transfer(msg[2], "0", msg[3], msg[4], msg[5])
        local msgR = {"ticket_saleR", transfer_succ, transfer_resp}
        rednet.send(ret, msgR, "banking")
        if transfer_succ then
            print("Ticket sale successful: ", transfer_resp)
        else
            print("Ticket sale failed: ", transfer_resp)
        end
    else
        local msgR = {"ticket_saleR", succ, resp}
        rednet.send(ret, msgR, "banking")
        print("Ticket sale failed: ", resp)
    end
else
    print("Unknown message type: ", msg[1])
end
end

function createTransitAccount()
    -- Generate a new transit account ID
    local transitAccID = "TRANSIT_" .. math.random(10000, 99999)
    
    -- Generate a new PIN (or you can set it manually)
    local transitPin = math.random(1000, 9999)
    
    -- Initialize the account with a balance, for example, $1000
    -- Assuming you have an accounts table in bankAPI
    bankAPI.createAccount(transitAccID, transitPin, 1000)
    
    print("Transit Account Created!")
    print("Account ID: " .. transitAccID)
    print("PIN: " .. transitPin)
    
    return transitAccID, transitPin
end