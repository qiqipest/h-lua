hlightning = {
    type = {
        shan_dian_lian_zhu = "CLPB", -- 闪电效果 - 闪电链主
        shan_dian_lian_ci = "CLSB", -- 闪电效果 - 闪电链次
        ji_qu = "DRAB", -- 闪电效果 - 汲取
        sheng_ming_ji_qu = "DRAL", -- 闪电效果 - 生命汲取
        mo_fa_ji_qu = "DRAM", -- 闪电效果 - 魔法汲取
        si_wang_zhi_zhi = "AFOD", -- 闪电效果 - 死亡之指
        cha_zhuang_shan_dian = "FORK", -- 闪电效果 - 叉状闪电
        yi_liao_bo_zhu = "HWPB", -- 闪电效果 - 医疗波主
        yi_liao_bo_ci = "HWSB", -- 闪电效果 - 医疗波次
        shan_dian_gong_ji = "CHIM", -- 闪电效果 - 闪电攻击
        ma_fa_liao_kao = "LEAS", -- 闪电效果 - 魔法镣铐
        fa_li_ran_shao = "MBUR", -- 闪电效果 - 法力燃烧
        mo_li_zhi_yan = "MFPB", -- 闪电效果 - 魔力之焰
        ling_hun_suo_lian = "SPLK" -- 闪电效果 - 灵魂锁链
    }
}
--删除闪电
hlightning.del = function(lightning)
    cj.DestroyLightning(lightning)
end

--xyz对xyz创建闪电
hlightning.xyz2xyz = function(lightningType, x1, y1, z1, x2, y2, z2, during)
    local lightning = cj.AddLightningEx(lightningType, true, x1, y1, z1, x2, y2, z2)
    during = during or 0.25
    htime.setTimeout(
        during,
        function(t, td)
            htime.delDialog(td)
            htime.delTimer(t)
            hlightning.del(lightning)
        end
    )
    return lightning
end

--点对点创建闪电
hlightning.loc2loc = function(lightningType, loc1, loc2, during)
    return hlightning.xyz2xyz(
        lightningType,
        cj.GetLocationX(loc1),
        cj.GetLocationY(loc1),
        cj.GetLocationZ(loc1),
        cj.GetLocationX(loc2),
        cj.GetLocationY(loc2),
        cj.GetLocationZ(loc2),
        during
    )
end

--单位对单位创建闪电
hlightning.unit2unit = function(lightningType, unit1, unit2, during)
    local loc1 = cj.GetUnitLoc(unit1)
    local loc2 = cj.GetUnitLoc(unit2)
    local l = hlightning.loc2loc(lightningType, loc1, loc2, during)
    cj.RemoveLocation(loc1)
    cj.RemoveLocation(loc2)
    return l
end