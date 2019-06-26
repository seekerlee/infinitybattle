library CreepTable initializer init

    globals
        key typeMelee
        key typeRange
        key typeMage

        private integer array MeleeId
        private integer MeleeCount = 0
        private integer array RangedId
        private integer RangedCount = 0
        private integer array MagicId
        private integer MagicCount = 0
    endglobals

    private function addUnitType takes integer unitId, integer creepType returns nothing
        if creepType == typeMelee then
            set MeleeId[MeleeCount] = unitId
            set MeleeCount = MeleeCount + 1
        elseif creepType == typeRange then
            set RangedId[RangedCount] = unitId
            set RangedCount = RangedCount + 1
        elseif creepType == typeMage then
            set MagicId[MagicCount] = unitId
            set MagicCount = MagicCount + 1
        endif
    endfunction

    function getRandomIdOfType takes integer creepType returns integer
        if creepType == typeMelee then
            return MeleeId[GetRandomInt(0, MeleeCount - 1)]
        elseif creepType == typeRange then
            return RangedId[GetRandomInt(0, RangedCount - 1)]
        elseif creepType == typeMage then
            return MagicId[GetRandomInt(0, MagicCount - 1)]
        endif
        return 'hfoo'
    endfunction

    private function init takes nothing returns nothing
        call addUnitType('hfoo', typeMelee)
        call addUnitType('hmil', typeMelee)
        call addUnitType('hkni', typeMelee)
        call addUnitType('hhes', typeMelee)
        call addUnitType('ogru', typeMelee)
        call addUnitType('orai', typeMelee)
        call addUnitType('otau', typeMelee)
        call addUnitType('nchg', typeMelee)
        call addUnitType('nchr', typeMelee)
        call addUnitType('omtg', typeMelee)
        call addUnitType('nmsh', typeMelee)
        call addUnitType('ugho', typeMelee)
        call addUnitType('uabo', typeMelee)
        call addUnitType('uske', typeMelee)
        call addUnitType('nzom', typeMelee)
        call addUnitType('esen', typeMelee)
        call addUnitType('emtg', typeMelee)
        call addUnitType('edoc', typeMelee)
        call addUnitType('edcm', typeMelee) //变熊
        call addUnitType('efon', typeMelee) //树人
        call addUnitType('nnmg', typeMelee) //鱼人
        call addUnitType('nmyr', typeMelee) //娜迦暴徒
        call addUnitType('nnrg', typeMelee) //娜迦守卫
        call addUnitType('nmpe', typeMelee) //白鱼人
        // 中立
        call addUnitType('nanc', typeMelee) //沙王
        call addUnitType('nano', typeMelee) //杀王领主
        call addUnitType('nban', typeMelee) //强盗
        call addUnitType('nbld', typeMelee) //强盗领主
        call addUnitType('nbdm', typeMelee) //龙卵盗贼
        call addUnitType('ncen', typeMelee) //半人马先行者

        call addUnitType('ncnk', typeMelee) //半人马可汗
        call addUnitType('nscb', typeMelee) //
        call addUnitType('ndrf', typeMelee) //
        call addUnitType('nenc', typeMelee) //堕落树人
        call addUnitType('nfor', typeMelee) //g8脸
        call addUnitType('nfgb', typeMelee) //血恶魔
        call addUnitType('nfov', typeMelee) //领主
        call addUnitType('npfl', typeMelee) //狂暴野兽
        call addUnitType('nfel', typeMelee) //邪恶漫步
        call addUnitType('nfrl', typeMelee) //熊怪
        call addUnitType('nfrp', typeMelee) //熊猫？
        call addUnitType('nfrb', typeMelee) //
        call addUnitType('nfra', typeMelee) //黄熊怪
        call addUnitType('nsgn', typeMelee) //海巨人
        call addUnitType('nsgh', typeMelee) //
        call addUnitType('nspg', typeMelee) //
        call addUnitType('nspr', typeMelee) //
        call addUnitType('nspb', typeMelee) //
        call addUnitType('ngno', typeMelee) // 豺狼人
        call addUnitType('ngnv', typeMelee) // 豺狼首领
        call addUnitType('ngrk', typeMelee) // 泥潭傀儡
        call addUnitType('narg', typeMelee) // golemstatue
        call addUnitType('nkob', typeMelee) // 狗头人
        call addUnitType('nlpr', typeMelee) // 巨虾
        call addUnitType('nmgw', typeMelee) // 
        call addUnitType('nmgr', typeMelee) // 
        call addUnitType('nmam', typeMelee) // 
        call addUnitType('nmdr', typeMelee) // 恐怖猛犸
        call addUnitType('nmrv', typeMelee) // 黄鱼人
        call addUnitType('nmpg', typeMelee) // 绿鱼人
        call addUnitType('nspd', typeMelee) // 
        call addUnitType('nnws', typeMelee) // 蛛网怪首领
        call addUnitType('nogm', typeMelee) // 
        call addUnitType('nomg', typeMelee) // 
        call addUnitType('nogl', typeMelee) // 
        call addUnitType('nowb', typeMelee) // 
        call addUnitType('nplg', typeMelee) // 
        call addUnitType('nfpl', typeMelee) // 
        call addUnitType('nfpu', typeMelee) // 
        call addUnitType('nrzs', typeMelee) // 
        call addUnitType('nrzb', typeMelee) // 
        call addUnitType('nrzg', typeMelee) // 
        call addUnitType('nsrv', typeMelee) // 
        call addUnitType('nrvs', typeMelee) // 
        call addUnitType('nsqt', typeMelee) // 野人
        call addUnitType('nsqe', typeMelee) // 
        call addUnitType('nsty', typeMelee) // 
        call addUnitType('nsth', typeMelee) // 
        call addUnitType('nsoc', typeMelee) // 
        call addUnitType('ndqn', typeMelee) // 
        call addUnitType('ntrs', typeMelee) // 
        call addUnitType('ntrg', typeMelee) // 
        call addUnitType('ntrd', typeMelee) // 龙龟
        call addUnitType('ntkf', typeMelee) //
        call addUnitType('ntkh', typeMelee) //
        call addUnitType('ntkc', typeMelee) //
        call addUnitType('nubr', typeMelee) //
        call addUnitType('nwen', typeMelee) //
        call addUnitType('nwlt', typeMelee) //
        call addUnitType('ndrj', typeMelee) //
        call addUnitType('ndmu', typeMelee) //
        call addUnitType('njg1', typeMelee) //
        call addUnitType('nskg', typeMelee) //


    endfunction
endlibrary
