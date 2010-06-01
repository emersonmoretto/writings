title: WIP Actors Model (e com Erlang)
author: Thiago Moretto
date: 2010/06/08
slug: actors_model

Actors Model surgir durante a década de 70, mas esta em evidência novamente com a popularização de processadores multicore e a maior demanda por sistemas escaláveis. Actor model é um modelo matemático, inspirado em leis de física, e foi trazido ao mundo do software. Nesse post pretendo apresentar um pouco sobre Actors, de maneira teoria e depois prática com Erlang.

Na Teoria
=========

Actor
-----

Um Actor é um agente que fica aguardando um estimulo, no caso, uma mensagem. Após isso um Actor pode:

	- Executar uma função (sem side-effects)
	- Responder a mensagem
	- Criar novos actors
	- Enviar novas mensagens
	
Mas Actors essencialmente são assincronos. Quando um actor recebe uma mensagem ele pode responder a qualquer momento. 

Na Prática
==========

Erlang é uma linguagem de paradigma funcional mas focada em concorrencia. Actors são estruturas básicas da linguagem, ou seja, são build-in. Escrever um actor em Erlang, enviar e receber mensagens é muito fácil.

	function() ->
		receive ->
			Pattern






Conclusão
=========



