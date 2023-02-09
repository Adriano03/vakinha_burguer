# vakinha_burguer

Projeto Flutter - Vakinha Burger

## Getting Started

Projeto de delivery desenvolvido pelo Rodrigo Rahman no evento DartWeek 9, o propósito do app é o usuário fazer compras de
 lanches escolhendo quais lanches quiser e ir adicionando a sacola, isso sem precisar ter feito login. Mas ao clicar na sacola é redirecionado para a tela de login e cadastro onde poderá criar sua conta. Com sua conta criada é redirecionado para a tela de pedidos que contém todos os produtos adicionados, preços totais podendo adicionar mais ou retirar e até excluir. Mais a baixo contém alguns dados para entrega como endereço, cpf e tipo de pagamento clicando em finalizar o pedido é armazenado no backend e redirecionado para a tela de sucesso confirmando seu pedido.  O app utiliza a arquitetura MVC, para a gerência de estado é usado o Bloc e Provider e banco de dados local json_rest_server.

Aula 1  
- Preparando e subindo o backend;
- Instalando e configurando imagens e fontes do projeto;
- Configuração de todo o tema do projeto;
- Preparação das extensions de UI;
- Preparação do ButtonStyles (Botão Personalizado), para evitar repetição de código,
- Preparação Core da aplicação;
- Utilização do pacote flutter_dotenev para configurar a variável de ambiente;
- Configuração do RestClient utilizando o Dio;
- Para manter o código mais limpo, utilização de helpers para obter o tamanho da tela;

Aula 2
- Criação da Splash Page;
- Configuração da classe de modelo;
- Utilização do conceito repository pattern para buscar produtos;
- Criação e implementação da tela Home Page;
- Estruturação do projeto para trabalhar com bloc;
- Link entre controller e repository;
- Criação do BaseState;

Aula 3
- Criação da tela detalhe produto;
- Criação botão increment e decrement;
- Adicionando produtos no carrinho;
- Atualização na quantidade de produtos e regras de negócio;

Aula 4
- Criar e implementar tela de cadastro;
- Regra de negócio caso o login seja expirado, pop() para a home com mensagem de aviso;
- Criar e implementar tela de login;
- Criar e implementar tela de order;
- Validação formulário order;
- Ajustar botão de increment e decrement para ser compacto;
- Carregar os produtos cadastrados na order;

Aula 5
- Implementação authinterceptor para adicionar token na requisição;
- Em order buscar formas de pagamento na api;
- Atualizar sacola ao voltar para o menu;
- Deletar produto quando incrementado para zero em order;
- Confirmação de exclusão de um produto, ou de toda a sacola;
- Tratamento de login expirado, quando expirar o usuário perde acesso a tela order e exibe a mensagem login expirado;
- Construção da página de sucesso, só é chamada quando o usuário tem produtos no carrinho preenche os campos com dados validos e clica em finalizar;

Extras
- Implementação do refreshToken para o usuário não perder acesso ao app, pelo tempo determinado na api;
- ValueNotifier para gerenciar estado da senha e confirmar senha, fazendo que fique obscuro ou não;
- Correções no uso do aplicativo com o dispositivo no modo paisagem (na horizontal).
- Splash screen estava tendo overflow na horizontal, então apenas quando está na horizontal é retirado uma das imagens e redimensionado o layout da tela para ficar mais agradável;
- Na tela de ordens estavam tendo vários problemas com o tamanho quando usado na horizontal. Então com a funcionalidade Orientation foi feito ajustes na largura do botão, na scrollView, e tamanho da tela;
- Adição de máscara para o campo cpf em order;

