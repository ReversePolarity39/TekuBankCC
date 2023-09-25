

local function isButtonPressed(x, y, buttonX1, buttonY1, buttonX2, buttonY2)
    print("x: " .. tostring(x), "y: " .. tostring(y), "buttonX1: " .. tostring(buttonX1), "buttonY1: " .. tostring(buttonY1), "buttonX2: " .. tostring(buttonX2), "buttonY2: " .. tostring(buttonY2))
    return x >= buttonX1 and x <= buttonX2 and y >= buttonY1 and y <= buttonY2
end


local function checkUserDataFolder()
    local exists = fs.exists("./userData")
    if not exists then
        term.clear()
        term.setCursorPos(1, 1)
        print("This Tablet Isn't Paired :c")
        -- Add a home button functionality here if needed
        return false
    end
    return true
end

local function mainMenu()
    if not checkUserDataFolder() then return end

    while true do
        local event, side, x, y = os.pullEvent()
        -- Boot screen
        local bootimg = paintutils.loadImage("bootScreen.nfp")
        paintutils.drawImage(bootimg, 1, 1)
        sleep(3)
        term.clear()

        -- Main menu
        term.setCursorPos(1, 1)
        print("TekuOS Main Menu")
        print("1. Digital Wallet")
        print("2. Railway Tickets")
        print("3. Notifications")
        local choice = read()

        if choice == "1" then
            -- Digital Wallet functionality
            -- Here you can call another Lua script that handles the digital wallet
            shell.run("digitalWallet.lua")
        elseif choice == "8237662" then
            shell.run("pairingMode.lua")
        elseif choice == "2" then
            -- Railway Tickets functionality
            -- Here you can call another Lua script that handles railway ticketing
            shell.run("railwayTickets.lua")
        elseif choice == "3" then
            -- Notifications functionality
            -- Here you can call another Lua script that handles notifications
            shell.run("notifications.lua")
        elseif choice == "9346387" then
            print("Terminating...")
            break
        else
            print("Invalid choice. Please try again.")
        end
        local id, message, protocol = rednet.receive("pinRequest")
        if protocol == "pinRequest" and message[1] == "getPin" then
            local accountID = message[2]
            local pin = -- code to get PIN for accountID
        rednet.send(id, { "pinResponse", pin }, "pinResponse")
        sleep(2)
    end
end
end

-- Disable termination
os.pullEvent = os.pullEventRaw

-- Run the main menu
mainMenu()