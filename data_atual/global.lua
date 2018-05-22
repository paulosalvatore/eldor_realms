dofile('data/lib/lib.lua')

PARTY_PROTECTION = 1
ADVANCED_SECURE_MODE = 1

if logoutDesativado == nil then
	logoutDesativado = {}
end

limiteOuroMonstrosPadrao = 20000

if jogadoresOuroMonstros == nil then
	jogadoresOuroMonstros = {}
end

if jogadoresOuroMonstrosBonus == nil then
	jogadoresOuroMonstrosBonus = {}
end

if ouroMonstrosCompartilhando == nil then
	ouroMonstrosCompartilhando = {}
end

delayTalkactions = {}

ropeSpots = {384, 418, 8278, 8592, 13189, 14435, 14436, 15635, 19518}

doors = {[1209] = 1211, [1210] = 1211, [1212] = 1214, [1213] = 1214, [1219] = 1220, [1221] = 1222, [1231] = 1233, [1232] = 1233, [1234] = 1236, [1235] = 1236, [1237] = 1238, [1239] = 1240, [1249] = 1251, [1250] = 1251, [1252] = 1254, [1253] = 1254, [1539] = 1540, [1541] = 1542, [3535] = 3537, [3536] = 3537, [3538] = 3539, [3544] = 3546, [3545] = 3546, [3547] = 3548, [4913] = 4915, [4914] = 4915, [4916] = 4918, [4917] = 4918, [5082] = 5083, [5084] = 5085, [5098] = 5100, [5099] = 5100, [5101] = 5102, [5107] = 5109, [5108] = 5109, [5110] = 5111, [5116] = 5118, [5117] = 5118, [5119] = 5120, [5125] = 5127, [5126] = 5127, [5128] = 5129, [5134] = 5136, [5135] = 5136, [5137] = 5139, [5138] = 5139, [5140] = 5142, [5141] = 5142, [5143] = 5145, [5144] = 5145, [5278] = 5280, [5279] = 5280, [5281] = 5283, [5282] = 5283, [5284] = 5285, [5286] = 5287, [5515] = 5516, [5517] = 5518, [5732] = 5734, [5733] = 5734, [5735] = 5737, [5736] = 5737, [6192] = 6194, [6193] = 6194, [6195] = 6197, [6196] = 6197, [6198] = 6199, [6200] = 6201, [6249] = 6251, [6250] = 6251, [6252] = 6254, [6253] = 6254, [6255] = 6256, [6257] = 6258, [6795] = 6796, [6797] = 6798, [6799] = 6800, [6801] = 6802, [6891] = 6893, [6892] = 6893, [6894] = 6895, [6900] = 6902, [6901] = 6902, [6903] = 6904, [7033] = 7035, [7034] = 7035, [7036] = 7037, [7042] = 7044, [7043] = 7044, [7045] = 7046, [7054] = 7055, [7056] = 7057, [8541] = 8543, [8542] = 8543, [8544] = 8546, [8545] = 8546, [8547] = 8548, [8549] = 8550, [9165] = 9167, [9166] = 9167, [9168] = 9170, [9169] = 9170, [9171] = 9172, [9173] = 9174, [9267] = 9269, [9268] = 9269, [9270] = 9272, [9271] = 9272, [9273] = 9274, [9275] = 9276, [10276] = 10277, [10274] = 10275, [10268] = 10270, [10269] = 10270, [10271] = 10273, [10272] = 10273, [10471] = 10472, [10480] = 10481, [10477] = 10479, [10478] = 10479, [10468] = 10470, [10469] = 10470, [10775] = 10777, [10776] = 10777, [12092] = 12094, [12093] = 12094, [12188] = 12190, [12189] = 12190, [19840] = 19842, [19841] = 19842, [19843] = 19844, [19980] = 19982, [19981] = 19982, [19983] = 19984, [20273] = 20275, [20274] = 20275, [20276] = 20277, [17235] = 17236, [18208] = 18209, [13022] = 13023, [10784] = 10786, [10785] = 10786, [12099] = 12101, [12100] = 12101, [12197] = 12199, [12198] = 12199, [19849] = 19851, [19850] = 19851, [19852] = 19853, [19989] = 19991, [19990] = 19991, [19992] = 19993, [20282] = 20284, [20283] = 20284, [20285] = 20286, [17237] = 17238, [13020] = 13021, [10780] = 10781, [12095] = 12096, [12195] = 12196, [19845] = 19846, [19985] = 19986, [20278] = 20279, [10789] = 10790, [12102] = 12103, [12204] = 12205, [19854] = 19855, [19994] = 19995, [20287] = 20288, [10782] = 10783, [12097] = 12098, [12193] = 12194, [19847] = 19848, [19987] = 19988, [20280] = 20281, [10791] = 10792, [12104] = 12105, [12202] = 12203, [19856] = 19857, [19996] = 19997, [20289] = 20290, [14634] = 14635}
verticalOpenDoors = {1211, 1220, 1224, 1228, 1233, 1238, 1242, 1246, 1251, 1256, 1260, 1540, 3546, 3548, 3550, 3552, 4915, 5083, 5109, 5111, 5113, 5115, 5127, 5129, 5131, 5133, 5142, 5145, 5283, 5285, 5289, 5293, 5516, 5737, 5749, 6194, 6199, 6203, 6207, 6251, 6256, 6260, 6264, 6798, 6802, 6902, 6904, 6906, 6908, 7044, 7046, 7048, 7050, 7055, 8543, 8548, 8552, 8556, 9167, 9172, 9269, 9274, 9274, 9269, 9278, 9282, 10270, 10275, 10279, 10283, 10479, 10481, 10485, 10483, 10786, 12101, 12199, 19851, 19853, 19991, 19993, 20284, 20286, 17238, 13021, 10790, 12103, 12205, 19855, 19995, 20288, 10792, 12105, 12203, 19857, 19997, 20290, 14635}
horizontalOpenDoors = {1214, 1222, 1226, 1230, 1236, 1240, 1244, 1248, 1254, 1258, 1262, 1542, 3537, 3539, 3541, 3543, 4918, 5085, 5100, 5102, 5104, 5106, 5118, 5120, 5122, 5124, 5136, 5139, 5280, 5287, 5291, 5295, 5518, 5734, 5746, 6197, 6201, 6205, 6209, 6254, 6258, 6262, 6266, 6796, 6800, 6893, 6895, 6897, 6899, 7035, 7037, 7039, 7041, 7057, 8546, 8550, 8554, 8558, 9170, 9174, 9272, 9276, 9280, 9284, 10273, 10277, 10281, 10285, 10470, 10472, 10476, 10474, 10777, 12094, 12190, 19842, 19844, 19982, 19984, 20275, 20277, 17236, 18209, 13023, 10781, 12096, 12196, 19846, 19986, 20279, 10783, 12098, 12194, 19848, 19988, 20281}
openSpecialDoors = {1224, 1226, 1228, 1230, 1242, 1244, 1246, 1248, 1256, 1258, 1260, 1262, 3541, 3543, 3550, 3552, 5104, 5106, 5113, 5115, 5122, 5124, 5131, 5133, 5289, 5291, 5293, 5295, 6203, 6205, 6207, 6209, 6260, 6262, 6264, 6266, 6897, 6899, 6906, 6908, 7039, 7041, 7048, 7050, 8552, 8554, 8556, 8558, 9176, 9178, 9180, 9182, 9278, 9280, 9282, 9284, 10279, 10281, 10283, 10285, 10474, 10476, 10483, 10485, 10781, 12096, 12196, 19846, 19986, 20279, 10783, 12098, 12194, 19848, 19988, 20281, 10790, 12103, 12205, 19855, 19995, 20288, 10792, 12105, 12203, 19857, 19997, 20290}
questDoors = {1223, 1225, 1241, 1243, 1255, 1257, 3542, 3551, 5105, 5114, 5123, 5132, 5288, 5290, 5745, 5748, 6202, 6204, 6259, 6261, 6898, 6907, 7040, 7049, 8551, 8553, 9175, 9177, 9277, 9279, 10278, 10280, 10475, 10484, 10782, 12097, 12193, 19847, 19987, 20280, 10791, 12104, 12202, 19856, 19996, 20289}
levelDoors = {1227, 1229, 1245, 1247, 1259, 1261, 3540, 3549, 5103, 5112, 5121, 5130, 5292, 5294, 6206, 6208, 6263, 6265, 6896, 6905, 7038, 7047, 8555, 8557, 9179, 9181, 9281, 9283, 10282, 10284, 10473, 10482, 10780, 10789, 10780, 12095, 12195, 19845, 19985, 20278, 10789, 12102, 12204, 19854, 19994, 20287}
keys = {2086, 2087, 2088, 2089, 2090, 2091, 2092, 10032, 13292}

sparkling = {8046, 8047}
arvores = {2700, 2701, 2702, 2703, 2704, 2705, 2706, 2707, 2708}

fluids = {
	[1] = {name = "water", message = "Gulp."},
	[2] = {name = "blood", message = "Gulp."},
	[3] = {name = "beer", message = "Aah..."},
	[4] = {name = "slime", message = "Urgh!"},
	[5] = {name = "lemonade", message = "Mmmh."},
	[6] = {name = "milk", message = "Gulp."},
	[7] = {name = "manafluid", message = "Aaaah..."},
	[10] = {name = "lifefluid", message = "Aaaah..."},
	[11] = {name = "oil", message = "Urgh!"},
	[13] = {name = "urine", message = "Urgh!"},
	[14] = {name = "coconut milk", message = "Gulp."},
	[15] = {name = "wine", message = "Aah..."},
	[19] = {name = "mud", message = "Urgh!"},
	[21] = {name = "fruit juice", message = "Gulp."},
	[26] = {name = "lava", message = "Gulp."},
	[27] = {name = "rum", message = "Gulp."},
	[28] = {name = "swamp", message = "Gulp."},
	[35] = {name = "tea", message = "Gulp."},
	[43] = {name = "mead", message = "Gulp."}
}

efeitos = {
	["fire"] = CONST_ME_HITBYFIRE,
	["hit"] = CONST_ME_BLOCKHIT,
	["poff"] = CONST_ME_POFF,
	["rage_skies"] = CONST_ME_BIGCLOUDS,
	["splash"] = CONST_ME_WATERSPLASH,
	["smoke"] = CONST_ME_SMOKE,
	["choque_roxo"] = CONST_ME_PURPLEENERGY,
	["teleport"] = CONST_ME_TELEPORT,
	["blue"] = CONST_ME_MAGIC_BLUE,
	["red"] = CONST_ME_MAGIC_RED,
	["green"] = CONST_ME_MAGIC_GREEN
}

conditionsDamage = {
	["terra"] = {CONDITION_POISON, COMBAT_EARTHDAMAGE},
	["fogo"] = {CONDITION_FIRE, COMBAT_FIREDAMAGE},
	["energia"] = {CONDITION_ENERGY, COMBAT_ENERGYDAMAGE},
	["afogamento"] = {CONDITION_DROWN, COMBAT_DROWNDAMAGE},
	["gelo"] = {CONDITION_FREEZING, COMBAT_ICEDAMAGE},
	["sagrado"] = {CONDITION_DAZZLED, COMBAT_HOLYDAMAGE},
	["morte"] = {CONDITION_CURSED, COMBAT_DEATHDAMAGE},
	["f�sico"] = {CONDITION_BLEEDING, COMBAT_PHYSICALDAMAGE}
}

conditionsHealing = {
	CONDITION_POISON,
	CONDITION_FIRE,
	CONDITION_ENERGY,
	CONDITION_PARALYZE,
	CONDITION_DRUNK,
	CONDITION_DROWN,
	CONDITION_FREEZING,
	CONDITION_DAZZLED,
	CONDITION_CURSED,
	CONDITION_BLEEDING
}

modificarItensPeso = {}

itemDesativado = 2500

modalTeleportCrystal = 9001
modalPergaminhoTeleporte = 9002
modalItensKnight = 5000
modalQuest = 5500
modalQuestMaximo = 5999

itensKnight = {2384, 2448, 2380}

posicoesDepot = {
	[2] = {x = 800, y = 1806, z = 7}, -- Mugulu
	[3] = {x = 975, y = 1908, z = 4}, -- Civitaten
	-- [4] = {x = 964, y = 1770, z = 8}, -- Udecoat
	[5] = {x = 823, y = 1305, z = 7}, -- �tt�
	[6] = {x = 882, y = 1496, z = 8}, -- Pundera
	[9] = {x = 1079, y = 1605, z = 7}, -- Hyalakur
	[10] = {x = 1243, y = 1656, z = 5}, -- Lorn
	[11] = {x = 1326, y = 1912, z = 7}, -- Kyo
	[12] = {x = 1123, y = 2015, z = 7}, -- Algatar
	[13] = {x = 1530, y = 1702, z = 7} -- Khazad-d�m
}

itensMovimentoDesativado = {
	2500, -- Uso Geral
	2503, -- Uso Geral
	3902, -- Pergaminho de Teleporte
	3903 -- Refil de Po��es
}

destinosPergaminhoTeleporte = {
	{
		["nome"] = "Templo"
	},
	{
		["nome"] = "Guilda"
	},
	{
		["nome"] = "NPC's",
		["destinos"] = {
			{["nome"] = "Flora (refil de po��es)", ["posicao"] = {x = 593, y = 914, z = 7}},
			{["nome"] = "Sirk Skana (equipamentos de defesa)", ["posicao"] = {x = 575, y = 954, z = 7}},
			{["nome"] = "Jane e Jack (produtos de criaturas)", ["posicao"] = {x = 567, y = 944, z = 7}},
			{["nome"] = "Phaos Thourasa (utilidades)", ["posicao"] = {x = 598, y = 946, z = 7}},
			{["nome"] = "Tryn (escudos)", ["posicao"] = {x = 650, y = 953, z = 6}},
			{["nome"] = "Barna (armas simples corpo-a-corpo)", ["posicao"] = {x = 650, y = 954, z = 7}},
			{["nome"] = "Artanis (armas simples � dist�ncia)", ["posicao"] = {x = 610, y = 925, z = 7}},
			{["nome"] = "Barqueiro - Acesso � Parte Baixa da Ilha", ["posicao"] = {x = 588, y = 1018, z = 7}},
			{["nome"] = "Navio - Acesso ao Continente", ["posicao"] = {x = 629, y = 940, z = 6}}
		}
	},
	{
		["nome"] = "�reas de Ca�a",
		["destinos"] = {
			{["nome"] = "Montanha - T�rreo - Rat, Snake", ["posicao"] = {x = 558, y = 916, z = 7}},
			{["nome"] = "Montanha - 1� Andar - Wolf, Bug", ["posicao"] = {x = 563, y = 898, z = 6}},
			{["nome"] = "Montanha - 2� Andar - Snake, Goblin", ["posicao"] = {x = 548, y = 913, z = 5}},
			{["nome"] = "Montanha - Subsolo 1 - Snake, Cave Rat, Poison Spider, Bug", ["posicao"] = {x = 568, y = 897, z = 8}},
			{["nome"] = "Montanha - Subsolo 2 - Caminho para Bear, Rotworm, Skeleton", ["posicao"] = {x = 613, y = 866, z = 9}},
			{["nome"] = "Caverna - Rat, Cave Rat, Bug, Spider", ["posicao"] = {x = 565, y = 933, z = 7}},
			{["nome"] = "Ilha Norte - Snake, Bug, Spider, Bear, Wolf, Troll", ["posicao"] = {x = 522, y = 923, z = 7}},
			{["nome"] = "Ilha Norte - Entrada para Caverna dos Skeletons", ["posicao"] = {x = 453, y = 859, z = 7}},
			{["nome"] = "Caverna - Snakes, Spiders, Poison Spiders", ["posicao"] = {x = 535, y = 992, z = 7}},
			{["nome"] = "Resist�ncia dos Trolls - Troll, Orc, Minotaur", ["posicao"] = {x = 661, y = 939, z = 8}},
			{["nome"] = "Forte dos Orcs - Entrada 1 (Pick necess�ria) - Orc, Orc Spearman", ["posicao"] = {x = 602, y = 996, z = 7}},
			{["nome"] = "Forte dos Orcs - Entrada 2 - Orc, Orc Spearman", ["posicao"] = {x = 610, y = 1002, z = 7}},
			{["nome"] = "Vilarejo - Angry Villager", ["posicao"] = {x = 563, y = 1011, z = 7}}
		}
	},
	{
		["nome"] = "Sair da Maruim Island"
	}
}

if configHorestis == nil then
	configHorestis = {
		delay = {
			destruirJarros = 3*60*60,
			aposMatar = 3*60*1000,
			liberarSalaAposMorte = 30*1000
		},
		jogadorSala = false,
		jogadorSaiu = false,
		posicaoTeleporte = {x = 1478, y = 1623, z = 8},
		destinoTeleporte = {x = 1404, y = 1589, z = 8},
		teleport = nil,
		itensNecessarios = {13531, 13532, 13529}
	}
end

function getDistanceBetween(firstPosition, secondPosition)
	local xDif = math.abs(firstPosition.x - secondPosition.x)
	local yDif = math.abs(firstPosition.y - secondPosition.y)
	local posDif = math.max(xDif, yDif)
	if firstPosition.z ~= secondPosition.z then
		posDif = posDif + 15
	end
	return posDif
end

function getFormattedWorldTime()
	local worldTime = getWorldTime()
	local hours = math.floor(worldTime / 60)

	local minutes = worldTime % 60
	if minutes < 10 then
		minutes = '0' .. minutes
	end
	return hours .. ':' .. minutes
end

string.split = function(str, sep)
	local res = {}
	for v in str:gmatch("([^" .. sep .. "]+)") do
		res[#res + 1] = v
	end
	return res
end

string.trim = function(str)
	return str:match'^()%s*$' and '' or str:match'^%s*(.*%S)'
end

if nextUseStaminaTime == nil then
	nextUseStaminaTime = {}
end

function allowMovementEvent(playerId, allow, oldPosition, pz)
    local player = Player(playerId)
    if not player then
        return false
    end

	local position = player:getPosition()
	if pz then
		if not Tile(position):hasFlag(TILESTATE_PROTECTIONZONE) then
			if player:verificarFila() > 0 then
				player:sendCancelMessage(configMasmorras.mensagens.saidaBloqueadaPZ)
			else
				player:sendCancelMessage("Voc� n�o pode sair de uma zona protegida.")
			end
		else
			oldPosition = position
		end
	end

	if allow then
		return stopEvent(event)
	end

	stopEvent(event)

	player:teleportTo(oldPosition, true)

    event = addEvent(allowMovementEvent, 100, playerId, allow, oldPosition, pz)
end

function Player:allowMovement(allow)
    allowMovementEvent(self:getId(), allow, self:getPosition(), false)
end

function Player:allowLeavePz(allow)
    allowMovementEvent(self:getId(), allow, self:getPosition(), true)
end

function atualizarCidades()
	db.query("TRUNCATE TABLE `z_cidades`")
	for a, b in pairs(Game.getTowns()) do
		local posicaoCidade = b:getTemplePosition()
		db.query("INSERT INTO `z_cidades` (`id`, `nome`, `posx`, `posy`, `posz`) VALUES ('" .. a .. "', " .. db.escapeString(formatarNomeCidade(b:getName())) .. ", " .. db.escapeString(posicaoCidade.x) .. ", " .. db.escapeString(posicaoCidade.y) .. ", " .. db.escapeString(posicaoCidade.z) .. ")")
	end
end

itensSemNome = {}
itensSemNomeVerificados = false
itensSemNomeAtual = {}
function verificarItensSemNome()
	print(">> Verificando itens sem nome...")
	for z = 0, 15 do
		for x = 0, 3000 do
			for y = 0, 3000 do
				local tile = Tile(x, y, z)
				if tile then
					if z ~= 7 or (z == 7 and (x < 687 or x > 932) and (y < 2050 or y > 2258)) then
						local itens = tile:getItems()
						local ground = tile:getGround()

						if itens and #itens > 0 then
							for i = 1, #itens do
								if itens[i]:getName() == "" and not isInArray(itensSemNome, itens[i]:getId()) then
									table.insert(itensSemNome, itens[i]:getId())
								end
							end
						end

						if ground then
							if ground:getName() == "" and not isInArray(itensSemNome, ground:getId()) then
								table.insert(itensSemNome, ground:getId())
							end
						end
					end
				end
			end
		end
		print("> Andar " .. z .. " verificado.")
	end
	table.sort(itensSemNome)
	print("> " .. #itensSemNome .. " itens sem nome foram encontrados.")
	itensSemNomeVerificados = true
end

if itensMoviveis == nil then
	itensMoviveis = {}
	itensMoviveisVerificados = false
	itensMoviveisAtual = {}
end

function verificarItensMoviveis()
	if itensMoviveisVerificados then
		return
	end
	print(">> Verificando itens moviveis sem actionId...")
	for z = 0, 15 do
		for x = 0, 3000 do
			for y = 0, 3000 do
				local tile = Tile(x, y, z)
				if tile then
					if (x > 670 and x < 932) and (y > 2031 and y < 2258) then

					elseif (x > 482 and x < 959) and (y > 2318 and y < 2530) then

					else
						local itens = tile:getItems()

						if itens and #itens > 0 then
							for i = 1, #itens do
								if ItemType(itens[i]:getId()):isMovable() and itens[i]:getUniqueId() > 65535 and itens[i]:getActionId() == 0 and not isInArray(itensMoviveis, itens[i]:getId()) then
									table.insert(itensMoviveis, itens[i])
									itens[i]:setActionId(2500)
								end
							end
						end
					end
				end
			end
		end
		print("> Andar " .. z .. " verificado.")
	end
	print("> " .. #itensMoviveis .. " itens moviveis sem actionId foram encontrados e modificados.")
	itensMoviveisVerificados = true
end

function atualizarItens()
	local resultId = db.storeQuery("SELECT `id` FROM `z_itens`")
	if resultId ~= false then
		repeat
		local itemId = result.getDataInt(resultId, "id")
		local editarAtributos = ""
		local itemType = ItemType(itemId)
		if itemType:isStackable() then
			editarAtributos = editarAtributos .. "`agrupavel` = '1'"
		end
		if itemType:isFluidContainer() then
			editarAtributos = editarAtributos .. "`carrega_liquido` = '1'"
		end
		if editarAtributos ~= "" then
			db.query("UPDATE `z_itens` SET " .. editarAtributos .. " WHERE `id` = " .. db.escapeString(itemId))
			print("Item " .. itemId .. " -> atualizado com sucesso.")
		end
		until not result.next(resultId)
		result.free(resultId)
	end
end
