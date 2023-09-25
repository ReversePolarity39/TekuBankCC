--ATM version 0.0.6--
--Must be called api.lua--

rednet.open("modem_0")

server = 0
vers = "0.1.0"

--functions--
function clear(col, exit)
    --add bank logo--
    term.setBackgroundColor(col)
    term.setTextColor(colors.yellow)
    term.clear()
    term.setCursorPos(1, 1)
    term.write("Bank OS ".. vers)
    term.setCursorPos(1, 19)
    term.setTextColor(colors.lightGray)
    term.write("Teku Credit Union")
    term.setTextColor(colors.white)
    if (exit) then
        term.setBackgroundColor(colors.red)
        term.setCursorPos(49, 17)
        term.write("X")
        term.setBackgroundColor(colors.black)
    end
end

function balance(account, ATM, pin)
    local msg = {"bal", account, ATM, pin}
    rednet.send(server, msg, "banking")
    local send, mes, pro = rednet.receive("banking")
    if mes[1] == "balR" then
        return mes[2], mes[3]
    end
    return false, "oof"
end

function deposit(account, amount, ATM, pin)
    local msg = {"dep", account, amount, ATM, pin}
    rednet.send(server, msg, "banking")
    local send, mes, pro = rednet.receive("banking")
    if mes[1] == "depR" then
        return mes[2], mes[3]
    end
    return false, "oof"
end

function withdraw(account, amount, ATM, pin)
    local msg = {"wit", account, amount, ATM, pin}
    rednet.send(server, msg, "banking")
    local send, mes, pro = rednet.receive("banking")
    if mes[1] == "witR" then
        return mes[2], mes[3], amount
    end
    return false, "oof"
end

function transfer(account, account2, amount, ATM, pin)
    local msg = {"tra", account, account2, amount, ATM, pin}
    rednet.send(server, msg, "banking")
    local send, mes, pro = rednet.receive("banking")
    if mes[1] == "traR" then
        return mes[2], mes[3]
    end
    return false, "oof"
end
