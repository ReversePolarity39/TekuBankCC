-- mainMenu.lua
-- Main menu for the tablet with a built-in wireless modem on the back

local modem = peripheral.wrap("back")

while true do
    term.clear()
    term.setCursorPos(1, 1)
    print("Main Menu")
    print("1. Digital Wallet")
    print("2. Railway Tickets")
    print("3. Notifications")
    print("4. Exit")
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
    elseif choice == "4" then
        print("Exiting...")
        break
    else
        print("Invalid choice. Please try again.")
    end
    sleep(2)
end