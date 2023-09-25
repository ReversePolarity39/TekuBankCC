term.clear()
term.setCursorPos(1, 1)

local ATM = "server"
local drive = "bottom"
local transitAccounts = {}  -- New variable to store transit accounts


while true do
    term.setTextColor(colors.yellow)
    print("For balance type 1, for deposit type 2")
    print("For withdraw type 3, for transfer type 4")
    print("For add account type 5, for add transit account type 6")
    term.setTextColor(1)
    local txt = read()
    if txt == "1" or txt == "2" or txt == "3" or txt == "4" or txt == "5" or txt == "6" then
        print("Please enter the card")
        while disk.isPresent(drive) == false do
            sleep(0.1)
        end
        local id = disk.getID(drive)
        disk.eject(drive)
        if id == nil then
            printError("Must be valid card")
        else
            print("Please enter 5 number pin")
            local pin = read("*")
            if (tonumber(pin)) then
                if string.len(pin) ~= 5 then
                    printError("Must be 5 numbers")
                else
                    if txt == "1" then
                        print(bankAPI.balance(id, ATM, pin))
                    elseif txt == "2" then
                        print("Please enter deposit amount")
                        local amount = read()
                        if (tonumber(amount)) then
                            amount = tonumber(amount)
                            print(bankAPI.deposit(id, amount, ATM, pin))
                        else
                            printError("Must be a number")
                        end
                    elseif txt == "3" then
                        print("Please enter withdraw amount")
                        local amount = read()
                        if (tonumber(amount)) then
                            amount = tonumber(amount)
                            print(bankAPI.withdraw(id, amount, ATM, pin))
                        else
                            printError("Must be a number")
                        end
                    elseif txt == "4" then
                        print("Please enter the amount")
                        local amount = read()
                        if (tonumber(amount)) then
                            print("Please enter id to transfer to")
                            local id2 = read()
                            if (tonumber(id2)) then
                                id2 = tonumber(id2)
                                print(bankAPI.transfer(id, id2, amount, ATM, pin))
                            else
                                printError("Must be a valid id")
                            end
                            
                        else
                            printError("Must be a number")
                        end
                    elseif txt == "5" then
                        print(bankAPI.create(id, ATM, pin))
                    elseif txt == "6" then  -- New condition for transit account
                            print("Please enter the Transit Company (Bradley Railway Company or Mustard Transit Co)")
                            local company = read()
                            if company == "Bradley Railway Company" or company == "Mustard Transit Co" then
                                print(bankAPI.create(id, ATM, pin))
                                transitAccounts[id] = company  -- Associate the account with the transit company
                            else
                                printError("Invalid Transit Company")
                            end
                    end
                end
            else
                printError("Must be a number")
            end
        end
    else
        printError("Must be a number from the list")
    end
end
