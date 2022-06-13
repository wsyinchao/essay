local filename = ...

local oncommand = require "filter_oncommand"
local clientcallclub = require "filter_clientcallclub"
local clientcallroom = require "filter_clientcallroom"

local file_ret = io.open("ok.out", "w+")
local file_err = io.open("err.out", "w+")

local function write(ret, err)
    if file_ret then 
        for funcname, count in pairs(ret) do 
            file_ret:write(string.format("%-20s", funcname), '\t', count, '\n') -- 
        end
    end
    
    if file_err then 
        for _, error_line in pairs(err) do 
            file_err:write(error_line, '\n')
        end
    end
end

local ret, err = oncommand.find(filename)
write(ret, err)
-- collectgarbage("collect")
ret, err = clientcallclub.find(filename)
write(ret, err)
-- collectgarbage("collect")
ret, err = clientcallroom.find(filename)
write(ret, err)
-- collectgarbage("collect")
