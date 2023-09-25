-- Initialize rednet and find a server to pair with.
rednet.open("back")  -- Replace "right" with the actual side your modem is on.
local serverId = rednet.lookup("bankServer")

-- Ask the user for an account number.
print("Please enter your account number to pair this tablet:")
local accID = read()

-- Send the account number to the server for validation.
rednet.send(15, accID, "pairingChannel")

-- Wait for a response from the server.
local senderId, message = rednet.receive("pairingChannel")

if message == "Pairing Successful" then
    print("Pairing successful.")
    
    -- Create the userData folder and store the account number.
    if not fs.exists("./userData") then
        fs.makeDir("./userData")
    end
    
    local file = fs.open("./userData/accID", "w")
    file.write(accID)
    file.close()
else
    print("Pairing failed: " .. message)
end



local function checkForUpdates()
    -- Your update checking code here
end

local function mainMenu()
    -- Your main menu code here
end

checkForUpdates()

while true do
    print("Enter '1' for Main Menu or '8237662' for Pairing Mode:")
    local choice = read()

    if choice == "1" then
        mainMenu()
    elseif choice == "8237662" then
        enterPairingMode()
    else
        print("Invalid choice. Try again.")
    end
end
