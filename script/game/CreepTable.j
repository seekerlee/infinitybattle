library CreepTable initializer init

    globals
        key typeWeak // level <= 3
        key typeNormal // level > 3 && level <= 6
        key typeStrong // level > 6

        private integer array WeakId
        private integer WeakCount = 0
        private integer array NormalId
        private integer NormalCount = 0
        private integer array StrongId
        private integer StrongCount = 0
    endglobals

    private function addUnitType takes integer unitId, integer creepType returns nothing
        if creepType == typeWeak then
            set WeakId[WeakCount] = unitId
            set WeakCount = WeakCount + 1
        elseif creepType == typeNormal then
            set NormalId[NormalCount] = unitId
            set NormalCount = NormalCount + 1
        elseif creepType == typeStrong then
            set StrongId[StrongCount] = unitId
            set StrongCount = StrongCount + 1
        endif
    endfunction

    function getRandomIdOfType takes integer creepType returns integer
        if creepType == typeWeak and WeakCount > 0 then
            return WeakId[GetRandomInt(0, WeakCount - 1)]
        elseif creepType == typeNormal and NormalCount > 0 then
            return NormalId[GetRandomInt(0, NormalCount - 1)]
        elseif creepType == typeStrong and StrongCount > 0 then
            return StrongId[GetRandomInt(0, StrongCount - 1)]
        endif
        return 'hfoo'
    endfunction

    //
    // 飞行单位：锁定作为地面
    // 船：移动改为盘旋
    private function init takes nothing returns nothing
    
        call addUnitType('hdhw', typeWeak) //	blood elf dragon hawk		3	300	350
        call addUnitType('hfoo', typeWeak) //	Footman		2	90	270
        call addUnitType('hmil', typeWeak) //	Militia		1	90	270
        call addUnitType('hmpr', typeWeak) //	Priest		2	600	270
        call addUnitType('hmtm', typeWeak) //	MortarTeam		2	1150	270
        call addUnitType('hrif', typeWeak) //	Rifleman		3	400	270
        call addUnitType('hsor', typeWeak) //	Sorceress		2	600	270
        call addUnitType('hspt', typeWeak) //	Blood Elf Spell Breaker		3	250	300
        call addUnitType('odoc', typeWeak) //	WitchDoctor		2	600	270
        call addUnitType('ogru', typeWeak) //	Grunt		3	100	270
        call addUnitType('ohun', typeWeak) //	HeadHunter		2	550	270
        call addUnitType('orai', typeWeak) //	WolfRider		3	100	350
        call addUnitType('oshm', typeWeak) //	Shaman		2	600	270
        call addUnitType('ospw', typeWeak) //	spiritwalker	Tauren	3	400	270
        call addUnitType('osw1', typeWeak) //	spirit wolf level 1		2	90	320
        call addUnitType('osw2', typeWeak) //	spirit wolf level 2		3	90	350
        call addUnitType('otbk', typeWeak) //	Berserker		2	550	270
        call addUnitType('otbr', typeWeak) //	Troll Batrider		2	300	320
        call addUnitType('earc', typeWeak) //	Archer		2	500	270
        call addUnitType('edot', typeWeak) //	DruidoftheTalon		2	600	270
        call addUnitType('edry', typeWeak) //	Dryad		3	500	350
        call addUnitType('edtm', typeWeak) //	DruidoftheTalonMorph		2	600	350
        call addUnitType('efdr', typeWeak) //	faerie dragon		3	300	350
        call addUnitType('efon', typeWeak) //	Ent		2	100	220
        call addUnitType('ehip', typeWeak) //	Hippogryph		2	128	400
        call addUnitType('esen', typeWeak) //	Huntress		3	225	350
        call addUnitType('even', typeWeak) //	vengeance		2	450	270
        call addUnitType('uban', typeWeak) //	Banshee	undead	2	600	270
        call addUnitType('ucry', typeWeak) //	CryptFiend	undead	3	550	270
        //call addUnitType('ucs1', typeWeak) //	carrion scarab level 1	undead	1	90	290
        //call addUnitType('ucs2', typeWeak) //	carrion scarab level 2	undead	2	90	290
        //call addUnitType('ucs3', typeWeak) //	carrion scarab level 3	undead	3	90	290
        call addUnitType('ugar', typeWeak) //	Gargoyle	undead	2	128	375
        call addUnitType('ugho', typeWeak) //	Ghoul	undead	2	90	270
        call addUnitType('unec', typeWeak) //	Necromancer	undead	2	600	270
        call addUnitType('uske', typeWeak) //	SkeletonWarrior	undead	1	90	270
        call addUnitType('uskm', typeWeak) //	Skeletal Mage	undead	1	500	270
        call addUnitType('nnht', typeWeak) //	nether hatchling		3	600	350
        call addUnitType('npfl', typeWeak) //	purple felhound		3	100	350
        call addUnitType('ndr1', typeWeak) //	DarkMinion1	undead	2	90	270
        call addUnitType('ndr2', typeWeak) //	DarkMinion2	undead	3	90	300
        call addUnitType('nqbh', typeWeak) //	quillboar hunter		3	500	270
        call addUnitType('nadw', typeWeak) //	blue dragon whelp		3	600	350
        call addUnitType('nanb', typeWeak) //	barbed arachnathid		1	600	300
        call addUnitType('nanm', typeWeak) //	barbed arachnathid(merc)		1	600	300
        call addUnitType('nanc', typeWeak) //	crystal arachnathid		1	100	300
        call addUnitType('nanw', typeWeak) //	arachnathid warrior		3	100	300
        call addUnitType('narg', typeWeak) //	battle golem		3	100	240
        call addUnitType('nban', typeWeak) //	bandit		1	100	270
        call addUnitType('nbdm', typeWeak) //	blue dragonspawn meddler		3	100	300
        call addUnitType('nbdr', typeWeak) //	black whelp		3	600	350
        call addUnitType('nbrg', typeWeak) //	brigand		2	500	270
        call addUnitType('nbzw', typeWeak) //	bronze dragon whelp		3	600	350
        call addUnitType('ncea', typeWeak) //	CentaurArcher		2	500	350
        call addUnitType('ncer', typeWeak) //	centaur drudge		2	100	350
        call addUnitType('ncfs', typeWeak) //	watery minion cliffrunner		2	100	270
        call addUnitType('ndqn', typeWeak) //	succubus		3	100	320
        call addUnitType('ndtp', typeWeak) //	dark troll shadow priest		2	600	270
        call addUnitType('ndtr', typeWeak) //	darkTroll		2	500	270
        call addUnitType('ndtt', typeWeak) //	darkTrollTrapper		3	500	300
        call addUnitType('nenc', typeWeak) //	corrupted ent		1	100	270
        call addUnitType('nenp', typeWeak) //	poison ent		3	100	270
        call addUnitType('nfgu', typeWeak) //	felguard		2	100	270
        call addUnitType('nfsp', typeWeak) //	forest troll shadow priest		2	600	270
        call addUnitType('nftr', typeWeak) //	ForestTroll		2	500	270
        call addUnitType('nftt', typeWeak) //	ForestTrollTrapper		3	500	270
        call addUnitType('ngh1', typeWeak) //	ghost	undead	3	400	270
        call addUnitType('ngna', typeWeak) //	Gnoll Poacher		1	500	270
        call addUnitType('ngnb', typeWeak) //	gnoll brute		3	100	270
        call addUnitType('ngno', typeWeak) //	Gnoll Robber		1	100	270
        call addUnitType('ngns', typeWeak) //	Gnoll Assassin		3	500	270
        call addUnitType('ngnw', typeWeak) //	gnoll warden		3	500	270
        call addUnitType('ngrk', typeWeak) //	mud golem		2	100	240
        call addUnitType('ngrw', typeWeak) //	green dragon whelp		3	600	350
        call addUnitType('nhar', typeWeak) //	Harpy Scout		1	600	270
        call addUnitType('nhdc', typeWeak) //	deceiver		3	600	270
        call addUnitType('nhfp', typeWeak) //	fallen priest		1	600	270
        call addUnitType('nhrr', typeWeak) //	harpy rogue		3	500	350
        call addUnitType('nhrw', typeWeak) //	harpy witch		3	600	350
        call addUnitType('nhyh', typeWeak) //	hydra hatchling		3	500	270
        call addUnitType('nitp', typeWeak) //	ice troll shadow priest		2	600	270
        call addUnitType('nitr', typeWeak) //	IceTroll		2	500	270
        call addUnitType('nitt', typeWeak) //	ice troll trapper		3	500	270
        call addUnitType('njg1', typeWeak) //	Jungle Stalker		3	128	320
        call addUnitType('nkob', typeWeak) //	Kobold		1	100	270
        call addUnitType('nkog', typeWeak) //	Kobold Geomancer		3	600	270
        call addUnitType('nkot', typeWeak) //	kobold tunneler		3	100	270
        call addUnitType('nlpd', typeWeak) //	makrura pool dweller		2	100	270
        call addUnitType('nlpr', typeWeak) //	makrura prawn		1	100	270
        call addUnitType('nlps', typeWeak) //	makrura prawn summoned		1	100	270
        call addUnitType('nltc', typeWeak) //	makrura tide caller		2	500	270
        call addUnitType('nltl', typeWeak) //	lightning lizard		2	600	270
        call addUnitType('nmam', typeWeak) //	Mammoth		3	100	300
        call addUnitType('nmbg', typeWeak) //	mur'gul blood-gill		2	500	270
        call addUnitType('nmcf', typeWeak) //	mur'gul cliffrunner		1	100	270
        call addUnitType('nmfs', typeWeak) //	murloc flesheater		3	100	270
        call addUnitType('nmpg', typeWeak) //	murloc plaguebearer		2	100	270
        call addUnitType('nmrm', typeWeak) //	murloc nightcrawler		3	100	270
        call addUnitType('nmrr', typeWeak) //	murloc huntsman		2	100	270
        call addUnitType('nmtw', typeWeak) //	mur'gul tidewarrior		3	100	270
        call addUnitType('nnmg', typeWeak) //	naga mur'gul		2	100	270
        call addUnitType('nnsw', typeWeak) //	naga siren		2	600	270
        call addUnitType('nnwl', typeWeak) //	nerubian webspinner		3	600	320
        call addUnitType('nogr', typeWeak) //	Ogre Warrior		3	100	270
        call addUnitType('nrel', typeWeak) //	reef elemental		2	500	220
        call addUnitType('nrog', typeWeak) //	rogue		3	100	270
        call addUnitType('nrvf', typeWeak) //	fire revenant	undead	3	100	270
        call addUnitType('nrzb', typeWeak) //	razormane brute		3	100	270
        call addUnitType('nrzs', typeWeak) //	razormane scout		1	100	270
        call addUnitType('nrzt', typeWeak) //	quillboar		1	500	270
        call addUnitType('nsat', typeWeak) //	Satyr Trickster		1	600	270
        call addUnitType('nsc2', typeWeak) //	spider crab		3	100	270
        call addUnitType('nscb', typeWeak) //	spider crab		1	100	270
        call addUnitType('nsgn', typeWeak) //	sea giant		3	100	200
        call addUnitType('nska', typeWeak) //	skeletal archer	undead	1	500	270
        call addUnitType('nske', typeWeak) //	SkeletonWarrior	undead	1	90	270
        call addUnitType('nsca', typeWeak) //	skeletal archer(summoned)	undead	1	500	270
        call addUnitType('nsce', typeWeak) //	SkeletonWarrior(summoned)	undead	1	90	270
        call addUnitType('nskf', typeWeak) //	burning archer	undead	3	500	270
        call addUnitType('nskg', typeWeak) //	giant SkeletonWarrior	undead	3	90	270
        call addUnitType('nskm', typeWeak) //	skeletal marksman	undead	3	500	270
        call addUnitType('nsko', typeWeak) //	skeletal orc	undead	3	100	270
        call addUnitType('nslf', typeWeak) //	sludge flinger		3	600	270
        call addUnitType('nslh', typeWeak) //	salamander hatchling		3	400	270
        call addUnitType('nslm', typeWeak) //	sludge minion		1	100	270
        call addUnitType('nsnp', typeWeak) //	snap dragon		3	550	350
        call addUnitType('nsns', typeWeak) //	watery minion snarecaster		3	500	270
        call addUnitType('nspb', typeWeak) //	black spider		1	100	270
        call addUnitType('nspd', typeWeak) //	spiderling		1	100	270
        call addUnitType('nspg', typeWeak) //	green spider		1	100	270
        call addUnitType('nspp', typeWeak) //	spirit pig		2	90	350
        call addUnitType('nspr', typeWeak) //	spider		1	100	270
        call addUnitType('nsra', typeWeak) //	stormreaver apprentice		1	500	270
        call addUnitType('nsrh', typeWeak) //	stormreaver hermit		3	500	270
        call addUnitType('nssp', typeWeak) //	spitting spider		3	600	270
        call addUnitType('nsts', typeWeak) //	satyr shadowdancer		3	600	270
        call addUnitType('nsty', typeWeak) //	satyr		1	100	270
        call addUnitType('ntka', typeWeak) //	tuskarr spearman		2	500	270
        call addUnitType('ntkf', typeWeak) //	tuskarr fighter		2	100	300
        call addUnitType('ntkh', typeWeak) //	tuskarr healer		3	125	270
        call addUnitType('ntrh', typeWeak) //	sea turtle hatchling		1	500	270
        call addUnitType('ntrs', typeWeak) //	sea turtle		2	100	270
        call addUnitType('ntrv', typeWeak) //	revenant of the tides	undead	3	100	270
        call addUnitType('ntws', typeWeak) //	watery minion tidewarrior		2	100	270
        call addUnitType('nubk', typeWeak) //	unbroken darkhunter		2	100	300
        call addUnitType('nvdl', typeWeak) //	lesser voidwalker		1	450	270
        call addUnitType('nvdw', typeWeak) //	voidwalker		3	450	270
        call addUnitType('nwgs', typeWeak) //	naga coutl		2	450	350
        call addUnitType('nwiz', typeWeak) //	wizard		1	600	270
        call addUnitType('nwlt', typeWeak) //	timber wolf		2	100	350
        call addUnitType('nwwf', typeWeak) //	white wolf		2	100	350
        call addUnitType('nwzr', typeWeak) //	rogue wizard		3	600	270
        call addUnitType('nzom', typeWeak) //	Zombie	undead	1	100	270
        call addUnitType('nhym', typeWeak) //	hydromancer		2	600	270
        call addUnitType('nchp', typeWeak) //	chaplain		2	600	270
        call addUnitType('nqb1', typeWeak) //	quillbeast 1		3	550	300
        call addUnitType('nrdk', typeWeak) //	Red Dragon Whelp		3	600	350
        call addUnitType('nmrl', typeWeak) //	murloc fisherman		1	100	270
        call addUnitType('ensh', typeWeak) //	Naisha		3	225	350
        call addUnitType('hhes', typeWeak) //	high elven swordsman		2	90	270
        call addUnitType('nsw1', typeWeak) //	spirit beast level 1		2	90	350
        call addUnitType('nsw2', typeWeak) //	spirit beast level 2		3	90	350
        call addUnitType('nbel', typeWeak) //	blood elf lieutenant		2	200	270
        call addUnitType('nchw', typeWeak) //	ChaosWarlock		2	600	270
        call addUnitType('ndmu', typeWeak) //	dalaran mutant		2	90	270
        call addUnitType('ndrf', typeWeak) //	draenei guardian		1	100	270
        call addUnitType('ndrj', typeWeak) //	dalaran reject		1	100	270
        call addUnitType('ndrm', typeWeak) //	draenei disciple		2	600	270
        call addUnitType('ndrp', typeWeak) //	draenei protector		2	100	270
        call addUnitType('ndrw', typeWeak) //	draenei watcher		3	100	270
        call addUnitType('ndsa', typeWeak) //	draenei salamander		3	500	270
        call addUnitType('nemi', typeWeak) //	emissary		2	600	270
        call addUnitType('nhea', typeWeak) //	high elven archer		2	500	270
        call addUnitType('njks', typeWeak) //	jailor kassan		1	100	270
        call addUnitType('nmdm', typeWeak) //	medivh morphed		2	600	240
        call addUnitType('nmed', typeWeak) //	medivh		2	600	240
        call addUnitType('nssn', typeWeak) //	night elf assassin		3	650	300
        call addUnitType('nw2w', typeWeak) //	War2Warlock		2	600	270
        call addUnitType('nwat', typeWeak) //	watcher		2	100	280
        call addUnitType('ogrk', typeWeak) //	Gar'thok		3	100	270
        call addUnitType('omtg', typeWeak) //	mathog		2	100	240
        call addUnitType('onzg', typeWeak) //	nazgrel		3	100	350
        call addUnitType('ovlj', typeWeak) //	vol'jin		2	600	270
        call addUnitType('owar', typeWeak) //	orc warchief		2	100	240
        call addUnitType('uktn', typeWeak) //	kelthuzadnecro	undead	2	600	240
        call addUnitType('uswb', typeWeak) //	sylvanus banshee	undead	3	500	270
        call addUnitType('nnsu', typeWeak) //	naga summoner		2	600	270
        call addUnitType('nnwa', typeWeak) //	nerubian warrior		3	100	320
        call addUnitType('zzrg', typeWeak) //	zergling		3	100	270

        call addUnitType('hgry', typeNormal) //	GryphonRider		5	450	320
        call addUnitType('hkni', typeNormal) //	Knight		4	100	350
        call addUnitType('hwat', typeNormal) //	WaterElemental		4	300	220
        call addUnitType('hwt2', typeNormal) //	WaterElemental level 2		5	300	220
        call addUnitType('hwt3', typeNormal) //	WaterElemental level 3		6	300	220
        call addUnitType('okod', typeNormal) //	KodoBeast		4	500	220
        call addUnitType('osw3', typeNormal) //	spirit wolf level 3		4	90	350
        call addUnitType('otau', typeNormal) //	Tauren	Tauren	5	100	270
        call addUnitType('owyv', typeNormal) //	Wind Rider		4	450	320
        call addUnitType('echm', typeNormal) //	Chimaera		5	850	250
        call addUnitType('edcm', typeNormal) //	DruidoftheClawMorph		4	100	270
        call addUnitType('edoc', typeNormal) //	DruidoftheClaw		4	100	270
        call addUnitType('ehpr', typeNormal) //	Hippogryph Rider		4	400	350
        call addUnitType('emtg', typeNormal) //	Mountain Giant		6	128	270
        call addUnitType('uabo', typeNormal) //	Abomination	undead	4	128	270
        call addUnitType('ubsp', typeNormal) //	destroyer	undead	5	450	320
        call addUnitType('ufro', typeNormal) //	FrostWyrm	undead	6	300	270
        call addUnitType('ndr3', typeNormal) //	DarkMinion3	undead	4	90	330
        call addUnitType('ngz1', typeNormal) //	grizzly bear 1		4	128	320
        call addUnitType('ngz2', typeNormal) //	grizzly bear 2		5	128	320
        call addUnitType('ngz3', typeNormal) //	grizzly bear 3		6	128	350
        call addUnitType('ngzc', typeNormal) //	misha 1		4	128	320
        call addUnitType('ngzd', typeNormal) //	misha 2		5	128	320
        call addUnitType('ngza', typeNormal) //	misha 3		6	128	350
        call addUnitType('npn1', typeNormal) //	Fire pandaren split		6	128	300
        call addUnitType('npn2', typeNormal) //	Wind pandaren split		6	500	300
        call addUnitType('npn3', typeNormal) //	Earth pandaren split		6	128	300
        call addUnitType('nqb2', typeNormal) //	quillbeast 2		4	550	300
        call addUnitType('nqb3', typeNormal) //	quillbeast 3		5	550	300
        call addUnitType('nqb4', typeNormal) //	quillbeast 4		6	550	300
        call addUnitType('nwe2', typeNormal) //	war eagle 2		5	300	350
        call addUnitType('nwe3', typeNormal) //	war eagle 3		6	300	350
        call addUnitType('nadk', typeNormal) //	blue drake		6	500	350
        call addUnitType('nane', typeNormal) //	arachnathid earth-borer		4	500	270
        call addUnitType('nano', typeNormal) //	arachnathid overlord		5	100	300
        call addUnitType('nass', typeNormal) //	assassin		4	500	300
        call addUnitType('nbda', typeNormal) //	blue dragonspawn apprentice		4	100	270
        call addUnitType('nbdk', typeNormal) //	black drake		6	500	350
        call addUnitType('nbds', typeNormal) //	blue dragonspawn sorceror		6	100	270
        call addUnitType('nbdw', typeNormal) //	blue dragonspawn warrior		5	100	300
        call addUnitType('nbzk', typeNormal) //	bronze drake		6	500	350
        call addUnitType('ncen', typeNormal) //	Centaur outrunner		4	100	350
        call addUnitType('ncim', typeNormal) //	Centaur impaler		4	500	350
        call addUnitType('ncks', typeNormal) //	centaur sorceror		5	600	350
        call addUnitType('ndqt', typeNormal) //	vile temptress		6	100	320
        call addUnitType('ndqv', typeNormal) //	vile tormentor		5	500	320
        call addUnitType('ndtb', typeNormal) //	dark troll berserker		4	500	270
        call addUnitType('ndth', typeNormal) //	dark troll high priest		4	600	270
        call addUnitType('ndtw', typeNormal) //	darkTrollwarlord		6	500	320
        call addUnitType('nele', typeNormal) //	enraged elemental		4	300	220
        call addUnitType('nenf', typeNormal) //	enforcer		5	100	270
        call addUnitType('nepl', typeNormal) //	plague ent		5	100	270
        call addUnitType('nerd', typeNormal) //	eredar diabolist		6	600	270
        call addUnitType('ners', typeNormal) //	eredar sorceror		4	600	270
        call addUnitType('nfel', typeNormal) //	fel stalker		5	100	350
        call addUnitType('nfgb', typeNormal) //	bloodfiend		4	100	270
        call addUnitType('nfor', typeNormal) //	faceless one trickster		6	100	300
        call addUnitType('nfov', typeNormal) //	overlord		6	100	270
        call addUnitType('nfpl', typeNormal) //	Polar Furbolg		4	100	300
        call addUnitType('nfps', typeNormal) //	Polar Furbolg Shaman		4	600	270
        call addUnitType('nfpt', typeNormal) //	Polar Furbolg Tracker		6	100	320
        call addUnitType('nfrb', typeNormal) //	Furbolg Tracker		6	100	320
        call addUnitType('nfrl', typeNormal) //	Furbolg		4	100	300
        call addUnitType('nfrp', typeNormal) //	Furbolg Panda		4	100	300
        call addUnitType('nfrs', typeNormal) //	Furbolg Shaman		4	600	270
        call addUnitType('nfsh', typeNormal) //	forest troll high priest		4	600	270
        call addUnitType('nftb', typeNormal) //	forest troll berserker		4	500	270
        call addUnitType('nftk', typeNormal) //	ForestTrollKing		6	500	320
        call addUnitType('ngdk', typeNormal) //	green drake		6	500	350
        call addUnitType('ngh2', typeNormal) //	wraith	undead	6	500	270
        call addUnitType('ngnv', typeNormal) //	gnoll king		5	100	270
        call addUnitType('ngst', typeNormal) //	rock golem		6	100	270
        call addUnitType('nhhr', typeNormal) //	heretic		5	600	270
        call addUnitType('nhrh', typeNormal) //	harpy hag		5	500	350
        call addUnitType('nhyc', typeNormal) //	campaign turtle		5	480	270
        call addUnitType('nhyd', typeNormal) //	hydra		6	500	270
        call addUnitType('nith', typeNormal) //	ice troll high priest		4	600	300
        call addUnitType('nits', typeNormal) //	ice troll berserker		4	500	300
        call addUnitType('nitw', typeNormal) //	ice troll warlord		6	500	320
        call addUnitType('njga', typeNormal) //	Elder Jungle Stalker		6	128	320
        call addUnitType('nkol', typeNormal) //	kobold leader		5	100	270
        call addUnitType('nlds', typeNormal) //	makrura deep seer		5	600	270
        call addUnitType('nlsn', typeNormal) //	makrura snapper		5	100	270
        call addUnitType('nmgw', typeNormal) //	magnataur warrior		5	100	300
        call addUnitType('nmit', typeNormal) //	Icetusk Mammoth		5	100	300
        call addUnitType('nmmu', typeNormal) //	murloc mutant		6	100	270
        call addUnitType('nmrv', typeNormal) //	mur'gul reaver		6	100	270
        call addUnitType('nmsh', typeNormal) //	misha the bear		4	128	300
        call addUnitType('nmyr', typeNormal) //	naga myrmidon		4	128	270
        call addUnitType('nnrg', typeNormal) //	naga royal guard		6	128	320
        call addUnitType('nnwr', typeNormal) //	nerubian seer		5	500	320
        call addUnitType('nnws', typeNormal) //	nerubian spider lord		5	100	320
        call addUnitType('nogm', typeNormal) //	ogre mauler		5	100	270
        call addUnitType('nogo', typeNormal) //	Stonemaul Ogre		6	100	270
        call addUnitType('nomg', typeNormal) //	ogre magi		5	100	270
        call addUnitType('nowe', typeNormal) //	enraged owlbear		6	128	320
        call addUnitType('nlv1', typeNormal) //	LavaSpawn1		4	300	300
        call addUnitType('nlv2', typeNormal) //	LavaSpawn2		5	300	300
        call addUnitType('nlv3', typeNormal) //	LavaSpawn3		6	300	300
        call addUnitType('nrdr', typeNormal) //	Red Drake		6	400	350
        call addUnitType('nrvl', typeNormal) //	lightning revenant	undead	6	128	270
        call addUnitType('nrvs', typeNormal) //	frost revenant	undead	4	128	270
        call addUnitType('nrzm', typeNormal) //	razormane medicine man		5	100	270
        call addUnitType('nsbm', typeNormal) //	brood mother		6	100	320
        call addUnitType('nsc3', typeNormal) //	spider crab		5	100	270
        call addUnitType('nsel', typeNormal) //	sea elemental		5	600	220
        call addUnitType('nsgh', typeNormal) //	sea giant hunter		5	100	200
        call addUnitType('nsgt', typeNormal) //	giant spider		4	100	300
        call addUnitType('nsln', typeNormal) //	sludge monstrosity		5	100	270
        call addUnitType('nslr', typeNormal) //	salamander		5	500	270
        call addUnitType('nsog', typeNormal) //	skeletal orc grunt	undead	5	100	270
        call addUnitType('nsqe', typeNormal) //	elder sasquatch		6	128	320
        call addUnitType('nsqt', typeNormal) //	sasquatch		5	128	270
        call addUnitType('nsrn', typeNormal) //	stormreaver necrolyte		6	600	270
        call addUnitType('nsrv', typeNormal) //	revenant of the seas	undead	5	100	270
        call addUnitType('nstl', typeNormal) //	satyr soulstealer		5	100	270
        call addUnitType('nthl', typeNormal) //	thunder lizard		6	500	270
        call addUnitType('ntks', typeNormal) //	tuskarr sorceror		5	600	270
        call addUnitType('ntkt', typeNormal) //	tuskarr trapper		4	500	270
        call addUnitType('ntkw', typeNormal) //	tuskarr warrior		4	100	300
        call addUnitType('ntrt', typeNormal) //	giant sea turtle		4	500	270
        call addUnitType('nubr', typeNormal) //	unbroken rager		4	100	300
        call addUnitType('nubw', typeNormal) //	unbroken darkweaver		5	100	300
        call addUnitType('nvdg', typeNormal) //	greater voidwalker		6	450	270
        call addUnitType('nwen', typeNormal) //	Wendigo		4	128	320
        call addUnitType('nwld', typeNormal) //	dire wolf		6	90	350
        call addUnitType('nwlg', typeNormal) //	giant wolf		4	90	350
        call addUnitType('nwnr', typeNormal) //	elder wendigo		6	128	320
        call addUnitType('nwrg', typeNormal) //	war golem		6	100	270
        call addUnitType('nws1', typeNormal) //	dragon hawk		5	600	270
        call addUnitType('nwwd', typeNormal) //	white dire wolf		6	90	350
        call addUnitType('nwwg', typeNormal) //	giant white wolf		4	90	350
        call addUnitType('nwzg', typeNormal) //	renegade wizard		5	600	270
        call addUnitType('nowb', typeNormal) //	owlbear		4	128	300
        call addUnitType('nplb', typeNormal) //	polar bear		4	128	300
        call addUnitType('nplg', typeNormal) //	giant polar bear		6	128	320
        call addUnitType('eshd', typeNormal) //	shandris		4	600	270
        call addUnitType('hcth', typeNormal) //	the captain		6	100	270
        call addUnitType('nsw3', typeNormal) //	spirit beast level 3		4	90	350
        call addUnitType('nchg', typeNormal) //	chaos grunt		4	100	270
        call addUnitType('nchr', typeNormal) //	ChaosWolfRider		5	100	350
        call addUnitType('nckb', typeNormal) //	Chaos Kodo Beast		4	500	220
        call addUnitType('ndrd', typeNormal) //	draenei darkslayer		5	100	320
        call addUnitType('ndrn', typeNormal) //	draenei vindicator		5	100	270
        call addUnitType('ndrt', typeNormal) //	draenei stalker		5	100	270
        call addUnitType('ndrh', typeNormal) //	draenei harbinger		4	600	270
        call addUnitType('ndrs', typeNormal) //	draenei seer		6	600	270
        call addUnitType('nmsn', typeNormal) //	mur'gul snarecaster		4	500	270
        call addUnitType('odkt', typeNormal) //	Drak'Thul		6	600	270
        call addUnitType('ownr', typeNormal) //	wyvern		5	128	350
        call addUnitType('uabc', typeNormal) //	Abomination cinematic	undead	4	128	270
        call addUnitType('ubdd', typeNormal) //	dead azurelore	undead	6	300	270
        call addUnitType('nndk', typeNormal) //	nether drake		6	500	350
        call addUnitType('zcso', typeNormal) //	chaos space orc		6	300	270
        call addUnitType('zmar', typeNormal) //	Marine		6	400	270
        call addUnitType('zsmc', typeNormal) //	sammy cube		6	600	270

        call addUnitType('espv', typeStrong) //	spirit of vengeance		7	450	320
        call addUnitType('ngz4', typeStrong) //	misha 4		7	128	370
        call addUnitType('npn4', typeStrong) //	Fire pandaren split2		8	128	300
        call addUnitType('npn5', typeStrong) //	Wind pandaren split2		8	500	300
        call addUnitType('npn6', typeStrong) //	Earth pandaren split2		8	128	300
        call addUnitType('nadr', typeStrong) //	blue dragon		10	500	300
        call addUnitType('nahy', typeStrong) //	ancient hydra		10	500	270
        call addUnitType('nbal', typeStrong) //	Doom Guard		8	600	270
        call addUnitType('nba2', typeStrong) //	Doom Guard(summoned)		8	600	270
        call addUnitType('nbdo', typeStrong) //	blue dragonspawn overseer		8	100	300
        call addUnitType('nbld', typeStrong) //	bandit lord		7	100	320
        call addUnitType('nbwm', typeStrong) //	black dragon		10	500	300
        call addUnitType('nbzd', typeStrong) //	bronze dragon		10	500	300
        call addUnitType('ncnk', typeStrong) //	centaur khan		8	100	320
        call addUnitType('ndqp', typeStrong) //	maiden of pain		8	500	320
        call addUnitType('ndqs', typeStrong) //	queen of suffering		10	100	320
        call addUnitType('ndrv', typeStrong) //	revenant of the depths	undead	8	100	270
        call addUnitType('nehy', typeStrong) //	elder hydra		7	600	270
        call addUnitType('nelb', typeStrong) //	berserk elemental		8	300	270
        call addUnitType('nerw', typeStrong) //	eredar warlock		9	600	270
        call addUnitType('nfod', typeStrong) //	faceless one deathbringer		10	500	300
        call addUnitType('nfot', typeStrong) //	faceless one terror		8	500	300
        call addUnitType('nfpc', typeStrong) //	Polar Furbolg Champion		7	100	320
        call addUnitType('nfpe', typeStrong) //	Polar Furbolg Elder Shaman		8	600	320
        call addUnitType('nfpu', typeStrong) //	Polar Furbolg Ursa Warrior		8	100	320
        call addUnitType('nfra', typeStrong) //	Furbolg Ursa Warrior		8	100	320
        call addUnitType('nfre', typeStrong) //	Furbolg Elder Shaman		7	600	320
        call addUnitType('nfrg', typeStrong) //	Furbolg Champion		7	100	320
        call addUnitType('nggr', typeStrong) //	granite golem		9	128	270
        call addUnitType('ngrd', typeStrong) //	green dragon		10	500	300
        call addUnitType('nhrq', typeStrong) //	harpy queen		7	500	350
        call addUnitType('ninf', typeStrong) //	Infernal		8	100	320
        call addUnitType('njgb', typeStrong) //	Enranged Jungle Stalker		9	128	320
        call addUnitType('nlkl', typeStrong) //	makrura tidal lord		7	100	270
        call addUnitType('nlrv', typeStrong) //	deeplord revenant	undead	10	128	270
        call addUnitType('nmdr', typeStrong) //	Dire Mammoth		8	100	300
        call addUnitType('nmgd', typeStrong) //	magnataur destroyer		10	100	300
        call addUnitType('nmgr', typeStrong) //	magnataur reaver		8	100	300
        call addUnitType('nmsc', typeStrong) //	mur'gul shadowcaster		7	600	270
        call addUnitType('nndr', typeStrong) //	nether dragon		10	500	350
        call addUnitType('nnwq', typeStrong) //	nerubian queen		7	600	320
        call addUnitType('nogl', typeStrong) //	ogre lord		7	100	320
        call addUnitType('nogn', typeStrong) //	Stonemaul Magi		7	100	270
        call addUnitType('nowk', typeStrong) //	berserk owlbear		8	128	320
        call addUnitType('npfm', typeStrong) //	purple felhound		7	100	350
        call addUnitType('nrvd', typeStrong) //	death revenant	undead	9	128	320
        call addUnitType('nrvi', typeStrong) //	ice revenant	undead	8	128	270
        call addUnitType('nrwm', typeStrong) //	Red Dragon		10	500	300
        call addUnitType('nrzg', typeStrong) //	razormane chieftain		7	100	320
        call addUnitType('nsgb', typeStrong) //	sea giant behemoth		8	100	200
        call addUnitType('nsgg', typeStrong) //	siege golem		9	100	270
        call addUnitType('nsll', typeStrong) //	salamander lord		10	500	270
        call addUnitType('nslv', typeStrong) //	salamander vizier		7	500	320
        call addUnitType('nsoc', typeStrong) //	skeletal orc champion	undead	8	100	270
        call addUnitType('nsqa', typeStrong) //	ancient sasquatch		9	128	320
        call addUnitType('nsqo', typeStrong) //	sasquatch oracle		7	128	320
        call addUnitType('nsrw', typeStrong) //	stormreaver warlock		9	600	270
        call addUnitType('nsth', typeStrong) //	satyr hellcaller		9	100	320
        call addUnitType('nstw', typeStrong) //	storm wyrm		9	500	270
        call addUnitType('ntkc', typeStrong) //	tuskarr chieftain		7	100	320
        call addUnitType('ntrd', typeStrong) //	dragon turtle		10	128	270
        call addUnitType('ntrg', typeStrong) //	gargantuan sea turtle		7	100	270
        call addUnitType('nvde', typeStrong) //	elder voidwalker		9	450	270
        call addUnitType('nwna', typeStrong) //	ancient wendigo		9	128	320
        call addUnitType('nwns', typeStrong) //	wendigo shaman		7	128	320
        call addUnitType('nwzd', typeStrong) //	dark wizard		8	500	320
        call addUnitType('noga', typeStrong) //	Stonemaul Warchief		11	100	320
        call addUnitType('nfgl', typeStrong) //	flesh golem		11	100	270
        call addUnitType('nser', typeStrong) //	searinox		8	500	280
        call addUnitType('nthr', typeStrong) //	tharifas		8	500	300
        call addUnitType('ubdr', typeStrong) //	azurelore		10	500	300
        call addUnitType('zhyd', typeStrong) //	hydralisk		7	400	270
        call addUnitType('zshv', typeStrong) //	shoveler		10	100	270
    endfunction
endlibrary
