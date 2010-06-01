title: Paralelismo, uma introdução
author: Thiago Moretto
date: 2010/05/29
slug: paralelismo_uma_intruducao_descomprimissada
keywords: parallelism, side-effects, functional languages, determinism, undeterminism, race condition, shared memory, hazard, virtual memory, map-reduce

**Abstract**: A popularização dos processadores *multicore* surgiu quando a barreira térmica foi atiginda e também pela necessidade de processadores cada vez mais eficientes energéticamente. Esse processadores mais recentes fizeram que ressurgisse um tema as vezes esquecido na programação em geral, paralelismo. Nesse post eu vou fazer falar um pouco sobre, com foco em paralelismo em nível de aplicação.

Quando falo sobre paralelismo posso estar falando de execução paralela, fora de ordem, concorrência, alta-perfomance, escalabilidade, etc. Enfim, o emprego de paralelismo em software pode ser para atingir diferentes objetivos em diferentes problemas. Nesse post vou falar um pouco de problemas e alguns conceitos básicos que estão por trás de execução paralela. É apenas o inicio de um assunto que pode ser longo e vai oferecer uma série de temas para próximos posts.

De volta do passado
===================

Ler o artigo [The Resurgence of Parallelism] [the-resurgence-of-parallelism]  me inspirou a fazer esse post. Leio sobre computação paralela a um bom tempo, sempre gostei. Depois do meu TCC me animei mais ainda. Além disso, eu preciso de vários conceitos dessa área para executar meu trabalho. 

O artigo de *Peter J. Denning* e *Jack B. Dennis* fala sobre a ressurgência do paralelismo, na verdade, pelo que absorvi, o que eles buscam deixar claro no artigo é que paralelismo não é um novo paradigma, na verdade, importantes conceitos fundamentais já foram explorados durante as décadas de 60 e 70 e que muitos desses conceitos estão nos ajudando a resolver problemas atuais, ou seja, não existe um *novo* paradigma. Eu concordo com eles. Repare no ano de publicação dos artigos na bibliografia.

Processadores de alto-desempenho que exploram paralelismo em nível de instrução existem muito antes da *Intel* ou *AMD* (fabricantes *populares*) apresentarem suas linhas *multicore* de processadores. A *HP*, por exemplo, a muito tempo já explorava esse mercado, mas era focado em produzir processadores de alto-desempenho. Você pode encontrar artigos relacionados, busque por HPL-PD.

Compiladores modernos realizam uma série de otimizações buscando otimizar a aplicação para explorar paralelismo em nível de instrução, isso passa desapercebido pelo programador. Compiladores *just-in-time* também fazem muito isso e geralmente são os mais eficientes, pois sabem mais sobre o código, eles encontram com mais eficiência os *hotspots*.

Para uso eficiente desses novos processadores não dá pra depender somente dos compiladores para que estes otimizem o código. As aplicações devem ser otimizadas para o uso eficiente, os compiladores possuem limites, vários algoritmos desses são NP-Completo. Programadores, de modo geral, não precisam se preucupar realmente com o isso, mas isso esta mudando.

Evite *locks*
===========

Paralelismo é algo muito abrangente, é muito além de somente de código, mas nesse post quando me refiro a paralelismo estou dizendo sobre **programação**. Programação paralela é nada mais do que dividir um programa em vários processos menores que executam em paralelo, concorrendo entre si por tempo de processamento, geralmente compartilhando informação, se comunicando, gerando ou aguardando por informações. Obs.: Quando me refiro a processos estou abstraindo, voce pode entender como threads, green-threads, ou como processos *forked*

Processos são executados fora de ordem. Não existe ordem garantida ou conhecida antes da execução, ou seja, não há *determinismo* em relação a ordem de execução dos processos de um programa. Em programas sequenciais você sabe em que ordem você colocou as instruções! A ordem de execução é determinada, não muda. Quando não há determinismo quanto à execução de um programa paralelo, compartilhar informações entre os processo é algo que requer muito cuidado. Se mais de um processo compartilha uma mesma informação e essa informação é mutável, ou seja, qualquer um dos processos pode modificar essa informação, temos o problema de *race condition*.

*Race condition*, no contexto de software, é uma situação onde mais de um processo precisa passar por uma área de código comum onde há estado mutável. Essa é a região crítica que modifica o estado de informação compartilhada, se não houver garantia de que apenas uma linha de execução por vez acesse essa área há chances de que o estado da informação fique em uma situação inválida. O que pode ter efeitos catastróficos.

Para resolver *race conditons*, usamos [*locks*] [lock]. Existem vários tipos de *locks*. [Monitors] [monitors] e [semaphores] [semaphores], por exemplo, são mecanismos que usam *locks* para sincronização, etc. Mas não importa, na maioria das vezes *locks* são ineficientes. Um processo vai ter de esperar o outro terminar para continuar, ou seja, temos uma situação no nosso programa em que a execução fica sequencial. Não importa qual tipo de *lock*, em alguma situação alguma linha de execução vai ter de esperar, ficar em *wait*. Existem várias estruturas de dados para situações de concorrência que são parcialmente *lock-free*, mas devem ser bem avaliadas caso a caso na aplicação do problema. Não bastasse *locks* serem ineficientes, ainda existem os problemas de *dead-lock* e *starvation*.

Para evitar ou minimizar o uso de *locks* é importante explorar *imutabilidade*. Imutabilidade é estado que não se modifica, ou seja, posso ter acesso concorrente, sequencial, não importa, a informação não irá mudar, o estado é consistente, é *deterministico*! Mas deve ser explorado na arquitetura do software e na programação. É um assunto para um post mais prático. Outra forma seria garantir que cada processo tenha a informação que precise, só pra ele, que essa informação seja exclusiva, nenhuma outro processo pode escrever ou ler. E essa informação exclusiva pode ser *mutável* pois estará sendo acessada sequencialmente, apenas pelo linha de execução que possui esse direito. O que eu disse nessa última parte é o que David Parnas da nome: *information hiding* e *context independence*.

Linguagens funcionais não possuem *locks* pois trabalham dessa forma, cada linha de execução possuem seu contexto (*context independence*) e essas informação são exclusivas para cada linha de execução, são escondidas das outras *information hidding*. Além disso, Linguagens funcionais puras exploram *imutabilidade*, não há estado modificável, se há a necessida de alterar um estado um novo é criado! Mas LF é um assunto para um post a parte.

Mas ninguém precisa migrar uma aplicação escrita em uma linguagem Orientada a Objectos, por exemplo, para uma linguagem funcional para fugir de *locks*. Dependendo da arquitetura você pode tomar decisões e suar vários meios para otimizar a aplicação e minimizar a necessidade sincronização de processos. Pode-se tentar *STM* ou mensagens assíncrnas com *Actors* ou usando um serviço de mensageria, etc.







Escalabilidade
--------------

Na primeira parte falei um pouco de conceitos fundamentais, da pra escrever muito sobre isso ainda. Nessa parte vou falar sobre escalabilidade e usar um pouco do que já foi dito. Escababilidade é uma característica. Se um software é escalável estamos dizendo que ele esta preparado para crescer, ou seja, atender mais e mais demanda e continuar funcionando de maneira estável. Claro que existe um limite, mais quanto maior foi esse limite, mais seu software é escalável.

A escalabilidade não depende exclusivamente de software. Também de hardware e toda infraestrutura de comunicação. Existem dois tipos de escabilidade, a vertical e a horizontal. A vertical é dizer que o seu software melhora o desempenho trocando o hardware por um com melhor processador, memória, etc. A horizontal é quando se comprando mais um máquina e colocando do lado da outra o seu software pode usar os dois hardwares eficientemente, e se precisa de mais escalabilidade, é só comprar mais hardware sem descartar o antigo, colocando mais e mais máquina... A grosso modo é isso.

Hoje...
=======

Pra escrever software altamente escalável preciso migrar para LF? Não. Mas é interessante explorar o uso de LF em partes críticas de software, mas minimizando o uso *locks* já é bom começa. 

A escalabilidade vai além da linguagem utilizada, na maioria das situações ainda a o gargalo é onde esta armazenada a informacão, no banco de dados.


[the-resurgence-of-parallelism]: http://cacm.acm.org/magazines/2010/6/92479-the-resurgence-of-parallelism/fulltext
[lock]: http://en.wikipedia.org/wiki/Lock_(computer_science)
[monitors]: http://en.wikipedia.org/wiki/Monitor_(synchronization)
[semaphores]: http://en.wikipedia.org/wiki/Semaphore_(programming)




******Um post a parte******
Linguagens funcionais
---------------------

Existem vários linguagens funcionais, umas mais antigas outras mais novas, algumas outras implementam o paradigma funcional mas são multiparadigma, como é o caso de Scala. O paradigma funcionais, na minha opnião, seria o melhor paradigma pra escrever qualquer software. O paradigma funcional é baseado no lambda-calculos, que se quando baseadas puramente neste não possuem *side-effects*. Porém, é um paradigma mais *díficil*, alguns problemas complexos são resolvidos com maestria usando linguagens funcionais, bem melhor que as linguagens imperativas. Veja esse quicksort em Erlang.

	qsort1([]) ->
    	[];
	
	qsort1([H | T]) -> 
    	qsort1([ X || X <- T, X < H ]) ++ [H] ++ qsort1([ X || X <- T, X >= H ]).

Mas escrever software com linguagem imperativa é muito mais rápido, a curva de aprendizado é bem menor do que seria com o PF. Escrever ou entender um software escrito usando linguagem funcional é quebra-cabeça, necessita pensar recursivamente. A lógica não é sequencial.



Existem vários desafios a serem superados para escrevermos aplicações que exploram paralelismo que estejam corretos e que sejam realmente eficentes. Aplicações concorrentes geralmente são dificeis de testar. Mas isso é assunto para outro post onde pretendo tratar somente sobre testes.

