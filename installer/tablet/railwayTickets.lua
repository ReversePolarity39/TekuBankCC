-- Load the bank API
os.loadAPI("bankAPI.lua")

-- Initialize Rednet
rednet.open("back")

local BANK_SERVER_ID = 11
-- Prices
local ticketPrice = 10

-- Add your validateRemoteAccount function here
function validateRemoteAccount(accountID)
    print("Sending validation request for account: " .. accountID)  -- Debug
    rednet.send(BANK_SERVER_ID, { "validateAccount", accountID }, "validateAccountRequest")
    local id, message = rednet.receive("validateAccountResponse", 5)
    if id == BANK_SERVER_ID and message and message[1] == "validateAccountResponse" then
        print("Received validation response: " .. tostring(message[2]))  -- Debug
        return message[2]
    else
        print("Failed to receive validation response.")  -- Debug
        return false
    end
end


while true do
    term.clear()
    term.setCursorPos(1, 1)
    
    if not fs.exists("./userData") then
        print("This Tablet Isn't Paired :c")
        print("Press Enter to go home")
        read()
        break
    else
        term.setCursorPos(1, 3)
        print("NFC is active.")
        
        -- Simulating gate detection. Replace 'true' with a function that checks for gates.
        if true then  -- Replace 'true' with a function that checks for gates.
            local accIDFile = fs.open("./userData/accID", "r")
            local accID = accIDFile.readLine()
            accIDFile.close()
            
            -- Validate the accounts here
            local userAccValid = validateRemoteAccount(accID)
            local transitAccValid = validateRemoteAccount("transitAccount")  -- Replace with actual transit account ID

            if userAccValid and transitAccValid then
                -- Perform the transaction
                local transactionSuccess, msg = bankAPI.performTransaction(accID, "transitAccount", ticketPrice)
    
                if transactionSuccess then
                    -- Send accID to the gate computer
                    rednet.send(gateComputerID, accID, "gateChannel")
                
                    local ticketFile = fs.open("./tickets/" .. os.time(), "w")
                    ticketFile.writeLine("Valid ticket")
                    ticketFile.close()
                
                    print("Payment Successful. Gate opening.")
                else
                    print("Payment Failed: " .. msg)
                end
            else
                print("Payment Failed: One or both accounts do not exist.")
            end
            
            print("Press Enter to continue...")
            read()
        end
        
        -- A sleep to slow down the loop.
        sleep(1)
    end
end
