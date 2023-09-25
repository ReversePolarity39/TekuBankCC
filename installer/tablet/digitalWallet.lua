-- DigitalWalletApp.lua

function atmLogin()
    local code = math.random(100000, 999999)
    print("Your ATM login code is: " .. code)
    
    bankAPI.sendCode(code)
end

-- Menu
print("1. ATM Login")
local choice = read()
if choice == "1" then
    atmLogin()
end
