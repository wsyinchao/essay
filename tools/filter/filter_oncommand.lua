--[[
    读取一个文件，摘取需要的信息
]]

local _M = {}

local repeat_dictinary = {}
local error_dictinary = {}

--- 是否含有指定的关键字
local function is_include_pattern(str, pattern)
    local ibegin, iend = string.find(str, pattern, 1, true)
    return ibegin and true or false
end

-- 读取很大的文件
-- todo...
function _M.find_(filename)
    local m = 1024
    local block = ''
    local file = io.open(filename, "r")
    if file then 
    else 
        print("open file failed...")
    end
end

function _M.find(filename)
    local key = "oncommand,"
    for line in io.lines(filename, "l") do 
        if is_include_pattern(line, key) then -- 
            local ibegin, iend = string.find(line, ",command=", 1, true)
            if not iend then 
                -- print("**********************找到" .. key .. "关键字, 却没有正确提取出命令的行***********************")
                error_dictinary[#error_dictinary+1] = line
                goto forend
            end

            local real_end_index = -1
            for i = iend + 1, string.len(line) do       -- 找到正确的索引
                if string.sub(line, i, i) == ',' then 
                    real_end_index = i
                    break
                end
            end
            assert(real_end_index ~= -1)

            local ret = string.sub(line, iend + 1, real_end_index - 1)
            repeat_dictinary[ret] = (repeat_dictinary[ret] or 0) + 1
        else
            -- print(line) -- 输出没有关键字的行，不错过每一条日志
        end
        ::forend::
    end

    return repeat_dictinary, error_dictinary
end

return _M
