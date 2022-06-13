--[[
    读取一个文件，摘取需要的信息
]]

-- local filename = ...
local _M = {}

local repeat_dictinary = {}
local error_dictinary = {}

--- 是否含有指定的关键字
local function is_include_pattern(str, pattern)
    local ibegin, iend = string.find(str, pattern, 1, true)
    return ibegin and true or false
end

function _M.find(filename)
    local key = "clientcallclub"
    for line in io.lines(filename, "l") do 
        if is_include_pattern(line, key) then -- 
            local ibegin, iend = string.find(line, ",parameters=", 1, true)
            if not iend then 
                -- print("**********************找到" .. key .. "关键字, 却没有正确提取出命令的行***********************")
                -- print(line)
                error_dictinary[#error_dictinary+1] = line
                goto forend
            end

            local ret = string.sub(line, iend + 1, - 1)
            local ret_func, error_msg = load("return " .. ret, "load a line", "t", {})
            if not ret_func then 
                -- print("******************************加载失败的行")
                -- print(error_msg)
                -- print(line)
                error_dictinary[#error_dictinary+1] = line
                goto forend
            else
                local ret_tb = ret_func()
                local ret = ret_tb[1]
                repeat_dictinary[ret] = (repeat_dictinary[ret] or 0) + 1
            end
        else
            -- print(line) -- 输出没有关键字的行，不错过每一条日志
        end
        ::forend::
    end

    return repeat_dictinary, error_dictinary
end

return _M
