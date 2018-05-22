configTasks = {
	storageBase = 30000,
	progresso = 2000,
	valorIniciada = 1,
	valorCompleta = 2,
	valorFinalizada = 3,
	modalInicio = 10,
	modalTasksDisponiveis = 1,
	modalTasksProgresso = 2,
	modalTasksRealizadas = 3,
	modalTasksDisponiveisInfo = 4,
	modalTasksProgressoInfo = 5,
	modalTasksRealizadasInfo = 6,
	modalTasksRecompensas = 7,
	modalTasksAbandonar = 8,
	modalTasksAbandonarInfo = 9,
	limiteTasksProgresso = 3
}
-- Exemplo de Configura��o:
-- [idTarefa - Opcional] = {
	-- nivelMinimo = int - Opcional,
	-- nivelMaximo = int - Opcional,
	-- reputacao = int - Opcional,
	-- criatura = table{var} - Obrigat�rio,
	-- recompensa = {
		-- dinheiro = table{min, max} ou int - Opcional,
		-- experiencia = table{min, max} ou int - Opcional,
		-- item = table{int, table{min, max} ou int} - Opcional,
		-- nivel = int,
		-- reputacao = int,
		-- outfit = var,
		-- addon = table{var, int(1, 2 ou 3)},
		-- montaria = var
	-- }
-- }
Tasks = {
	{
		nivelMinimo = 0,
		nivelMaximo = 0,
		repetir = 1,
		quantidade = 50,
		criaturas = {"vampire"},
		recompensa = {reputacao = 200}
	},
	{
		nivelMinimo = 0,
		nivelMaximo = 0,
		quantidade = 50,
		repetir = 1,
		criaturas = {"fire elemental"},
		recompensa = {reputacao = 200}
	},
	{
		nivelMinimo = 0,
		nivelMaximo = 0,
		quantidade = 40,
		repetir = 0,
		nome = "rotworms",
		criaturas = {"rotworm", "carrion worm"},
		recompensa = {reputacao = 100}
	},
	{
		nivelMinimo = 0,
		nivelMaximo = 0,
		quantidade = 40,
		repetir = 0,
		criaturas = {"minotaur"},
		recompensa = {reputacao = 100}
	},
	{
		nivelMinimo = 0,
		nivelMaximo = 0,
		quantidade = 40,
		repetir = 0,
		criaturas = {"larva"},
		recompensa = {reputacao = 100}
	},
	{
		nivelMinimo = 0,
		nivelMaximo = 0,
		quantidade = 40,
		repetir = 0,
		nome = "goblins",
		criaturas = {"goblin", "goblin assassin", "goblin scavenger"},
		recompensa = {reputacao = 100}
	}
}
listaTasks = {}
for a, b in pairs(Tasks) do
	table.insert(listaTasks, configTasks.storageBase+configTasks.modalInicio+a)
end

function Player:iniciarTask(taskId)
	local task = Tasks[taskId]
	if self:getStorageValue(configTasks.storageBase) ~= 1 then
		self:setStorageValue(configTasks.storageBase, 1)
	end
	self:setStorageValue(configTasks.storageBase+taskId, configTasks.valorIniciada)
	self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Nova tarefa iniciada.")
end

function Player:verificarStatusTask(taskId)
	return math.max(0, self:getStorageValue(configTasks.storageBase+taskId))
end

function Player:verificarProgressoTask(taskId)
	return math.max(0, self:getStorageValue(configTasks.storageBase+configTasks.progresso+taskId))
end

function Player:adicionarProgressoTask(taskId)
	local task = Tasks[taskId]
	local progressoTask = self:verificarProgressoTask(taskId)+1
	self:setStorageValue(configTasks.storageBase+configTasks.progresso+taskId, progressoTask)
	local mensagem = "Atualiza��o de Tarefa: " .. progressoTask .. "/" .. task.quantidade .. " - " .. capAll(pegarNomeTask(taskId, true))
	if progressoTask == task.quantidade then
		mensagem = mensagem .. " - Completa"
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, mensagem)
		self:completarTask(taskId)
		return
	end
	self:sendTextMessage(MESSAGE_EVENT_ADVANCE, mensagem)
end

function Player:completarTask(taskId)
	local task = Tasks[taskId]
	if task.recompensa ~= nil then
		local recompensa = task.recompensa

		if recompensa.dinheiro ~= nil then
			local valorRecompensa = recompensa.dinheiro
			if type(valorRecompensa) == "table" then
				valorRecompensa = math.random(valorRecompensa[1], valorRecompensa[2])
			end
			self:addMoneyBank(valorRecompensa)
			self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Recompensa de Tarefa: A quantia de " .. valorRecompensa .. " gp foi depositada em sua conta banc�ria.")
		end

		if recompensa.nivel ~= nil then
			local valorRecompensa = recompensa.nivel
			local exibirRecompensa = valorRecompensa .. " n�v"
			if valorRecompensa == 1 then
				exibirRecompensa = exibirRecompensa .. "el"
			else
				exibirRecompensa = exibirRecompensa .. "eis"
			end
			self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Recompensa de Tarefa: Voc� recebeu " .. exibirRecompensa .. ".")
			for a = 1, valorRecompensa do
				self:addLevel()
			end
		end

		if recompensa.experiencia ~= nil then
			local valorRecompensa = recompensa.experiencia
			if type(valorRecompensa) == "table" then
				valorRecompensa = math.random(valorRecompensa[1], valorRecompensa[2])
			end
			local exibirRecompensa = valorRecompensa .. " ponto"
			if valorRecompensa > 1 then
				exibirRecompensa = exibirRecompensa .. "s"
			end
			self:addExperience(valorRecompensa)
			self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Recompensa de Tarefa: Voc� recebeu " .. exibirRecompensa .. " de experi�ncia.")
		end

		if recompensa.reputacao ~= nil then
			local valorRecompensa = recompensa.reputacao
			local exibirRecompensa = valorRecompensa .. " ponto"
			if valorRecompensa > 1 then
				exibirRecompensa = exibirRecompensa .. "s"
			end
			self:adicionarReputacao(valorRecompensa)
			self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Recompensa de Tarefa: Voc� recebeu " .. exibirRecompensa .. " de reputa��o.")
		end

		if recompensa.outfit ~= nil then
			local valorRecompensa = self:pegarOutfitLookType(recompensa.outfit)
			self:addOutfit(valorRecompensa)
			self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Recompensa de Tarefa: Voc� recebeu o outfit '" .. pegarOutfitNome(valorRecompensa) .. "'.")
		end

		if recompensa.addon ~= nil then
			local valorRecompensa = {self:pegarOutfitLookType(recompensa.addon[1]), recompensa.addon[2]}
			self:addOutfitAddon(valorRecompensa[1], valorRecompensa[2])
			self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Recompensa de Tarefa: Voc� recebeu " .. exibirAddon(valorRecompensa[2], true) .. " do outfit '" .. pegarOutfitNome(valorRecompensa[1]) .. "'.")
		end

		if recompensa.montaria ~= nil then
			local valorRecompensa = pegarMontariaId(recompensa.montaria)
			self:addMount(valorRecompensa)
			self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Recompensa de Tarefa: Voc� recebeu a montaria '" .. recompensa.montaria .. "'.")
		end

		if recompensa.item ~= nil then
			self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Recompensa de Tarefa: Voc� recebeu " .. exibirTaskItemRecompensa(recompensa.item) .. ". V� a algum NPC de Tarefas para retir�-lo.")
		else
			self:finalizarTask(taskId)
			return true
		end
	end
	self:setStorageValue(configTasks.storageBase+taskId, configTasks.valorCompleta)
end

function Player:checarTaskCompleta(taskId)
	local statusTask = self:verificarStatusTask(taskId)
	if statusTask == configTasks.valorCompleta or statusTask == configTasks.valorFinalizada then
		return true
	end
	return false
end

function Player:finalizarTask(taskId)
	self:setStorageValue(configTasks.storageBase+configTasks.progresso+taskId, 0)
	self:setStorageValue(configTasks.storageBase+taskId, configTasks.valorFinalizada)
end

function Player:abandonarTask(taskId)
	self:sendTextMessage(MESSAGE_INFO_DESCR, "Voc� abandonou com sucesso a tarefa '" .. pegarNomeTask(taskId) .. "'.")
	self:setStorageValue(configTasks.storageBase+configTasks.progresso+taskId, 0)
	self:setStorageValue(configTasks.storageBase+taskId, 0)
end

function Creature:checarTask()
	local tasks = {}
	for a, b in pairs(Tasks) do
		if isInArray(b.criaturas, string.lower(self:getName())) then
			table.insert(tasks, a)
		end
	end
	return tasks
end

function Player:pegarTasksDisponiveis()
	local tasks = {}
	if #self:pegarTasksProgresso() == configTasks.limiteTasksProgresso then
		return tasks
	end
	for a, b in pairs(Tasks) do
		local playerLevel = self:getLevel()
		local statusTask = self:verificarStatusTask(a)
		if	(statusTask == 0 or (b.repetir == 1 and statusTask == configTasks.valorFinalizada)) and
			((b.nivelMinimo == nil) or (b.nivelMinimo == 0) or (b.nivelMinimo > 0 and playerLevel >= b.nivelMinimo)) and
			((b.nivelMaximo == nil) or (b.nivelMaximo == 0) or (b.nivelMaximo > 0 and playerLevel <= b.nivelMaximo)) and
			((b.reputacao == nil) or (b.reputacao == 0) or (b.reputacao > 0 and self:pegarReputacao() >= b.reputacao)) then
			table.insert(tasks, a)
		end
	end
	return tasks
end

function Player:pegarTasksProgresso()
	local tasks = {}
	for a, b in pairs(Tasks) do
		local playerLevel = self:getLevel()
		if self:verificarStatusTask(a) == configTasks.valorIniciada then
			table.insert(tasks, a)
		end
	end
	return tasks
end

function Player:pegarTasksRealizadas()
	local tasks = {}
	for a, b in pairs(Tasks) do
		local playerLevel = self:getLevel()
		local statusTask = self:verificarStatusTask(a)
		if statusTask == configTasks.valorCompleta or statusTask == configTasks.valorFinalizada then
			table.insert(tasks, a)
		end
	end
	return tasks
end

function Player:checarTasksRecompensa()
	for a, b in pairs(Tasks) do
		local playerLevel = self:getLevel()
		if	self:verificarStatusTask(a) == 2 and
			b.recompensa.item ~= nil then
			return true
		end
	end
	return false
end

function Player:pegarTasksRecompensa()
	local tasks = {}
	for a, b in pairs(Tasks) do
		local playerLevel = self:getLevel()
		if	self:verificarStatusTask(a) == 2 and
			b.recompensa.item ~= nil then
			table.insert(tasks, a)
		end
	end
	return tasks
end

function Player:enviarTasksModalPrincipal()
	local reputacaoRankId = self:pegarRankReputacao()
	local reputacaoProximoRank = pegarReputacaoRank(reputacaoRankId+1)
	local exibirReputacao = "Pontos de Reputa��o: " .. self:pegarReputacao()
	if not reputacaoProximoRank == false then
		exibirReputacao = exibirReputacao .. "/" .. reputacaoProximoRank
	end
	local modalTitulo = "Tarefas - " .. pegarNomeRank(reputacaoRankId) .. " - " .. exibirReputacao
	local modalMensagem = "Voc� pode escolher uma das op��es abaixo para verificar as tarefas correspondentes.\n\nO que voc� deseja fazer?\n"
	local modal = ModalWindow(configTasks.storageBase, modalTitulo, modalMensagem)
	if self:checarTasksRecompensa() then
		modal:addChoice(4, "Pegar Recompensas Dispon�veis")
	end
	modal:addChoice(1, "Lista de Tarefas - Dispon�veis")
	modal:addChoice(2, "Lista de Tarefas - Em Progresso")
	modal:addChoice(3, "Lista de Tarefas - Realizadas")
	modal:addChoice(5, "Abandonar Tarefas")
	modal:addButton(1, "Ok")
	modal:setDefaultEnterButton(1)
	modal:addButton(2, "Sair")
	modal:setDefaultEscapeButton(2)
	modal:sendToPlayer(self)
end

function Player:enviarTasksModalDisponiveis()
	local modalTitulo = "Lista de Tarefas - Dispon�veis"
	local modalMensagem = "Selecione uma tarefa na lista e realize uma das a��es citadas abaixo:\n\nClique no bot�o 'Iniciar', tecle 'Enter' ou d� dois cliques para iniciar a tarefa.\nClique no bot�o 'Info' para verificar todas as informa��es da tarefa selecionada.\n"
	local modalId = configTasks.storageBase+configTasks.modalTasksDisponiveis
	local modal = ModalWindow(modalId, modalTitulo, modalMensagem)
	local listaTasks = self:pegarTasksDisponiveis()
	if #listaTasks > 0 then
		for a, b in pairs(listaTasks) do
			modal:addChoice(b, pegarNomeTask(b, false, 65))
		end
		modal:addButton(4, "Info")
		modal:setDefaultEnterButton(1)
		modal:addButton(2, "Sair")
		modal:addButton(1, "Iniciar")
		modal:setDefaultEscapeButton(2)
		modal:addButton(3, "Voltar")
		modal:sendToPlayer(self)
	else
		self:enviarTasksModalVazio(modalId)
	end
end

function Player:enviarTasksModalProgresso()
	local modalTitulo = "Lista de Tarefas - Progresso"
	local modalMensagem = "Selecione uma tarefa na lista e clique no bot�o 'Info', tecle 'Enter' ou d� dois cliques para verificar todas as informa��es da tarefa selecionada.\n"
	local modalId = configTasks.storageBase+configTasks.modalTasksProgresso
	local modal = ModalWindow(modalId, modalTitulo, modalMensagem)
	local listaTasks = self:pegarTasksProgresso()
	if #listaTasks > 0 then
		for a, b in pairs(listaTasks) do
			modal:addChoice(b, pegarNomeTask(b))
		end
		modal:addButton(1, "Info")
		modal:setDefaultEnterButton(1)
		modal:addButton(2, "Sair")
		modal:setDefaultEscapeButton(2)
		modal:addButton(3, "Voltar")
		modal:sendToPlayer(self)
	else
		self:enviarTasksModalVazio(modalId)
	end
end

function Player:enviarTasksModalRealizadas()
	local modalTitulo = "Lista de Tarefas - Realizadas"
	local modalMensagem = "Selecione uma tarefa na lista e clique no bot�o 'Info', tecle 'Enter' ou d� dois cliques para verificar todas as informa��es da tarefa selecionada.\n"
	local modalId = configTasks.storageBase+configTasks.modalTasksRealizadas
	local modal = ModalWindow(modalId, modalTitulo, modalMensagem)
	local listaTasks = self:pegarTasksRealizadas()
	if #listaTasks > 0 then
		for a, b in pairs(listaTasks) do
			modal:addChoice(b, pegarNomeTask(b))
		end
		modal:addButton(1, "Info")
		modal:setDefaultEnterButton(1)
		modal:addButton(2, "Sair")
		modal:setDefaultEscapeButton(2)
		modal:addButton(3, "Voltar")
		modal:sendToPlayer(self)
	else
		self:enviarTasksModalVazio(modalId)
	end
end

function Player:enviarTasksModalRecompensas()
	local modalTitulo = "Tarefas - Recompensas Dispon�veis"
	local modalMensagem = "Selecione uma recompensa na lista e clique no bot�o 'Retirar', tecle 'Enter' ou d� dois cliques para retirar a recompensa da tarefa selecionada.\n"
	local modalId = configTasks.storageBase+configTasks.modalTasksRecompensas
	local modal = ModalWindow(modalId, modalTitulo, modalMensagem)
	local listaTasks = self:pegarTasksRecompensa()
	if #listaTasks > 0 then
		for a, b in pairs(listaTasks) do
			modal:addChoice(b, exibirTaskItemRecompensa(Tasks[b].recompensa.item) .. " - Tarefa: " .. pegarNomeTask(b))
		end
		modal:addButton(1, "Retirar")
		modal:setDefaultEnterButton(1)
		modal:addButton(2, "Sair")
		modal:setDefaultEscapeButton(2)
		modal:addButton(3, "Voltar")
		modal:sendToPlayer(self)
	else
		self:enviarTasksModalVazio(modalId)
	end
end

function Player:enviarTasksModalAbandonar()
	local modalTitulo = "Abandonar Tarefas"
	local modalMensagem = "Selecione uma tarefa na lista e clique no bot�o 'Abandonar', tecle 'Enter' ou d� dois cliques para abandonar a tarefa selecionada.\n"
	local modalId = configTasks.storageBase+configTasks.modalTasksAbandonar
	local modal = ModalWindow(modalId, modalTitulo, modalMensagem)
	local listaTasks = self:pegarTasksProgresso()
	if #listaTasks > 0 then
		for a, b in pairs(listaTasks) do
			modal:addChoice(b, pegarNomeTask(b))
		end
		modal:addButton(4, "Info")
		modal:setDefaultEnterButton(1)
		modal:addButton(2, "Sair")
		modal:addButton(1, "Abandonar")
		modal:setDefaultEscapeButton(2)
		modal:addButton(3, "Voltar")
		-- modal:addButton(1, "Abandonar")
		-- modal:setDefaultEnterButton(1)
		-- modal:addButton(2, "Sair")
		-- modal:setDefaultEscapeButton(2)
		-- modal:addButton(3, "Voltar")
		modal:sendToPlayer(self)
	else
		self:enviarTasksModalVazio(modalId)
	end
end

function Player:enviarTasksModalVazio(modalId)
	local modalTitulo = "Aviso"
	local modalMensagem = "N�o h� nenhuma tarefa para ser exibida.\nClique no bot�o 'Voltar' e selecione outra op��o."
	local modal = ModalWindow(modalId, modalTitulo, modalMensagem)
	modal:addButton(3, "Voltar")
	modal:addButton(2, "Sair")
	modal:setDefaultEscapeButton(2)
	modal:setDefaultEnterButton(3)
	modal:sendToPlayer(self)
end

function Player:enviarTasksModalInfo(taskId, modalId)
	local task = Tasks[taskId]
	local statusTask = self:verificarStatusTask(taskId)
	local modalTitulo = "Tarefa - " .. pegarNomeTask(taskId, false, 33) .. " - Informa��es"
	local modalMensagem = ""
	if statusTask == 0 then
		modalMensagem = "Clique no bot�o 'Iniciar' ou tecle 'Enter' para iniciar a tarefa.\n\n"
	elseif statusTask == configTasks.valorIniciada then
		modalMensagem = "Confira abaixo as informa��es da tarefa selecionada que est� em progresso.\n\n"
	elseif statusTask == configTasks.valorCompleta or statusTask == configTasks.valorFinalizada then
		modalMensagem = "Confira abaixo as informa��es da tarefa selecionada que foi realizada com sucesso.\n\n"
	end
	modalMensagem = modalMensagem .. "Objetivo\n"
	modalMensagem = modalMensagem .. "Matar " .. pegarNomeTask(taskId) .. "\n"
	if statusTask == configTasks.valorIniciada then
		modalMensagem = modalMensagem .. "Criaturas Mortas at� agora: " .. self:verificarProgressoTask(taskId) .. "\n"
	end
	modalMensagem = modalMensagem .. "\nRequisito\n"
	if	(task.nivelMinimo ~= nil and task.nivelMinimo > 0) or
		(task.nivelMaximo ~= nil and task.nivelMaximo > 0) or
		(task.reputacao ~= nil and task.reputacao > 0) then
		if task.nivelMinimo ~= nil and task.nivelMinimo > 0 then
			modalMensagem = modalMensagem .. "N�vel M�nimo: " .. task.nivelMinimo .. "\n"
		end
		if task.nivelMaximo ~= nil and task.nivelMaximo > 0 then
			modalMensagem = modalMensagem .. "N�vel M�ximo: " .. task.nivelMaximo .. "\n"
		end
		if task.reputacao ~= nil and task.reputacao > 0 then
			modalMensagem = modalMensagem .. "Reputa��o Necess�ria: " .. task.reputacao .. "\n"
		end
	else
		modalMensagem = modalMensagem .. "Nenhum\n"
	end
	modalMensagem = modalMensagem .. "\nRecompensa\n"
	local recompensa = task.recompensa

	if recompensa.dinheiro ~= nil then
		local exibirTaskDinheiro = recompensa.dinheiro
		if type(exibirTaskDinheiro) == "table" then
			exibirTaskDinheiro = "Entre " .. exibirTaskDinheiro[1] .. " e " .. exibirTaskDinheiro[2] .. " gp"
		end
		modalMensagem = modalMensagem .. "Dinheiro: " .. exibirTaskDinheiro .. "\n"
	end

	if recompensa.experiencia ~= nil then
		local exibirTaskExperiencia = recompensa.experiencia
		if type(exibirTaskExperiencia) == "table" then
			exibirTaskExperiencia = "Entre " .. exibirTaskExperiencia[1] .. " e " .. exibirTaskExperiencia[2]
		end
		modalMensagem = modalMensagem .. "Experi�ncia: " .. exibirTaskExperiencia .. "\n"
	end

	if recompensa.item ~= nil then
		modalMensagem = modalMensagem .. "Item: " .. exibirTaskItemRecompensa(recompensa.item) .. "\n"
	end

	if recompensa.nivel ~= nil then
		modalMensagem = modalMensagem .. "N�vel: " .. recompensa.nivel .. "\n"
	end

	if recompensa.reputacao ~= nil then
		modalMensagem = modalMensagem .. "Reputa��o: " .. recompensa.reputacao .. "\n"
	end

	if recompensa.outfit ~= nil then
		modalMensagem = modalMensagem .. "Outfit: " .. recompensa.outfit .. "\n"
	end

	if recompensa.addon ~= nil then
		modalMensagem = modalMensagem .. firstToUpper(exibirAddon(recompensa.addon[2])) .. " do outfit '" .. recompensa.addon[1] .. "'\n"
	end

	if recompensa.montaria ~= nil then
		modalMensagem = modalMensagem .. "Montaria: " .. recompensa.montaria .. "\n"
	end

	if task.repetir == 1 and (statusTask == configTasks.valorCompleta or statusTask == configTasks.valorFinalizada) then
		modalMensagem = modalMensagem .. "\nCaso queira, voc� pode realiz�-la novamente. Para isso, clique no bot�o 'Iniciar'.\n"
	end

	local modal = ModalWindow(configTasks.storageBase+modalId, modalTitulo, modalMensagem)
	modal:addButton(3, "Voltar")
	modal:addButton(2, "Sair")
	if #self:pegarTasksProgresso() < configTasks.limiteTasksProgresso and (statusTask == 0 or (task.repetir == 1 and (statusTask == configTasks.valorCompleta or statusTask == configTasks.valorFinalizada))) then
		modal:addButton(1, "Iniciar")
		if statusTask == 0 then
			modal:setDefaultEnterButton(1)
		end
	end
	modal:setDefaultEscapeButton(2)
	if statusTask > 0 then
		modal:setDefaultEnterButton(3)
	end
	modal:sendToPlayer(self)
end

function Player:retirarRecompensa(taskId)
	local recompensa = Tasks[taskId].recompensa.item
	local item = recompensa[1]
	local quantidade = recompensa[2]
	if type(quantidade) == "table" then
		quantidade = math.random(quantidade[1], quantidade[2])
	end
	local peso = ItemType(item):getWeight()
	if self:getFreeCapacity() >= peso then
		if self:addItemEx(Game.createItem(item, quantidade)) == 0 then
			self:finalizarTask(taskId)
			self:sendTextMessage(MESSAGE_INFO_DESCR, "Voc� obteve " .. pegarNomeItem(item, quantidade) .. ".")
		else
			self:sendTextMessage(MESSAGE_INFO_DESCR, "Voc� n�o possui espa�o para receber o item.")
		end
	else
		self:sendTextMessage(MESSAGE_INFO_DESCR, "Essa recompensa pesa " .. peso .. " oz. � muito pesada para voc� carregar.")
	end
	return true
end

function pegarNomeTask(taskId, ocultarQuantidade, limiteCaracteres)
	local task = Tasks[taskId]
	local nomeTask = ""

	for a, b in pairs(task.criaturas) do
		nomeTask = nomeTask .. capAll(b)
		if a == #task.criaturas - 1 then
			nomeTask = nomeTask .. " ou "
		elseif a < #task.criaturas - 1 then
			nomeTask = nomeTask .. ", "
		end
	end

	local exibirNomeTask
	if task.nome and #task.criaturas > 1 then
		exibirNomeTask = capAll(task.nome) .. " (" .. nomeTask .. ")"
	else
		exibirNomeTask = nomeTask
	end

	if not ocultarQuantidade then
		exibirNomeTask = task.quantidade .. " " .. exibirNomeTask
	end

	if limiteCaracteres ~= nil then
		if #exibirNomeTask > limiteCaracteres then
			exibirNomeTask = exibirNomeTask:sub(0, limiteCaracteres) .. "..."
		end
	end

	return exibirNomeTask
end

function pegarNomeItem(item, quantidade)
	local itemType = ItemType(item)
	local nomeItem = itemType:getName()
	if quantidade > 1 then
		nomeItem = itemType:getPluralName()
	end
	return quantidade .. " '" .. nomeItem .. "'"
end

function exibirTaskItemRecompensa(item)
	local exibirItem = capAll(ItemType(item[1]):getName())
	if type(item[2]) == "table" then
		exibirItem = exibirItem .. " - entre " .. item[2][1] .. " e " .. item[2][2]
	else
		exibirItem = exibirItem .. " - " .. item[2]
	end
	return exibirItem
end
