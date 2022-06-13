local filename = ...

local oncommand = require "filter_oncommand"
local clientcallclub = require "filter_clientcallclub"
local clientcallroom = require "filter_clientcallroom"
local clientcallbsc = require "filter_clientcallbsc"
local clientcalljfs = require "filter_clientcalljfs"

local file_ret = io.open("ok.out", "w+")
local file_err = io.open("err.out", "w+")

local function write(ret, err)
    if file_ret then 
        for _, temptab in pairs(ret) do 
            local funcname = temptab[1]
            local count = temptab[2]
            file_ret:write(string.format("%-50s", funcname), '\t', count, '\n') -- 
        end
    end
    
    if file_err then 
        for _, error_line in pairs(err) do 
            file_err:write(error_line, '\n')
        end
    end
end

local ret_all, err_all = {}, {}

local ret, err = oncommand.find(filename)
ret_all[#ret_all+1] = ret
err_all[#err_all+1] = err
ret, err = clientcallclub.find(filename)
ret_all[#ret_all+1] = ret
err_all[#err_all+1] = err
ret, err = clientcallroom.find(filename)
ret_all[#ret_all+1] = ret
err_all[#err_all+1] = err
ret, err = clientcallbsc.find(filename)
ret_all[#ret_all+1] = ret
err_all[#err_all+1] = err
ret, err = clientcalljfs.find(filename)
ret_all[#ret_all+1] = ret
err_all[#err_all+1] = err

--...

-- deduplication...
local function deduplication(tab)
    local ret = {}
    for _, _ret in pairs(tab) do 
        for command, count in pairs(_ret) do 
            -- print(type(command))
            if type(command) == "string" then 
                ret[command] = (ret[command] or 0) + count
            else
                ret[command] = ret[command] or count
            end
        end
    end

    return ret
end

local ret = deduplication(ret_all)
local err = deduplication(err_all)

-- sort
local ret_final = {}
for command, count in pairs(ret) do 
    ret_final[#ret_final+1] = {command, count}
end
table.sort(ret_final, function(a, b)
    return a[1] < b[1]
end)

write(ret_final, err)
