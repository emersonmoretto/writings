title: Experiências em um projeto de missão-crítica
author: Thiago Moretto
date: 2010/07/02
slug: experiencias_captura_transacoes


Na temporada 2009/10, mais precisamente de julho/09 até esse último mês de maio estive envolvido em um projeto de um porte significativo. Eu e mais um colega fomos encubidos de arquitetar e desenvolver uma solução para um sistema de captura e processamento de transações, com requisitos não-funcionais pra lá de exigentes. Nesse texto vou tentar expor um poucas das minhas boas e más experiências que adquiri com esse projeto de missão-crítica.

<img align="left" style="margin-right:20px" src="/images/perigo.jpg" alt="Perigo..." />

Ser escalável, performático, disponível, confiável e flexível são alguns dos requisitos que esse sistema deve ter. Na verdade, são vários sistemas, chamamos internamente de módulos, cada um com sua responsabilidade e totalmente indepententes. Ainda não posso dizer tantos detalhes desse sistema, mas hoje ele esta sendo feito em Java. Já há alguns módulos independentes em produção, capturando transações de pagamento eletrônico, recarga pré-paga, etc.

As experiências que ganhei nesse projeto posso expor em formato de dicas ou sugestões. Algumas, talvez a maioria, servem pra qualquer projeto, mas enfim. São elas:

- Design emergente: Não adianta querer pensar tudo antes, não fixe nenhum design. Faça continuamente e mantenha as coisas simples. Mas tome cuidado, não deixei partes críticas pra muito depois, vá até o *last responsible moment* ou você terá sério problemas.

- Faça leve: Não exagere nas singlas, esqueça JavaEE e frameworks "pesados", use os pequenos e potentes, para que você consiga abrir o código-fonte e *hackea-lo*. Você deve ter total dominio nas ferramentas de terceiros que você esta utilizando. Evite os betas.

- Faça *benchmarks* o tempo todo! Mas começe fazendo das partes antes de ir  ao todo. Isso irá ajudará a evitar esforço demasiado tentando descobrir o gargalo. E automatize! Ou pelo menos, tente.

- Se inspire no que cerca as linguages funcionais, estudar Erlang, Haskell e Scala te dará ideias e conceitos para implementar. E se você tiver flexibilidade de escolher plataforma, dê muita atenção a Scala e Erlang! Mas **jamais** desenvolva um software de missão-crítica sem que você ou alguém sua equipe tenha domínio nato na plataforma. Na dúvida, vá no garantido. 

- Dê atenção a bancos *NoSQL*. Faça experimentos e benchmarks. BerkeleyDB, Tokyo Cabinet, Mongo, CouchDB, Redis, Cassandra, etc. Existem dezenas de soluções estáveis e outras várias surgindo. Alguma poderá te ajudar.

- Não exagere de recursos sofisticados na versão 1.0. Coloque o essencial para funcionar com apenas uma pitada de sofisticação. Otimizações são melhores feitas quando você tem informações reais de como o sistema se comporta em produção. Portanto, monitore.

- Promova *brainstorms* e seja teimoso com suas idéias. *Brainstorms* irão de ajudar a pensar em melhores soluções e detectar problemas mais cedo. Mas seja teimoso e resistente a todas ideias e soluções, isso forçará a todos a buscar argumentações cada vez mais forte contra ou a favor as ideias propostas.

- Testes, testes e mais testes. Aproveite o use algum software de integração contínua e outro de métrica de software, recomendo e o Hudson e o Sonar, respectivamente.

- Fuja do Maven. Já fiz propaganda e até uma mini-palestra sobre o Maven, mas hoje já não o recomendo. Hoje o projeto usa Maven, mas apenas pra gerenciar dependências, o Ant faz os processos de build e packaging p/ teste/homologação e produção. Você pode usar o Ant, mas dê uma boa olhada no Rake, esse último seria a minha escolha se iniciasse o projeto hoje.

- Leia muito sobre programação paralela/concorrente, existem algoritmos e conceitos que poderão ser um diferencial. Quando você não encontrar nada reusável que resolva um problema adequado, você terá que programar. 

- Lembre-se sempre: *Locks* são mals! Evite-os, mas não exagere, evite-os onde realmente precisa, se não só será perda de tempo. Conhecimentos em programação concorrente/paralela é fundamental aqui.

- Use *standards* leves. Nada de WS-\*, exceto quando realmente necessário. Pra ter ideias, a maioria dos sistemas de capturas de transações usam ISO8583. Nós usamos a versão de 1987. O que acho disso? Acho ótimo, ISO8583 é muito leve, confiável, simples e **funciona**. Suas compras com cartão de créditos são trafegadas em ISO8583, seja ela Master ou Visa, e eu não precisei perguntar pra ninguém. *Protobuf* e *thrift* são boas opções.

Essas sugestões são as que destaquei e conseguir lembrar. Se você já se envolveu em projetos desse porte, que experiências você compartilha? Quais você concorda ou discorda comigo? Comente.


