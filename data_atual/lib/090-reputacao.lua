Reputacao = {
	ranks = {
		{
			nome = "Neutro",
			pontos = 0,
			fraseNpc = "Ol� jovem aprendiz, eu posso lhe designar uma {tarefa}, caso queira."
		},
		{
			nome = "Amig�vel",
			pontos = 100,
			fraseNpc = "Ol� |PLAYERNAME|, voc� deseja verificar suas {tarefas} ou por acaso est� procurando por uma {promo��o}?",
			fraseNpcPromovido = "Ol� |PLAYERNAME|, voc� deseja verificar suas {tarefas} ou visualizar os itens dispon�veis para {negocia��o}?"
		},
		{
			nome = "Empenhado",
			pontos = 500,
			fraseNpc = "Ol� |PLAYERNAME|, voc� deseja verificar suas {tarefas} ou por acaso est� procurando por uma {promo��o}?",
			fraseNpcPromovido = "Ol� |PLAYERNAME|, voc� deseja verificar suas {tarefas} ou visualizar os itens dispon�veis para {negocia��o}?"
		},
		{
			nome = "Respeitado",
			pontos = 1000,
			fraseNpc = "Ol� |PLAYERNAME|, voc� deseja verificar suas {tarefas} ou por acaso est� procurando por uma {promo��o}?",
			fraseNpcPromovido = "Ol� |SENHOR| |PLAYERNAME|, voc� deseja verificar suas {tarefas} ou visualizar os itens dispon�veis para {negocia��o}?"
		},
		{
			nome = "Reverenciado",
			pontos = 2000,
			fraseNpc = "Ol� |PLAYERNAME|, voc� deseja verificar suas {tarefas} ou por acaso est� procurando por uma {promo��o}?",
			fraseNpcPromovido = "Ol� |MESTRE| |PLAYERNAME|, voc� deseja verificar suas {tarefas} ou visualizar os itens dispon�veis para {negocia��o}?"
		},
		{
			nome = "Exaltado",
			pontos = 5000,
			fraseNpc = "Ol� |PLAYERNAME|, voc� deseja verificar suas {tarefas} ou por acaso est� procurando por uma {promo��o}?",
			fraseNpcPromovido = "Ol� |VOCATIONNAME| |PLAYERNAME|, voc� deseja verificar suas {tarefas} ou visualizar os itens dispon�veis para {negocia��o}?"
		}
	},
	loja = {
		[9942] = {preco = 100, reputacao = 1},
		[9941] = {preco = 100, reputacao = 1},
		[9980] = {preco = 100, reputacao = 1},
	},
	promocao = 100,
	viagem = {
		valor = 100,
		valorRetorno = 300,
		tempoRetorno = 15*60,
		acessoLiberado = 500
	}
}

function pegarNpcReputacao(vocacaoId)
	if vocacaoId == 1 or vocacaoId == 5 then
		return "Etevi Drayn"
	elseif vocacaoId == 2 or vocacaoId == 6 then
		return "Drorist Suhariux"
	elseif vocacaoId == 3 or vocacaoId == 7 then
		return "Arti Earth"
	elseif vocacaoId == 4 or vocacaoId == 8 then
		return "Gras Fravotroth"
	end
end
