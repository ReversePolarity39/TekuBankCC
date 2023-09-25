-- accountManagement.lua
-- This tab allows you to manage accounts and create new cards

os.loadAPI("bankAPI.lua")

local duplicateCards = {} -- Table to store duplicate cards

function generatePairingCode()
    print("Is bankAPI available? ", bankAPI ~= nil)
    print("Is generatePairingCode available? ", bankAPI.generatePairingCode ~= nil)

    print("Please insert the card of the account for pairing.")
    read()  -- Wait for the user to press Enter after inserting the disk

    print("Is disk API available? ", disk ~= nil)

    local diskSide = "bottom"  -- Replace with the actual side where the disk drive is
    print("Checking disk on side: " .. diskSide)

    if disk.hasData(diskSide) then  -- Check if a disk is inserted
        local accountID = disk.getID(diskSide)
        print("Read disk ID: " .. tostring(accountID))

        if accountID then
            local success, result1, result2 = pcall(function() return bankAPI.generatePairingCode(accountID) end)
            if success then
                print("Generated pairing code: " .. tostring(result2))
                print("This code will be visible for 15 seconds.")
                sleep(15)
            else
                print("Failed to generate pairing code: " .. tostring(result1))
            end
        else
            print("No disk detected.")
        end
    else
        print("No disk in drive.")
    end
end

local function createTransitAccount()
    rednet.send(11, {"create_transit_account"}, "banking")
    local id, message = rednet.receive("banking", 10) -- Wait up to 10 seconds for a response
    
    if message and message[1] == "create_transit_accountR" and message[2] then
        print("Successfully created Transit Account!")
        print("Account ID: " .. message[3])
        print("PIN: " .. message[4])
    else
        print("Failed to create Transit Account.")
    end
end


while true do
    term.clear()
    term.setCursorPos(1, 1)
    print("Account Management Menu")
    print("1. Create Personal Account")
    print("2. Create Business Account")
    print("3. View/Edit Account")
    print("4. Create Duplicate Card")
	print("5. Generate Pairing Code")
    print("6. Create Transit Account")
    print("7. Exit")
    local choice = read()

    local drive = "bottom"  -- Assuming the floppy drive is at the bottom

    if choice == "1" or choice == "2" then
        print("Please insert a floppy disk to create the account.")
        while not disk.isPresent(drive) do
            sleep(0.1)
        end
        local id = disk.getID(drive)
        local accountType = choice == "1" and "Personal" or "Business"
        local success, response = bankAPI.create(id, "server", "unset")
        if success then
            disk.setLabel(drive, response .. "'s Teku Credit Union Debit Card")
            print(accountType .. " account created successfully. Account ID: " .. response)
        else
            print("Failed to create account. Reason: " .. response)
        end
    elseif choice == "3" then
        print("Please insert the account card.")
        while not disk.isPresent(drive) do
            sleep(0.1)
        end
        local id = disk.getID(drive)
        print("Is the account holder with you? (y/n)")
        if read() == "y" then
            print("Account holder username: " .. disk.getLabel(drive))
            print("Please enter the account holder's PIN:")
            local pin = read()
            local success, balance = bankAPI.balance(id, "server", pin)
            --allow the employee to edit the balance
            if success then
                print("Current Balance: " .. balance)
                print("Would you like to edit the balance? (y/n)")
                if read() == "y" then
                    print("Enter new balance:")
                    local newBalance = tonumber(read())
                    local success, message = bankAPI.editBalance(id, newBalance, pin)
                    if success then
                        print("Balance edited successfully.")
                    else
                        print("Failed to edit balance: " .. message)
                    end
                end
            else
                print("Failed to check balance: " .. balance)
            end
        else
            print("Operation cancelled.")
        end
    elseif choice == "4" then
        print("Please insert the original card.")
        while not disk.isPresent(drive) do
            sleep(0.1)
        end
        local originalID = disk.getID(drive)
        disk.eject(drive)
        print("Please insert a new card to duplicate.")
        while not disk.isPresent(drive) do
            sleep(0.1)
        end
        local newID = disk.getID(drive)
        -- Assuming you have a function to duplicate the card
        bankAPI.duplicateCard(originalID, newID, "server")
        print("Card duplicated successfully.")
    elseif choice == "5" then
        generatePairingCode()
    elseif choice == "6" then
        createTransitAccount()
    elseif choice == "7" then
        print("Exiting...")
        break
    else
        print("Invalid choice. Please try again.")
    end
    sleep(2)
end