--[[
    记录运行时间rem方法
    只有key1时为记录，有key2时会打印对应记录间的差值，如：
    rem("a") --1
    rem("b") --2
    rem("c") --4
    print rem("a","b") =1
    print rem("b","c") =2
    print rem("a","c") =3
]]
rem = function(key1, key2)
    if (type(key1) ~= "string") then
        return
    end
    if (key2 ~= nil and type(key2) ~= "string") then
        return
    end
    if (remStack == nil) then
        remStack = {}
    end
    remStack[key1] = os.clock()
    if (key2 ~= nil) then
        remStack[key2] = os.clock()
        print("[rem " .. key1 .. "->" .. key2 .. "]:" .. remStack[key2] - remStack[key1])
    end
end

--打印栈
print_stack = function(...)
    local out = {"[TRACE]"}
    local n = select("#", ...)
    for i = 1, n, 1 do
        local v = select(i, ...)
        out[#out + 1] = tostring(v)
    end
    out[#out + 1] = "\n"
    out[#out + 1] = debug.traceback("", 2)
    print(table.concat(out, " "))
    -- print(debug.traceback("Stack trace"))
end

--打印utf8->ansi编码,此方法可以打印出中文
print_mb = function(str)
    console.write(str)
end

--错误调试
print_err = function(val)
    print("---------h-lua-err---------")
    if (type(val) == "table") then
        print_mbr(val)
    else
        print_mb(val)
    end
    print_stack()
    print("---------------------------")
end

--打印对象table
print_r = function(t, printMethod, showDetail)
    local print_r_cache = {}
    printMethod = printMethod or print
    if (showDetail == nil) then
        showDetail = true
    end
    local function sub_print_r(tt, indent)
        if (print_r_cache[tostring(tt)]) then
            printMethod(indent .. "*" .. tostring(tt))
        else
            print_r_cache[tostring(tt)] = true
            if (type(tt) == "table") then
                for pos, val in pairs(tt) do
                    if (type(pos) == "userdata") then
                        pos = "userdata"
                    end
                    if (type(val) == "table") then
                        print(indent .. "[" .. pos .. "](" .. table.len(val) .. ") => " .. tostring(tt) .. " {")
                        sub_print_r(val, indent .. string.rep(" ", string.len(pos) + 8))
                        print(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
                    elseif (showDetail == true) then
                        if (type(val) == "string") then
                            printMethod(indent .. "[" .. pos .. '] => "' .. val .. '"')
                        else
                            print(indent .. "[" .. pos .. "] => " .. tostring(val))
                        end
                    end
                end
            else
                printMethod(indent .. tostring(tt))
            end
        end
    end
    if (type(t) == "table") then
        print(tostring(t) .. "(" .. table.len(t) .. ") {")
        sub_print_r(t, "  ")
        print("}")
    else
        sub_print_r(t, "  ")
    end
    print()
end

--打印对象table,此方法可以打印出中文
print_mbr = function(t)
    print_r(t, print_mb, true)
end
